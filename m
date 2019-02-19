Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3473C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 21:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD0B221479
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 21:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfBSVaG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 16:30:06 -0500
Received: from gofer.mess.org ([88.97.38.141]:53349 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfBSVaF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 16:30:05 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 0F95A600B4; Tue, 19 Feb 2019 21:30:03 +0000 (GMT)
Date:   Tue, 19 Feb 2019 21:30:03 +0000
From:   Sean Young <sean@mess.org>
To:     Gonsolo <gonsolo@gmail.com>
Cc:     crope@iki.fi, linux-media@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: DVB-T2 Stick
Message-ID: <20190219213003.l7hzy2emdsxe4izy@gofer.mess.org>
References: <CANL0fFSGG_+R2zbf-9MxVLJMTMgc+-fwSoLCqS1qc+jWo-zNLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANL0fFSGG_+R2zbf-9MxVLJMTMgc+-fwSoLCqS1qc+jWo-zNLA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Wed, Jan 30, 2019 at 11:32:12AM +0100, Gonsolo wrote:
> Hi!
> 
> The following patch adds support for the Logilink VG0022A DVB-T2 stick.
> After patching and building the kernel it shows up with lsusb and I
> used w_scan to scan for channels and vlc for watching.
> The original patches were from Andreas Kemnade.
> The only thing that doesn't work is wake up after standby.
> 
> Do you think you can apply this patch?

I'm afraid there are many problems with this patch. First of all it looks
like support was added for a si2168 tuner but it looks like it will break
for any other si2157-type device.

Secondly there are lots of coding style issues, see:

https://www.kernel.org/doc/html/v4.10/process/coding-style.html

Thanks,

Sean
> 
> Thanks
> -- 
> g

> diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
> index d389f1fc237a..1f923418ff10 100644
> --- a/drivers/media/tuners/si2157.c
> +++ b/drivers/media/tuners/si2157.c
> @@ -84,7 +84,7 @@ static int si2157_init(struct dvb_frontend *fe)
>  	struct si2157_cmd cmd;
>  	const struct firmware *fw;
>  	const char *fw_name;
> -	unsigned int uitmp, chip_id;
> +        unsigned int uitmp;
>  
>  	dev_dbg(&client->dev, "\n");
>  
> @@ -126,7 +126,7 @@ static int si2157_init(struct dvb_frontend *fe)
>  		if (ret)
>  			goto err;
>  	}
> -
> +#if 0
>  	/* query chip revision */
>  	memcpy(cmd.args, "\x02", 1);
>  	cmd.wlen = 1;
> @@ -146,6 +146,8 @@ static int si2157_init(struct dvb_frontend *fe)
>  	#define SI2141_A10 ('A' << 24 | 41 << 16 | '1' << 8 | '0' << 0)
>  
>  	switch (chip_id) {
> +#endif
> +        switch (dev->chip_id) {
>  	case SI2158_A20:
>  	case SI2148_A20:
>  		fw_name = SI2158_A20_FIRMWARE;
> @@ -166,9 +168,9 @@ static int si2157_init(struct dvb_frontend *fe)
>  		goto err;
>  	}
>  
> -	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
> -			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
> -
> +//	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
> +//			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
> +//
>  	if (fw_name == NULL)
>  		goto skip_fw_download;
>  
> @@ -461,6 +463,38 @@ static int si2157_probe(struct i2c_client *client,
>  	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
>  	fe->tuner_priv = client;
>  
> +       /* power up */
> +       if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
> +               memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
> +               cmd.wlen = 9;
> +       } else {
> +               memcpy(cmd.args,
> +               "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01",
> +               15);
> +               cmd.wlen = 15;
> +       }
> +       cmd.rlen = 1;
> +       ret = si2157_cmd_execute(client, &cmd);
> +       if (ret)
> +               goto err;
> +       /* query chip revision */
> +       /* hack: do it here because after the si2168 gets 0101, commands will
> +        * still be executed here but no result
> +        */
> +       memcpy(cmd.args, "\x02", 1);
> +       cmd.wlen = 1;
> +       cmd.rlen = 13;
> +       ret = si2157_cmd_execute(client, &cmd);
> +       if (ret)
> +               goto err_kfree;
> +       dev->chip_id = cmd.args[1] << 24 |
> +                       cmd.args[2] << 16 |
> +                       cmd.args[3] << 8 |
> +                       cmd.args[4] << 0;
> +       dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
> +                       cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
> + 
> +
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	if (cfg->mdev) {
>  		dev->mdev = cfg->mdev;
> diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
> index 50f86300d965..3592146cf49a 100644
> --- a/drivers/media/tuners/si2157_priv.h
> +++ b/drivers/media/tuners/si2157_priv.h
> @@ -37,6 +37,7 @@ struct si2157_dev {
>  	u8 chiptype;
>  	u8 if_port;
>  	u32 if_frequency;
> +        u32 chip_id;
>  	struct delayed_work stat_work;
>  
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> @@ -51,6 +52,13 @@ struct si2157_dev {
>  #define SI2157_CHIPTYPE_SI2146 1
>  #define SI2157_CHIPTYPE_SI2141 2
>  
> +#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
> +#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
> +#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
> +#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
> +#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
> +#define SI2141_A10 ('A' << 24 | 41 << 16 | '1' << 8 | '0' << 0)
> +
>  /* firmware command struct */
>  #define SI2157_ARGLEN      30
>  struct si2157_cmd {
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 80d3bd3a0f24..28b073bfe0d4 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -1216,8 +1216,51 @@ static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
>  	struct si2168_config si2168_config;
>  	struct i2c_adapter *adapter;
>  
> -	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
> -
> +	//dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
> +       dev_dbg(&intf->dev, "%s  adap->id=%d\n", __func__, adap->id);
> +
> +       /* I2C master bus 2 clock speed 300k */
> +       ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
> +       if (ret < 0)
> +               goto err;
> +
> +       /* I2C master bus 1,3 clock speed 300k */
> +       ret = af9035_wr_reg(d, 0x00f103, 0x07);
> +       if (ret < 0)
> +               goto err;
> +
> +       /* set gpio11 low */
> +       ret = af9035_wr_reg_mask(d, 0xd8d4, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> +
> +       ret = af9035_wr_reg_mask(d, 0xd8d5, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> +
> +       ret = af9035_wr_reg_mask(d, 0xd8d3, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> + 
> +       /* Tuner enable using gpiot2_en, gpiot2_on and gpiot2_o (reset) */
> +       ret = af9035_wr_reg_mask(d, 0xd8b8, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> +
> +       ret = af9035_wr_reg_mask(d, 0xd8b9, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> +
> +       ret = af9035_wr_reg_mask(d, 0xd8b7, 0x00, 0x01);
> +       if (ret < 0)
> +               goto err;
> +
> +       msleep(200);
> +
> +       ret = af9035_wr_reg_mask(d, 0xd8b7, 0x01, 0x01);
> +       if (ret < 0)
> +               goto err;
> + 
>  	memset(&si2168_config, 0, sizeof(si2168_config));
>  	si2168_config.i2c_adapter = &adapter;
>  	si2168_config.fe = &adap->fe[0];
> @@ -2128,6 +2171,8 @@ static const struct usb_device_id af9035_id_table[] = {
>  	/* IT930x devices */
>  	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
>  		&it930x_props, "ITE 9303 Generic", NULL) },
> +        { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x0100,
> +                &it930x_props, "Logilink VG0022A", NULL) },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(usb, af9035_id_table);

