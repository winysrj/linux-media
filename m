Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40680 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751287AbcHVIUE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 04:20:04 -0400
Subject: Re: [PATCH 4/4] pulse8-cec: sync configuration with adapter
To: Johan Fjeldtvedt <jaffe1@gmail.com>, linux-media@vger.kernel.org
References: <1471624576-9823-1-git-send-email-jaffe1@gmail.com>
 <1471624576-9823-4-git-send-email-jaffe1@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dea24eba-c4da-95a8-c123-303fbbed7058@xs4all.nl>
Date: Mon, 22 Aug 2016 10:19:58 +0200
MIME-Version: 1.0
In-Reply-To: <1471624576-9823-4-git-send-email-jaffe1@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 06:36 PM, Johan Fjeldtvedt wrote:
> When the configuration is changed, they are also written to the adapter.
> This allows the adapter to continue operating in autonomous mode with
> the same settings when it is disconnected from the driver (typically by
> going into suspend). For adapters with firmware version 2 or greater, the
> settings are also persisted in EEPROM.
> 
> A new module parameter is added to optionally also use the configuration
> already present in the adapter when it is connected. This option is
> enabled by default.
> 
> When a new configuration is written, the autonomous mode is
> automatically enabled. When the device is unconfigured, autonomous mode
> is disabled.
> 
> Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
> ---
>  drivers/staging/media/pulse8-cec/pulse8-cec.c | 259 ++++++++++++++++++++++----
>  1 file changed, 221 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> index 4d20e72..531377a 100644
> --- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
> +++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> @@ -51,8 +51,11 @@ MODULE_DESCRIPTION("Pulse Eight HDMI CEC driver");
>  MODULE_LICENSE("GPL");
>  
>  static int debug;
> +static int persistent_config = 1;
>  module_param(debug, int, 0644);
> +module_param(persistent_config, int, 0644);
>  MODULE_PARM_DESC(debug, "debug level (0-1)");
> +MODULE_PARM_DESC(persitent_config, "read config from persitent memory (0-1)");

s/persitent/persistent/g

>  
>  enum pulse8_msgcodes {
>  	MSGCODE_NOTHING = 0,
> @@ -109,12 +112,16 @@ enum pulse8_msgcodes {
>  
>  #define DATA_SIZE 256
>  
> +#define PING_PERIOD	15 * HZ
> +
>  struct pulse8 {
>  	struct device *dev;
>  	struct serio *serio;
>  	struct cec_adapter *adap;
> +	unsigned int vers;
>  	struct completion cmd_done;
>  	struct work_struct work;
> +	struct delayed_work ping_eeprom_work;
>  	struct cec_msg rx_msg;
>  	u8 data[DATA_SIZE];
>  	unsigned int len;
> @@ -122,9 +129,15 @@ struct pulse8 {
>  	unsigned int idx;
>  	bool escape;
>  	bool started;
> +	struct mutex config_lock;
>  	struct mutex write_lock;
> +	bool config_pending;
> +	bool restoring_config;
> +	bool autonomous;
>  };
>  
> +static void pulse8_ping_eeprom_work_handler(struct work_struct *work);
> +
>  static void pulse8_irq_work_handler(struct work_struct *work)
>  {
>  	struct pulse8 *pulse8 =
> @@ -229,6 +242,7 @@ static void pulse8_disconnect(struct serio *serio)
>  	struct pulse8 *pulse8 = serio_get_drvdata(serio);
>  
>  	cec_unregister_adapter(pulse8->adap);
> +	cancel_delayed_work_sync(&pulse8->ping_eeprom_work);
>  	dev_info(&serio->dev, "disconnected\n");
>  	serio_close(serio);
>  	serio_set_drvdata(serio, NULL);
> @@ -309,14 +323,14 @@ static int pulse8_send_and_wait(struct pulse8 *pulse8,
>  	return err;
>  }
>  
> -static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio)
> +static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio, struct cec_log_addrs *log_addrs, u16 *pa)
>  {
>  	u8 *data = pulse8->data + 1;
> -	unsigned int count = 0;
> -	unsigned int vers = 0;
>  	u8 cmd[2];
>  	int err;
>  
> +	pulse8->vers = 0;
> +
>  	cmd[0] = MSGCODE_PING;
>  	err = pulse8_send_and_wait(pulse8, cmd, 1,
>  				   MSGCODE_COMMAND_ACCEPTED, 0);
> @@ -326,10 +340,10 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio)
>  	if (err)
>  		return err;
>  
> -	vers = (data[0] << 8) | data[1];
> +	pulse8->vers = (data[0] << 8) | data[1];
>  
> -	dev_info(pulse8->dev, "Firmware version %04x\n", vers);
> -	if (vers < 2)
> +	dev_info(pulse8->dev, "Firmware version %04x\n", pulse8->vers);
> +	if (pulse8->vers < 2)
>  		return 0;
>  
>  	cmd[0] = MSGCODE_GET_BUILDDATE;
> @@ -346,37 +360,98 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio)
>  			 tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
>  			 tm.tm_hour, tm.tm_min, tm.tm_sec);
>  	}
> +	if (err)
> +		return err;
>  
> -	do {
> -		if (count)
> -			msleep(500);
> -		cmd[0] = MSGCODE_SET_AUTO_ENABLED;
> -		cmd[1] = 0;
> -		err = pulse8_send_and_wait(pulse8, cmd, 2,
> -					   MSGCODE_COMMAND_ACCEPTED, 1);
> -		if (err && count == 0) {
> -			dev_info(pulse8->dev, "No Auto Enabled supported\n");
> -			return 0;
> -		}
> +	dev_dbg(pulse8->dev, "Persistent config:\n");
> +	cmd[0] = MSGCODE_GET_AUTO_ENABLED;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
> +	if (err)
> +		return err;
> +	pulse8->autonomous = data[0];
> +	dev_dbg(pulse8->dev, "Autonomous mode: %s",
> +		data[0] ? "on" : "off");
>  
> -		cmd[0] = MSGCODE_GET_AUTO_ENABLED;
> -		if (!err)
> -			err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
> -		if (!err && !data[0]) {
> -			cmd[0] = MSGCODE_WRITE_EEPROM;
> -			err = pulse8_send_and_wait(pulse8, cmd, 1,
> -						   MSGCODE_COMMAND_ACCEPTED, 1);
> -			cmd[0] = MSGCODE_GET_AUTO_ENABLED;
> -			if (!err)
> -				err = pulse8_send_and_wait(pulse8, cmd, 1,
> -							   cmd[0], 1);
> -		}
> -	} while (!err && data[0] && count++ < 5);
> +	cmd[0] = MSGCODE_GET_DEVICE_TYPE;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
> +	if (err)
> +		return err;
> +	log_addrs->primary_device_type[0] = data[0];
> +	dev_dbg(pulse8->dev, "Primary device type: %d\n", data[0]);
> +	switch (log_addrs->primary_device_type[0]) {
> +	case CEC_OP_PRIM_DEVTYPE_TV:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_TV;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_RECORD:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_RECORD;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_TUNER:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_TUNER;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_PLAYBACK;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_PLAYBACK;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_SWITCH:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_SPECIFIC;
> +		break;
> +	default:
> +		log_addrs->log_addr_type[0] = CEC_LOG_ADDR_TYPE_UNREGISTERED;
> +		dev_info(pulse8->dev, "Unknown Primary Device Type: %d\n",
> +			 log_addrs->primary_device_type[0]);

Add a break here.

> +	}
>  
> -	if (!err && data[0])
> -		err = -EIO;
> +	cmd[0] = MSGCODE_GET_LOGICAL_ADDRESS_MASK;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 2);
> +	if (err)
> +		return err;
> +	log_addrs->log_addr_mask = (data[0] << 8) | data[1];
> +	dev_dbg(pulse8->dev, "Logical address ACK mask: %x\n", log_addrs->log_addr_mask);
> +	if (log_addrs->log_addr_mask)
> +		log_addrs->num_log_addrs = 1;
>  
> -	return err;
> +	cmd[0] = MSGCODE_GET_PHYSICAL_ADDRESS;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
> +	if (err)
> +		return err;
> +	*pa = (data[0] << 8) | data[1];
> +	dev_dbg(pulse8->dev, "Physical address: %x.%x.%x.%x\n", cec_phys_addr_exp(*pa));
> +
> +	cmd[0] = MSGCODE_GET_HDMI_VERSION;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 1);
> +	if (err)
> +		return err;
> +	log_addrs->cec_version = data[0];
> +	dev_dbg(pulse8->dev, "CEC version: %d\n", log_addrs->cec_version);
> +
> +	cmd[0] = MSGCODE_GET_OSD_NAME;
> +	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 0);
> +	if (err)
> +		return err;
> +	strncpy(log_addrs->osd_name, data, 13);
> +	dev_dbg(pulse8->dev, "OSD name: %s\n", log_addrs->osd_name);
> +
> +	return 0;
> +}
> +
> +static int pulse8_apply_persistent_config(struct pulse8 *pulse8, struct cec_log_addrs *log_addrs, u16 pa)
> +{
> +	int err;
> +
> +	err = cec_s_log_addrs(pulse8->adap, log_addrs, false);
> +	if (err)
> +		return err;
> +
> +	cec_s_phys_addr(pulse8->adap, pa, false);
> +	if (err)
> +		return err;
> +
> +	return 0;
>  }
>  
>  static int pulse8_cec_adap_enable(struct cec_adapter *adap, bool enable)
> @@ -396,9 +471,11 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>  {
>  	struct pulse8 *pulse8 = adap->priv;
>  	u16 mask = 0;
> -	u8 cmd[3];
> -	int err;
> +	u16 pa = adap->phys_addr;
> +	u8 cmd[16];
> +	int err = 0;
>  
> +	mutex_lock(&pulse8->config_lock);
>  	if (log_addr != CEC_LOG_ADDR_INVALID)
>  		mask = 1 << log_addr;
>  	cmd[0] = MSGCODE_SET_ACK_MASK;
> @@ -406,8 +483,72 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>  	cmd[2] = mask & 0xff;
>  	err = pulse8_send_and_wait(pulse8, cmd, 3,
>  				   MSGCODE_COMMAND_ACCEPTED, 0);
> -	if (mask == 0)
> -		return 0;
> +	if ((err && mask != 0) || pulse8->restoring_config)
> +		goto unlock;
> +
> +	cmd[0] = MSGCODE_SET_AUTO_ENABLED;
> +	cmd[1] = log_addr == CEC_LOG_ADDR_INVALID ? 0 : 1;
> +	err = pulse8_send_and_wait(pulse8, cmd, 2,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +	pulse8->autonomous = cmd[1];
> +	if (log_addr == CEC_LOG_ADDR_INVALID)
> +		goto unlock;
> +
> +	cmd[0] = MSGCODE_SET_DEVICE_TYPE;
> +	cmd[1] = adap->log_addrs.primary_device_type[0];
> +	err = pulse8_send_and_wait(pulse8, cmd, 2,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +
> +	cmd[0] = MSGCODE_SET_DEFAULT_LOGICAL_ADDRESS;
> +	cmd[1] = log_addr;
> +	err = pulse8_send_and_wait(pulse8, cmd, 2,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +
> +	cmd[0] = MSGCODE_SET_PHYSICAL_ADDRESS;
> +	cmd[1] = pa >> 8;
> +	cmd[2] = pa & 0xff;
> +	err = pulse8_send_and_wait(pulse8, cmd, 3,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +
> +	cmd[0] = MSGCODE_SET_HDMI_VERSION;
> +	cmd[1] = adap->log_addrs.cec_version;
> +	err = pulse8_send_and_wait(pulse8, cmd, 2,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +
> +	if (adap->log_addrs.osd_name[0]) {
> +		size_t osd_len = strlen(adap->log_addrs.osd_name);
> +		char *osd_str = cmd + 1;
> +
> +		cmd[0] = MSGCODE_SET_OSD_NAME;
> +		strncpy(cmd + 1, adap->log_addrs.osd_name, 13);
> +		if (osd_len < 4) {
> +			memset(osd_str + osd_len, ' ', 4 - osd_len);
> +			osd_len = 4;
> +			osd_str[osd_len] = '\0';
> +			strcpy(adap->log_addrs.osd_name, osd_str);
> +		}
> +		err = pulse8_send_and_wait(pulse8, cmd, 1 + osd_len,
> +					   MSGCODE_COMMAND_ACCEPTED, 0);
> +		if (err)
> +			goto unlock;
> +	}
> +
> +  unlock:
> +	if (pulse8->restoring_config)
> +		pulse8->restoring_config = false;
> +	else
> +		pulse8->config_pending = true;
> +	mutex_unlock(&pulse8->config_lock);
>  	return err;
>  }
>  
> @@ -469,6 +610,8 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
>  		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
>  	struct pulse8 *pulse8;
>  	int err = -ENOMEM;
> +	struct cec_log_addrs log_addrs = {};
> +	u16 pa;
>  
>  	pulse8 = kzalloc(sizeof(*pulse8), GFP_KERNEL);
>  
> @@ -486,12 +629,14 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
>  	serio_set_drvdata(serio, pulse8);
>  	INIT_WORK(&pulse8->work, pulse8_irq_work_handler);
>  	mutex_init(&pulse8->write_lock);
> +	mutex_init(&pulse8->config_lock);
> +	pulse8->config_pending = false;
>  
>  	err = serio_open(serio, drv);
>  	if (err)
>  		goto delete_adap;
>  
> -	err = pulse8_setup(pulse8, serio);
> +	err = pulse8_setup(pulse8, serio, &log_addrs, &pa);
>  	if (err)
>  		goto close_serio;
>  
> @@ -500,6 +645,17 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
>  		goto close_serio;
>  
>  	pulse8->dev = &pulse8->adap->devnode.dev;
> +
> +	if (persistent_config && pulse8->autonomous) {
> +		err = pulse8_apply_persistent_config(pulse8, &log_addrs, pa);
> +		if (err)
> +			goto close_serio;
> +		pulse8->restoring_config = true;
> +	}
> +
> +	INIT_DELAYED_WORK(&pulse8->ping_eeprom_work, pulse8_ping_eeprom_work_handler);
> +	schedule_delayed_work(&pulse8->ping_eeprom_work, PING_PERIOD);
> +
>  	return 0;
>  
>  close_serio:
> @@ -512,6 +668,33 @@ free_device:
>  	return err;
>  }
>  
> +static void pulse8_ping_eeprom_work_handler(struct work_struct *work)
> +{
> +	struct pulse8 *pulse8 =
> +		container_of(work, struct pulse8, ping_eeprom_work.work);
> +	u8 cmd;
> +
> +	schedule_delayed_work(&pulse8->ping_eeprom_work, PING_PERIOD);
> +	cmd = MSGCODE_PING;
> +	pulse8_send_and_wait(pulse8, &cmd, 1,
> +			     MSGCODE_COMMAND_ACCEPTED, 0);
> +
> +	if (pulse8->vers < 2)
> +		return;
> +
> +	mutex_lock(&pulse8->config_lock);
> +	if (pulse8->config_pending && persistent_config) {
> +		dev_dbg(pulse8->dev, "writing pending config to EEPROM\n");
> +		cmd = MSGCODE_WRITE_EEPROM;
> +		if (pulse8_send_and_wait(pulse8, &cmd, 1,
> +					 MSGCODE_COMMAND_ACCEPTED, 0))
> +			dev_info(pulse8->dev, "failed to write pending config to EEPROM\n");
> +		else
> +			pulse8->config_pending = false;
> +	}
> +	mutex_unlock(&pulse8->config_lock);
> +}
> +
>  static struct serio_device_id pulse8_serio_ids[] = {
>  	{
>  		.type	= SERIO_RS232,
> 

Regards,

	Hans
