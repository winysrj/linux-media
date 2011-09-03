Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab1ICNpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 09:45:08 -0400
Message-ID: <4E622F44.404@redhat.com>
Date: Sat, 03 Sep 2011 10:44:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: jasondong <jason.dong@ite.com.tw>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Add driver support for ITE IT9135 device
References: <1312539895.2763.33.camel@Jason-Linux>
In-Reply-To: <1312539895.2763.33.camel@Jason-Linux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

Em 05-08-2011 07:24, jasondong escreveu:
> This is DVB USB Linux driver for ITEtech IT9135 base USB TV module.
> It supported the IT9135 AX and BX chip versions.

See my comments bellow.

Thanks,
Mauro

> 
> Signed-off-by: jasondong <jason.dong@ite.com.tw>
> ---
>  Documentation/dvb/get_dvb_firmware      |   17 +-
>  drivers/media/dvb/dvb-usb/Kconfig       |    6 +
>  drivers/media/dvb/dvb-usb/Makefile      |    3 +
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    4 +
>  drivers/media/dvb/dvb-usb/it9135-fe.c   | 4743 +++++++++++++++++++++++++++++++
>  drivers/media/dvb/dvb-usb/it9135-fe.h   | 1632 +++++++++++
>  drivers/media/dvb/dvb-usb/it9135.c      | 2492 ++++++++++++++++
>  drivers/media/dvb/dvb-usb/it9135.h      |  155 +
>  8 files changed, 9051 insertions(+), 1 deletions(-)
>  mode change 100644 => 100755 Documentation/dvb/get_dvb_firmware
>  create mode 100644 drivers/media/dvb/dvb-usb/it9135-fe.c
>  create mode 100644 drivers/media/dvb/dvb-usb/it9135-fe.h
>  create mode 100644 drivers/media/dvb/dvb-usb/it9135.c
>  create mode 100644 drivers/media/dvb/dvb-usb/it9135.h
> 
> diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
> old mode 100644
> new mode 100755
> index 3348d31..1b30198
> --- a/Documentation/dvb/get_dvb_firmware
> +++ b/Documentation/dvb/get_dvb_firmware
> @@ -27,7 +27,7 @@ use IO::Handle;
>  		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
>  		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
>  		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
> -		"lme2510c_s7395_old");
> +		"lme2510c_s7395_old", "it9135");
>  
>  # Check args
>  syntax() if (scalar(@ARGV) != 1);
> @@ -634,6 +634,21 @@ sub lme2510c_s7395_old {
>      $outfile;
>  }
>  
> +sub it9135 {
> +	my $sourcefile = "dvb-usb-it9135.zip";
> +	my $url = "http://www.ite.com.tw/uploads/firmware/v3.6.0.0/$sourcefile";
> +	my $hash = "1e55f6c8833f1d0ae067c2bb2953e6a9";
> +	my $outfile = "dvb-usb-it9135.fw";
> +
> +	checkstandard();
> +
> +	wgetfile($sourcefile, $url);
> +	unzip($sourcefile, "");
> +	verify("$outfile", $hash);
> +
> +	$outfile;
> +}
> +
>  # ---------------------------------------------------------------
>  # Utilities
>  
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index e85304c..468fe8e 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -373,3 +373,9 @@ config DVB_USB_TECHNISAT_USB2
>  	select DVB_STV6110x if !DVB_FE_CUSTOMISE
>  	help
>  	  Say Y here to support the Technisat USB2 DVB-S/S2 device
> +
> +config DVB_USB_IT9135
> +	tristate "ITEtech IT9135 DVB-T USB2.0 support"
> +	depends on DVB_USB
> +	help
> +	  Say Y here to support the ITE IT9135 based DVB-T USB2.0 receiver
> diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
> index 4bac13d..466b23c 100644
> --- a/drivers/media/dvb/dvb-usb/Makefile
> +++ b/drivers/media/dvb/dvb-usb/Makefile
> @@ -94,6 +94,9 @@ obj-$(CONFIG_DVB_USB_LME2510) += dvb-usb-lmedm04.o
>  dvb-usb-technisat-usb2-objs = technisat-usb2.o
>  obj-$(CONFIG_DVB_USB_TECHNISAT_USB2) += dvb-usb-technisat-usb2.o
>  
> +dvb-usb-it9135-objs := it9135.o it9135-fe.o
> +obj-$(CONFIG_DVB_USB_IT9135) += dvb-usb-it9135.o
> +
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/ -Idrivers/media/dvb/frontends/
>  # due to tuner-xc3028
>  EXTRA_CFLAGS += -Idrivers/media/common/tuners
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index 21b1549..ffeb338 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -67,6 +67,7 @@
>  #define USB_VID_EVOLUTEPC			0x1e59
>  #define USB_VID_AZUREWAVE			0x13d3
>  #define USB_VID_TECHNISAT			0x14f7
> +#define USB_VID_ITETECH				0x048d
>  
>  /* Product IDs */
>  #define USB_PID_ADSTECH_USB2_COLD			0xa333
> @@ -320,4 +321,7 @@
>  #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
>  #define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
>  #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
> +#define USB_PID_ITETECH_IT9135				0x9135
> +#define USB_PID_ITETECH_IT9135_9005			0x9005
> +#define USB_PID_ITETECH_IT9135_9006			0x9006
>  #endif
> diff --git a/drivers/media/dvb/dvb-usb/it9135-fe.c b/drivers/media/dvb/dvb-usb/it9135-fe.c
> new file mode 100644
> index 0000000..e3ddbf3
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/it9135-fe.c
> @@ -0,0 +1,4743 @@
> +/*
> + * DVB USB Linux driver for IT9135 DVB-T USB2.0 receiver
> + *
> + * Copyright (C) 2011 ITE Technologies, INC.
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +
> +#include "it9135.h"
> +
> +static unsigned long it9135_enter_mutex(struct it9135_data *data)
> +{
> +	/*
> +	 *  ToDo:  Add code here
> +	 */
> +	return ERROR_NO_ERROR;
> +}
> +
> +static unsigned long it9135_leave_mutex(struct it9135_data *data)
> +{
> +	/*
> +	 *  ToDo:  Add code here
> +	 */
> +	return ERROR_NO_ERROR;
> +}

Hmmm... please implement mutexes were needed, but, instead of calling a
"generic" code for that, just call mutex_lock/mutex_unlock where needed.

> +
> +/*
> + * IT9135 command functions
> + */
> +#define IT9135_MAX_CMD_SIZE		63
> +
> +static unsigned long it9135_cmd_add_checksum(struct it9135_data *data,
> +					     unsigned long *buff_len,
> +					     unsigned char *buffer)
> +{
> +	unsigned long error = ERROR_NO_ERROR;

Don't create your own errorspace. Linux has its own.

In this specific case, the better would be to just define this function
as

static void it9135_cmd_add_checksum(...)

> +	unsigned long loop = (*buff_len - 1) / 2;
> +	unsigned long remain = (*buff_len - 1) % 2;
> +	unsigned long i;
> +	unsigned short checksum = 0;
> +
> +	for (i = 0; i < loop; i++)
> +		checksum +=
> +		    (unsigned short)(buffer[2 * i + 1] << 8) +
> +		    (unsigned short)(buffer[2 * i + 2]);
> +	if (remain)
> +		checksum += (unsigned short)(buffer[*buff_len - 1] << 8);
> +
> +	checksum = ~checksum;
> +	buffer[*buff_len] = (unsigned char)((checksum & 0xFF00) >> 8);
> +	buffer[*buff_len + 1] = (unsigned char)(checksum & 0x00FF);
> +	buffer[0] = (unsigned char)(*buff_len + 1);
> +	*buff_len += 2;
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_cmd_remove_checksum(struct it9135_data *data,
> +						unsigned long *buff_len,
> +						unsigned char *buffer)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long loop = (*buff_len - 3) / 2;
> +	unsigned long remain = (*buff_len - 3) % 2;
> +	unsigned long i;
> +	unsigned short checksum = 0;
> +
> +	for (i = 0; i < loop; i++)
> +		checksum +=
> +		    (unsigned short)(buffer[2 * i + 1] << 8) +
> +		    (unsigned short)(buffer[2 * i + 2]);
> +	if (remain)
> +		checksum += (unsigned short)(buffer[*buff_len - 3] << 8);
> +
> +	checksum = ~checksum;
> +	if (((unsigned short)(buffer[*buff_len - 2] << 8) +
> +	     (unsigned short)(buffer[*buff_len - 1])) != checksum) {
> +		error = ERROR_WRONG_CHECKSUM;

If that means that the message arrived wrong, -EIO is the proper error code.

> +		goto exit;
> +	}
> +	if (buffer[2])
> +		error = ERROR_FIRMWARE_STATUS | buffer[2];
> +
> +	buffer[0] = (unsigned char)(*buff_len - 3);
> +	*buff_len -= 2;
> +
> +exit:
> +	return error;
> +}
> +
> +#define IT9135_USB_BULK_TIMEOUT		2000

Better to put such define at the beginning of the file.

> +
> +static unsigned long it9135_cmd_bus_tx(struct it9135_data *data,
> +				       unsigned long buff_len,
> +				       unsigned char *buffer)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	int act_len, ret;
> +
> +	ret = usb_bulk_msg(usb_get_dev(data->driver),
> +			   usb_sndbulkpipe(usb_get_dev(data->driver), 0x02),
> +			   buffer, buff_len, &act_len, IT9135_USB_BULK_TIMEOUT);
> +
> +	if (ret) {
> +		error = ERROR_USB_WRITE_FAIL;

No. Please return the error code from usb_bulk_msg.

> +		err(" it9135_cmd_bus_tx fail : %d!", ret);
> +	}
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_cmd_bus_rx(struct it9135_data *data,
> +				       unsigned long buff_len,
> +				       unsigned char *buffer)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	int act_len, ret;
> +
> +	ret = usb_bulk_msg(usb_get_dev(data->driver),
> +			   usb_rcvbulkpipe(usb_get_dev(data->driver), 129),
> +			   buffer, 125, &act_len, IT9135_USB_BULK_TIMEOUT);
> +
> +	if (ret) {
> +		error = ERROR_USB_WRITE_FAIL;

No. Please return the error code from usb_bulk_msg.

I won't repeat this over and over. All functions that return errors
should just use the standard error codes defined on Linux, or 0 if
no error.

> +		err(" it9135_cmd_bus_rx fail: %d!", ret);
> +	}
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_cmd_loadfirmware(struct it9135_data *data,
> +					     unsigned long length,
> +					     unsigned char *firmware)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned long loop;
> +	unsigned long remain;
> +	unsigned long i, j, k;
> +	unsigned char buffer[255];
> +	unsigned long payloadLength;

Please don't use CamelCase in Linux. "payload_len" is a better naming.

> +	unsigned long buff_len;
> +	unsigned long remain_len;
> +	unsigned long send_len;
> +
> +	it9135_enter_mutex(data);
> +
> +	payloadLength = (IT9135_MAX_CMD_SIZE - 6);

> +	loop = length / payloadLength;
> +	remain = length % payloadLength;
> +
> +	k = 0;
> +	command = it9135_build_command(CMD_FW_DOWNLOAD, PROCESSOR_LINK, 0);
> +	for (i = 0; i < loop; i++) {
> +		buffer[1] = (unsigned char)(command >> 8);
> +		buffer[2] = (unsigned char)command;
> +		buffer[3] = (unsigned char)data->cmd_seq++;
> +
> +		for (j = 0; j < payloadLength; j++)
> +			buffer[4 + j] = firmware[j + i * payloadLength];
> +
> +		buff_len = 4 + payloadLength;
> +		error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +		if (error)
> +			goto exit;
> +
> +		send_len = 0;
> +		remain_len = IT9135_MAX_CMD_SIZE;
> +		while (remain_len > 0) {
> +			k = (remain_len >
> +			     IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +			    : (remain_len);
> +			error = it9135_cmd_bus_tx(data, k, &buffer[send_len]);
> +			if (error)
> +				goto exit;
> +
> +			send_len += k;
> +			remain_len -= k;
> +		}
> +	}
> +
> +	if (remain) {
> +		buffer[1] = (unsigned char)(command >> 8);
> +		buffer[2] = (unsigned char)command;
> +		buffer[3] = (unsigned char)data->cmd_seq++;
> +
> +		for (j = 0; j < remain; j++)
> +			buffer[4 + j] = firmware[j + i * payloadLength];
> +
> +		buff_len = 4 + remain;
> +		error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +		if (error)
> +			goto exit;
> +
> +		send_len = 0;
> +		remain_len = buff_len;
> +		while (remain_len > 0) {
> +			k = (remain_len >
> +			     IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +			    : (remain_len);
> +			error = it9135_cmd_bus_tx(data, k, &buffer[send_len]);
> +			if (error)
> +				goto exit;
> +
> +			send_len += k;
> +			remain_len -= k;
> +		}
> +	}
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +static unsigned long it9135_cmd_reboot(struct it9135_data *data,
> +				       unsigned char chip)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +
> +	it9135_enter_mutex(data);

Please use, instead, something like:
	mutex_lock(data->mutex);

> +
> +	command = it9135_build_command(CMD_REBOOT, PROCESSOR_LINK, chip);
> +	buffer[1] = (unsigned char)(command >> 8);
> +	buffer[2] = (unsigned char)command;
> +	buffer[3] = (unsigned char)data->cmd_seq++;
> +	buff_len = 4;
> +	error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	error = it9135_cmd_bus_tx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	it9135_leave_mutex(data);

mutex_unlock(data->mutex);

> +	return error;
> +}
> +
> +/*
> + * Send the command to device.
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param command the command to be send.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + * @param processor The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param w_buff_len the number of registers to be write.
> + * @param w_buff a unsigned char array which is used to store values to be write.
> + * @param r_buff_len the number of registers to be read.
> + * @param r_buff a unsigned char array which is used to store values to be read.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */


The function prototype is wrong. If you're commenting the arguments, it should
be instead:

/**
 * it9135_cmd_sendcommand() - Send the command to device
 *
 * @data:	the handle of IT9135.
...

Please read Documentation/kernel-doc-nano-HOWTO.txt for more details.


> +static unsigned long it9135_cmd_sendcommand(struct it9135_data *data,
> +					    unsigned short command,
> +					    unsigned char chip,
> +					    unsigned char processor,
> +					    unsigned long w_buff_len,
> +					    unsigned char *w_buff,
> +					    unsigned long r_buff_len,
> +					    unsigned char *r_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +	unsigned long remain_len;
> +	unsigned long send_len;
> +	unsigned long i, k;
> +
> +	it9135_enter_mutex(data);

Again, use the proper mutex call. I won't be repeating this forever. So, replace it
on all places at the document. Please remember to properly initialize the mutex with
mutex_init() when you initialize the "data" struct, otherwise you'll get oopses.

> +
> +	if ((w_buff_len + 6) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;

-EINVAL.

> +		goto exit;
> +	}
> +
> +	if ((r_buff_len + 5) > IT9135_MAX_PKT_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	if ((r_buff_len + 5) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	if (w_buff_len == 0) {
> +		command = it9135_build_command(command, processor, chip);
> +		buffer[1] = (unsigned char)(command >> 8);
> +		buffer[2] = (unsigned char)command;
> +		buffer[3] = (unsigned char)data->cmd_seq++;
> +		buff_len = 4;
> +		error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +		if (error)
> +			goto exit;
> +
> +		/* send command packet */
> +		i = 0;
> +		send_len = 0;
> +		remain_len = buff_len;
> +		while (remain_len > 0) {
> +			i = (remain_len >
> +			     IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +			    : (remain_len);
> +			error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +			if (error)
> +				goto exit;
> +
> +			send_len += i;
> +			remain_len -= i;
> +		}
> +	} else {
> +		command = it9135_build_command(command, processor, chip);
> +		buffer[1] = (unsigned char)(command >> 8);
> +		buffer[2] = (unsigned char)command;
> +		buffer[3] = (unsigned char)data->cmd_seq++;
> +		for (k = 0; k < w_buff_len; k++)
> +			buffer[k + 4] = w_buff[k];
> +
> +		buff_len = 4 + w_buff_len;
> +		error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +		if (error)
> +			goto exit;
> +
> +		/* send command */
> +		i = 0;
> +		send_len = 0;
> +		remain_len = buff_len;
> +		while (remain_len > 0) {
> +			i = (remain_len >
> +			     IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +			    : (remain_len);
> +			error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +			if (error)
> +				goto exit;
> +
> +			send_len += i;
> +			remain_len -= i;
> +		}
> +	}
> +
> +	buff_len = 5 + r_buff_len;
> +
> +	error = it9135_cmd_bus_rx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	error = it9135_cmd_remove_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	if (r_buff_len) {
> +		for (k = 0; k < r_buff_len; k++)
> +			r_buff[k] = buffer[k + 3];
> +	}
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +/*
> + * IT9135 tuner functions
> + */
> +
> +static unsigned int it9135_tuner_get_nv(unsigned int nc)
> +{
> +	unsigned int nv;
> +
> +	switch (nc) {
> +	case 0:
> +		nv = 48;
> +		break;
> +	case 1:
> +		nv = 32;
> +		break;
> +	case 2:
> +		nv = 24;
> +		break;
> +	case 3:
> +		nv = 16;
> +		break;
> +	case 4:
> +		nv = 12;
> +		break;
> +	case 5:
> +		nv = 8;
> +		break;
> +	case 6:
> +		nv = 6;
> +		break;
> +	case 7:
> +		nv = 4;
> +		break;

> +	case 8:		/* L-band */
> +		nv = 2;
> +		break;
> +	default:
> +		nv = 2;
> +		break;

Just do, instead:
	case 8:		/* L-band */
	default: 
		nv = 2;
		break;


> +	}
> +
> +	return nv;
> +}
> +
> +static unsigned int it9135_fn_min[] = {
> +	53000, 74000, 111000, 148000, 222000, 296000, 445000, 573000, 950000
> +};
> +
> +static unsigned long it9135_tuner_init(struct it9135_data *data,
> +				       unsigned char chip)
> +{
> +	unsigned long error = 0;
> +	unsigned char buf[4], val;
> +	unsigned int m_bdry, nc, nv;
> +	unsigned long tmp_numer, tmp_denom;
> +	unsigned int cnt;
> +
> +#define OMEGA_TUNER_INIT_POLL_INTERVAL	2
> +#define OMEGA_TUNER_INIT_POLL_COUNTS	50
> +
> +	/* ----- read ----- */
> +	/* p_reg_p_tsm_init_clock_mode */
> +	error = it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xEC86, 1, buf);

We generally use lowercase for hexadecimal values.

> +	if (error)
> +		goto exit;
> +	/* p_reg_p_fbc_n_code */
> +	error =
> +	    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xED03, 1, &buf[1]);
> +	if (error)
> +		goto exit;
> +	/* r_reg_r_fbc_m_bdry_7_0 */
> +	error =
> +	    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xED23, 2, &buf[2]);
> +	if (error)
> +		goto exit;
> +
> +	/* ----- set_clock_mode ----- */
> +	data->clock_mode = buf[0];
> +
> +	/* ----- set_fref_kHz & m_cal ----- */
> +	switch (data->clock_mode) {
> +	case 0:		/* 12.00MHz, 12000/18 = 2000/3 */
> +		data->fxtal_khz = 2000;
> +		data->fdiv = 3;
> +		val = 16;
> +		break;
> +	case 1:		/* 20.48MHz, 20480/32 = 640/1 */
> +		data->fxtal_khz = 640;
> +		data->fdiv = 1;
> +		val = 6;
> +		break;
> +	default:		/* 20.48MHz, 20480/32 = 640/1 */
> +		data->fxtal_khz = 640;
> +		data->fdiv = 1;
> +		val = 6;
> +		break;
> +	}
> +
> +	/* ----- set_fbdry ----- */
> +	nc = buf[1];
> +	nv = it9135_tuner_get_nv(nc);
> +	m_bdry = (buf[3] << 8) + buf[2];	/* m_bdry = m_bdry_15_8 << 8 + m_bdry_7_0 */
> +
> +	/* ----- patch to wait for fbc done ----- */
> +	cnt = 1;
> +	while (m_bdry == 0 && cnt < OMEGA_TUNER_INIT_POLL_COUNTS) {
> +		mdelay(OMEGA_TUNER_INIT_POLL_INTERVAL);
> +		/* r_reg_r_fbc_m_bdry_7_0 */
> +		error =
> +		    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xED23, 2,
> +				     &buf[2]);
> +		if (error)
> +			goto exit;
> +		m_bdry = (buf[3] << 8) + buf[2];	/* m_bdry = m_bdry_15_8 << 8 + m_bdry_7_0 */
> +		cnt++;
> +	}
> +
> +	if (m_bdry == 0) {
> +		error = ERROR_TUNER_INIT_FAIL;
> +		goto exit;
> +	}
> +
> +	tmp_numer = (unsigned long)data->fxtal_khz * (unsigned long)m_bdry;
> +	tmp_denom = (unsigned long)data->fdiv * (unsigned long)nv;
> +	it9135_fn_min[7] = (unsigned int)(tmp_numer / tmp_denom);
> +
> +	/* ----- patch to wait for all cal done, borrow p_reg_p_tsm_init_mode ----- */
> +	cnt = 1;
> +
> +	if (data->chip_type == 0x9135 && data->chip_ver == 2) {
> +		mdelay(50);	/* for omega2 */

Except if you really need an exact time, don't use mdelay(). It makes the CPU to run
a loop, blocking it to be used by other proccesses, so, impacting at the machine
performance, instead of letting it to do something else or to save energy. Normal 
delays should use, instead:

	msleep(50);


> +	} else {
> +		/* p_reg_p_tsm_init_mode */
> +		error =
> +		    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xEC82, 1,
> +				     buf);
> +		if (error)
> +			goto exit;
> +
> +		while (buf[0] == 0 && cnt < OMEGA_TUNER_INIT_POLL_COUNTS) {
> +			mdelay(OMEGA_TUNER_INIT_POLL_INTERVAL);
> +			/* p_reg_p_tsm_init_mode */
> +			error =
> +			    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xEC82,
> +					     1, buf);
> +			if (error)
> +				goto exit;
> +			cnt++;
> +		}
> +		if (buf[0] == 0) {
> +			error = ERROR_TUNER_INIT_FAIL;
> +			goto exit;
> +		}
> +	}
> +
> +	/* p_reg_p_iqik_m_cal */
> +	error = it9135_write_regs(data, chip, PROCESSOR_OFDM, 0xED81, 1, &val);
> +
> +exit:
> +	return error;
> +}
> +
> +static unsigned int it9135_tuner_get_nc(unsigned int rf_freq_khz)
> +{
> +	unsigned int nc;
> +
> +	if ((rf_freq_khz <= it9135_fn_min[1])) {	/* 74 */
> +		nc = 0;
> +	} else if ((rf_freq_khz > it9135_fn_min[1]) && (rf_freq_khz <= it9135_fn_min[2])) {	/* 74 111 */
> +		nc = 1;
> +	} else if ((rf_freq_khz > it9135_fn_min[2]) && (rf_freq_khz <= it9135_fn_min[3])) {	/* 111 148 */
> +		nc = 2;
> +	} else if ((rf_freq_khz > it9135_fn_min[3]) && (rf_freq_khz <= it9135_fn_min[4])) {	/* 148 222 */
> +		nc = 3;
> +	} else if ((rf_freq_khz > it9135_fn_min[4]) && (rf_freq_khz <= it9135_fn_min[5])) {	/* 222 296 */
> +		nc = 4;
> +	} else if ((rf_freq_khz > it9135_fn_min[5]) && (rf_freq_khz <= it9135_fn_min[6])) {	/* 296 445 */
> +		nc = 5;
> +	} else if ((rf_freq_khz > it9135_fn_min[6]) && (rf_freq_khz <= it9135_fn_min[7])) {	/* 445 573 */
> +		nc = 6;
> +	} else if ((rf_freq_khz > it9135_fn_min[7]) && (rf_freq_khz <= it9135_fn_min[8])) {	/* 573 890 */
> +		nc = 7;
> +	} else {		/* L-band */
> +		nc = 8;
> +	}

Code will be cleaner if you use a for loop.

> +
> +	return nc;
> +}
> +
> +static unsigned int it9135_tuner_get_freq_code(struct it9135_data *data,
> +					       unsigned int rf_freq_khz,
> +					       unsigned int *nc,
> +					       unsigned int *nv,
> +					       unsigned int *mv)
> +{
> +	unsigned int freq_code;
> +	unsigned long tmp_tg, tmp_cal, tmp_m;
> +
> +	*nc = it9135_tuner_get_nc(rf_freq_khz);
> +	*nv = it9135_tuner_get_nv(*nc);

The better would be to merge both functions into one, and use a loop inside it,
instead of 8 if's and 8 case conditions.

> +	tmp_tg =
> +	    (unsigned long)rf_freq_khz * (unsigned long)(*nv) *
> +	    (unsigned long)data->fdiv;
> +	tmp_m = (tmp_tg / (unsigned long)data->fxtal_khz);
> +	tmp_cal = tmp_m * (unsigned long)data->fxtal_khz;

On Linux, both "long" and "int" have 32 bits. If 32 bits is ok, you can just
remove the typecast and define tmp_* as unsigned int. On the other hand, if
you need 64 bits to avoid overflow, you'll need to use "u64" and use div_u64()
for division.

> +
> +	if ((tmp_tg - tmp_cal) >= (data->fxtal_khz >> 1))
> +		tmp_m = tmp_m + 1;
> +
> +	*mv = (unsigned int)(tmp_m);
> +
> +	freq_code = (((*nc) & 0x07) << 13) + (*mv);
> +
> +	return freq_code;
> +}
> +
> +static unsigned int it9135_tuner_get_freq_iqik(struct it9135_data *data,
> +					       unsigned int rf_freq_khz,
> +					       unsigned char iqik_m_cal)
> +{
> +	unsigned int nc, nv, mv, cal_freq;
> +
> +#define OMEGA_IQIK_M_CAL_MAX	64
> +#define OMEGA_IQIK_M_CAL_MID	32
> +
> +	cal_freq = it9135_tuner_get_freq_code(data, rf_freq_khz, &nc, &nv, &mv);
> +	if (data->clock_mode == 0 && (iqik_m_cal < OMEGA_IQIK_M_CAL_MID)) {
> +		mv = mv + ((((unsigned int)iqik_m_cal) * nv * 9) >> 5);
> +	} else if (data->clock_mode == 0
> +		   && (iqik_m_cal >= OMEGA_IQIK_M_CAL_MID)) {
> +		iqik_m_cal = OMEGA_IQIK_M_CAL_MAX - iqik_m_cal;
> +		mv = mv - ((((unsigned int)iqik_m_cal) * nv * 9) >> 5);
> +	} else if (data->clock_mode == 1 && (iqik_m_cal < OMEGA_IQIK_M_CAL_MID)) {
> +		mv = mv + ((((unsigned int)iqik_m_cal) * nv) >> 1);
> +	} else {		/* (data->clock_mode==1 && (iqik_m_cal >= OMEGA_IQIK_M_CAL_MID)) */
> +		iqik_m_cal = OMEGA_IQIK_M_CAL_MAX - iqik_m_cal;
> +		mv = mv - ((((unsigned int)iqik_m_cal) * nv) >> 1);
> +	}
> +	cal_freq = ((nc & 0x07) << 13) + mv;
> +
> +	return cal_freq;
> +}
> +
> +/* the reason to use 392000(but not 400000) because cal_rssi will use 400000-8000= 392000; */
> +static unsigned int it9135_lna_fband_min[] = {
> +	392000, 440000, 484000, 533000, 587000, 645000, 710000, 782000, 860000,
> +	1450000, 1492000, 1660000, 1685000
> +};
> +
> +static unsigned char it9135_tuner_get_lna_cap_sel(unsigned int rf_freq_khz)
> +{
> +	unsigned char lna_cap_sel;
> +
> +	if (rf_freq_khz <= it9135_lna_fband_min[1]) {	/* <=440 */
> +		lna_cap_sel = 0;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[1] && rf_freq_khz <= it9135_lna_fband_min[2]) {	/* 440 484 */
> +		lna_cap_sel = 1;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[2] && rf_freq_khz <= it9135_lna_fband_min[3]) {	/* 484 533 */
> +		lna_cap_sel = 2;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[3] && rf_freq_khz <= it9135_lna_fband_min[4]) {	/* 533 587 */
> +		lna_cap_sel = 3;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[4] && rf_freq_khz <= it9135_lna_fband_min[5]) {	/* 587 645 */
> +		lna_cap_sel = 4;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[5] && rf_freq_khz <= it9135_lna_fband_min[6]) {	/* 645 710 */
> +		lna_cap_sel = 5;
> +	} else if (rf_freq_khz > it9135_lna_fband_min[6] && rf_freq_khz <= it9135_lna_fband_min[7]) {	/* 710 782 */
> +		lna_cap_sel = 6;
> +	} else {		/* >782 */
> +		lna_cap_sel = 7;
> +	}

Same as above: Please use a loop for it.

> +
> +	return lna_cap_sel;
> +}
> +
> +static unsigned int it9135_tuner_get_lo_freq(struct it9135_data *data,
> +					     unsigned int rf_freq_khz)
> +{
> +	unsigned int nc, nv, mv, lo_freq;
> +
> +	lo_freq = it9135_tuner_get_freq_code(data, rf_freq_khz, &nc, &nv, &mv);
> +
> +	return lo_freq;
> +}
> +
> +static unsigned char it9135_tuner_get_lpf_bw(unsigned int bw_khz)
> +{
> +	unsigned char lpf_bw;
> +
> +	switch (bw_khz) {	/*5.0MHz */
> +	case 5000:
> +		lpf_bw = 0;
> +		break;
> +	case 5500:		/*5.5MHz */
> +		lpf_bw = 1;
> +		break;
> +	case 6000:		/*6.0MHz */
> +		lpf_bw = 2;
> +		break;
> +	case 6500:		/*6.5MHz */
> +		lpf_bw = 3;
> +		break;
> +	case 7000:		/*7.0MHz */
> +		lpf_bw = 4;
> +		break;
> +	case 7500:		/*7.5MHz */
> +		lpf_bw = 5;
> +		break;
> +	case 8000:		/*8.0MHz */
> +		lpf_bw = 6;
> +		break;
> +	case 8500:		/*8.5MHz */
> +		lpf_bw = 7;
> +		break;
> +	default:		/*default: 8MHz */
> +		lpf_bw = 6;
> +		break;
> +	}
> +
> +	return lpf_bw;
> +}
> +
> +static unsigned long it9135_tuner_set_freq(struct it9135_data *data,
> +					   unsigned char chip,
> +					   unsigned int bw_khz,
> +					   unsigned int rf_freq_khz)
> +{
> +	unsigned long error = 0;
> +	unsigned char val[7];
> +	unsigned char buf[2];
> +	unsigned int tmp;
> +
> +#define IT9135_CAP_FREQ_UHF_MIN		392000

Better to put all those devices altogheter on the beginning of the file.

> +
> +	/* p_reg_t_ctrl */
> +	error = it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xEC4C, 1, buf);
> +	if (error)
> +		goto exit;
> +	/* p_reg_p_iqik_m_cal */
> +	error =
> +	    it9135_read_regs(data, chip, PROCESSOR_OFDM, 0xED81, 1, &buf[1]);
> +	if (error)
> +		goto exit;
> +
> +	val[0] = it9135_tuner_get_lna_cap_sel(rf_freq_khz);
> +	val[1] = it9135_tuner_get_lpf_bw(bw_khz);
> +
> +	/* ----- set_rf_mode ----- */
> +	if (rf_freq_khz < IT9135_CAP_FREQ_UHF_MIN)
> +		val[2] = buf[0] & 0xE7;	/* ctrl<4:3>=0b00 for VHF */
> +	else
> +		val[2] = (buf[0] & 0xE7) | 0x08;	/* ctrl<4:3>=0b01 for UHF */
> +
> +	/* ----- set_cal_freq ----- */
> +	tmp = it9135_tuner_get_freq_iqik(data, rf_freq_khz, buf[1]);
> +	val[3] = (unsigned char)(tmp & 0xFF);
> +	val[4] = (unsigned char)((tmp >> 8) & 0xFF);
> +	/* ----- set_lo_freq ----- */
> +	tmp = it9135_tuner_get_lo_freq(data, rf_freq_khz);
> +	val[5] = (unsigned char)(tmp & 0xFF);
> +	val[6] = (unsigned char)((tmp >> 8) & 0xFF);
> +	/* ----- write ----- */
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, var_pre_lna_cap_sel,
> +			      1, val);
> +	if (error)
> +		goto exit;
> +	/* p_reg_t_lpf_bw */
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, 0xEC56, 1, &val[1]);
> +	if (error)
> +		goto exit;
> +	/* p_reg_t_ctrl */
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, 0xEC4C, 1, &val[2]);
> +	if (error)
> +		goto exit;
> +	/*----- the writing sequence is important for cal_freq and lo_freq, thus separate ----- */
> +	/* p_reg_t_cal_freq_7_0 */
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, 0xEC4D, 1, &val[3]);
> +	if (error)
> +		goto exit;
> +	/* p_reg_t_cal_freq_15_8 */
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, 0xEC4E, 1, &val[4]);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, var_pre_lo_freq_7_0,
> +			      1, &val[5]);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, var_pre_lo_freq_15_8,
> +			      1, &val[6]);
> +
> +exit:
> +	return error;
> +}
> +
> +/*
> + * Demodular functions
> + */
> +
> +static unsigned long it9135_divider(struct it9135_data *data, unsigned long a,
> +				    unsigned long b, unsigned long x)
> +{
> +	unsigned long answer = 0;
> +	unsigned long c = 0;
> +	unsigned long i = 0;
> +
> +	if (a > b) {
> +		c = a / b;
> +		a = a - c * b;
> +	}
> +
> +	for (i = 0; i < x; i++) {
> +		if (a >= b) {
> +			answer += 1;
> +			a -= b;
> +		}
> +		a <<= 1;
> +		answer <<= 1;
> +	}
> +
> +	answer = (c << (long)x) + answer;
> +
> +	return answer;
> +}


As I've explained above, "long" is 32 bits on Linux. You don't need that.
On the other hand, if you need 64 bits, just use one of the functions
defined on include/linux/math64.h.

> +
> +/* @param crystal_Freq: Crystal frequency (Hz) */
> +static unsigned long it9135_compute_crystal(struct it9135_data *data,
> +					    long crystal_frequency,
> +					    unsigned long *crystal)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	*crystal =
> +	    (long)it9135_divider(data, (unsigned long)crystal_frequency,
> +				 1000000ul, 19ul);
> +
> +	return error;
> +}
> +
> +/* @param adcFrequency: ADC frequency (Hz) */
> +static unsigned long it9135_compute_adc(struct it9135_data *data, long adc_freq,
> +					unsigned long *adc)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	*adc =
> +	    (long)it9135_divider(data, (unsigned long)adc_freq, 1000000ul,
> +				 19ul);
> +
> +	return error;
> +}
> +
> +/*
> + * @param adcFrequency: ADC frequency (Hz)
> + * @param ifFrequency:  IF frequency (Hz)
> + * @param inversion:    RF spectrum inversion
> + */
> +static unsigned long it9135_compute_fcw(struct it9135_data *data,
> +					long adc_frequency, long if_frequency,
> +					int inversion, unsigned long *fcw)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	long if_freq;
> +	long adc_freq;
> +	long adc_freq_half;
> +	long adc_freq_sample;
> +	long inv_bfs;
> +	long ctrl_word;
> +	unsigned char adc_multiplier;
> +
> +	adc_freq = adc_frequency;
> +	if_freq = if_frequency;
> +	adc_freq_half = adc_freq / 2;
> +
> +	if (inversion)
> +		if_freq = -1 * if_freq;
> +
> +	adc_freq_sample = if_freq;
> +
> +	if (adc_freq_sample >= 0) {
> +		inv_bfs = 1;
> +	} else {
> +		inv_bfs = -1;
> +		adc_freq_sample = adc_freq_sample * -1;
> +	}
> +
> +	while (adc_freq_sample > adc_freq_half)
> +		adc_freq_sample = adc_freq_sample - adc_freq;
> +
> +	/* Sample, spectrum at positive frequency */
> +	if (adc_freq_sample >= 0) {
> +		inv_bfs = inv_bfs * -1;
> +	} else {
> +		inv_bfs = inv_bfs * 1;
> +		adc_freq_sample = adc_freq_sample * (-1);	/* Absolute value */
> +	}
> +
> +	ctrl_word =
> +	    (long)it9135_divider(data, (unsigned long)adc_freq_sample,
> +				 (unsigned long)adc_freq, 23ul);
> +
> +	if (inv_bfs == -1)
> +		ctrl_word *= -1;
> +
> +	/* Get ADC multiplier */
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_OFDM, adcx2, &adc_multiplier);
> +	if (error)
> +		goto exit;
> +
> +	if (adc_multiplier == 1)
> +		ctrl_word /= 2;
> +
> +	*fcw = ctrl_word & 0x7FFFFF;
> +
> +exit:
> +	return error;
> +}
> +
> +static unsigned long it9135_mask_dca_output(struct it9135_data *data)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char i;
> +
> +	if ((data->chip_num > 1)
> +	    && (data->architecture == ARCHITECTURE_DCA)) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_upper_out_en,
> +						  reg_dca_upper_out_en_pos,
> +						  reg_dca_upper_out_en_len, 0);
> +			if (error)
> +				goto exit;
> +		}
> +		mdelay(5);
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +static struct it9135_coeff_param coeff_tab[] = {
> +	/* adc_freq 20156250 */
> +	{20156250, 5000, 0x02449b5c, 0x01224dae, 0x00912b60, 0x009126d7,
> +	 0x0091224e, 0x01224dae, 0x009126d7, 0x0048936b, 0x0387, 0x0122},
> +	{20156250, 6000, 0x02b8ba6e, 0x015c5d37, 0x00ae340d, 0x00ae2e9b,
> +	 0x00ae292a, 0x015c5d37, 0x00ae2e9b, 0x0057174e, 0x02f1, 0x015c},
> +	{20156250, 7000, 0x032cd980, 0x01966cc0, 0x00cb3cba, 0x00cb3660,
> +	 0x00cb3007, 0x01966cc0, 0x00cb3660, 0x00659b30, 0x0285, 0x0196},
> +	{20156250, 8000, 0x03a0f893, 0x01d07c49, 0x00e84567, 0x00e83e25,
> +	 0x00e836e3, 0x01d07c49, 0x00e83e25, 0x00741f12, 0x0234, 0x01d0},
> +	/* adc_freq 20187500 */
> +	{20187500, 5000, 0x0243b546, 0x0121daa3, 0x0090f1d9, 0x0090ed51,
> +	 0x0090e8ca, 0x0121daa3, 0x0090ed51, 0x004876a9, 0x0388, 0x0122},
> +	{20187500, 6000, 0x02b7a654, 0x015bd32a, 0x00adef04, 0x00ade995,
> +	 0x00ade426, 0x015bd32a, 0x00ade995, 0x0056f4ca, 0x02f2, 0x015c},
> +	{20187500, 7000, 0x032b9761, 0x0195cbb1, 0x00caec30, 0x00cae5d8,
> +	 0x00cadf81, 0x0195cbb1, 0x00cae5d8, 0x006572ec, 0x0286, 0x0196},
> +	{20187500, 8000, 0x039f886f, 0x01cfc438, 0x00e7e95b, 0x00e7e21c,
> +	 0x00e7dadd, 0x01cfc438, 0x00e7e21c, 0x0073f10e, 0x0235, 0x01d0},
> +	/* adc_freq 20250000 */
> +	{20250000, 5000, 0x0241eb3b, 0x0120f59e, 0x00907f53, 0x00907acf,
> +	 0x0090764b, 0x0120f59e, 0x00907acf, 0x00483d67, 0x038b, 0x0121},
> +	{20250000, 6000, 0x02b580ad, 0x015ac057, 0x00ad6597, 0x00ad602b,
> +	 0x00ad5ac1, 0x015ac057, 0x00ad602b, 0x0056b016, 0x02f4, 0x015b},
> +	{20250000, 7000, 0x03291620, 0x01948b10, 0x00ca4bda, 0x00ca4588,
> +	 0x00ca3f36, 0x01948b10, 0x00ca4588, 0x006522c4, 0x0288, 0x0195},
> +	{20250000, 8000, 0x039cab92, 0x01ce55c9, 0x00e7321e, 0x00e72ae4,
> +	 0x00e723ab, 0x01ce55c9, 0x00e72ae4, 0x00739572, 0x0237, 0x01ce},
> +	/* adc_freq 20583333 */
> +	{20583333, 5000, 0x02388f54, 0x011c47aa, 0x008e2846, 0x008e23d5,
> +	 0x008e1f64, 0x011c47aa, 0x008e23d5, 0x004711ea, 0x039a, 0x011c},
> +	{20583333, 6000, 0x02aa4598, 0x015522cc, 0x00aa96bb, 0x00aa9166,
> +	 0x00aa8c12, 0x015522cc, 0x00aa9166, 0x005548b3, 0x0300, 0x0155},
> +	{20583333, 7000, 0x031bfbdc, 0x018dfdee, 0x00c7052f, 0x00c6fef7,
> +	 0x00c6f8bf, 0x018dfdee, 0x00c6fef7, 0x00637f7b, 0x0293, 0x018e},
> +	{20583333, 8000, 0x038db21f, 0x01c6d910, 0x00e373a3, 0x00e36c88,
> +	 0x00e3656d, 0x01c6d910, 0x00e36c88, 0x0071b644, 0x0240, 0x01c7},
> +	/* adc_freq 20416667 */
> +	{20416667, 5000, 0x023d337f, 0x011e99c0, 0x008f515a, 0x008f4ce0,
> +	 0x008f4865, 0x011e99c0, 0x008f4ce0, 0x0047a670, 0x0393, 0x011f},
> +	{20416667, 6000, 0x02afd765, 0x0157ebb3, 0x00abfb39, 0x00abf5d9,
> +	 0x00abf07a, 0x0157ebb3, 0x00abf5d9, 0x0055faed, 0x02fa, 0x0158},
> +	{20416667, 7000, 0x03227b4b, 0x01913da6, 0x00c8a518, 0x00c89ed3,
> +	 0x00c8988e, 0x01913da6, 0x00c89ed3, 0x00644f69, 0x028d, 0x0191},
> +	{20416667, 8000, 0x03951f32, 0x01ca8f99, 0x00e54ef7, 0x00e547cc,
> +	 0x00e540a2, 0x01ca8f99, 0x00e547cc, 0x0072a3e6, 0x023c, 0x01cb},
> +	/* adc_freq 20480000 */
> +	{20480000, 5000, 0x023b6db7, 0x011db6db, 0x008edfe5, 0x008edb6e,
> +	 0x008ed6f7, 0x011db6db, 0x008edb6e, 0x00476db7, 0x0396, 0x011e},
> +	{20480000, 6000, 0x02adb6db, 0x0156db6e, 0x00ab7312, 0x00ab6db7,
> +	 0x00ab685c, 0x0156db6e, 0x00ab6db7, 0x0055b6db, 0x02fd, 0x0157},
> +	{20480000, 7000, 0x03200000, 0x01900000, 0x00c80640, 0x00c80000,
> +	 0x00c7f9c0, 0x01900000, 0x00c80000, 0x00640000, 0x028f, 0x0190},
> +	{20480000, 8000, 0x03924925, 0x01c92492, 0x00e4996e, 0x00e49249,
> +	 0x00e48b25, 0x01c92492, 0x00e49249, 0x00724925, 0x023d, 0x01c9},
> +	/* adc_freq 20500000 */
> +	{20500000, 5000, 0x023adeff, 0x011d6f80, 0x008ebc36, 0x008eb7c0,
> +	 0x008eb34a, 0x011d6f80, 0x008eb7c0, 0x00475be0, 0x0396, 0x011d},
> +	{20500000, 6000, 0x02ad0b99, 0x015685cc, 0x00ab4840, 0x00ab42e6,
> +	 0x00ab3d8c, 0x015685cc, 0x00ab42e6, 0x0055a173, 0x02fd, 0x0157},
> +	{20500000, 7000, 0x031f3832, 0x018f9c19, 0x00c7d44b, 0x00c7ce0c,
> +	 0x00c7c7ce, 0x018f9c19, 0x00c7ce0c, 0x0063e706, 0x0290, 0x0190},
> +	{20500000, 8000, 0x039164cb, 0x01c8b266, 0x00e46056, 0x00e45933,
> +	 0x00e45210, 0x01c8b266, 0x00e45933, 0x00722c99, 0x023e, 0x01c9},
> +	/* adc_freq 20625000 */
> +	{20625000, 5000, 0x02376948, 0x011bb4a4, 0x008ddec1, 0x008dda52,
> +	 0x008dd5e3, 0x011bb4a4, 0x008dda52, 0x0046ed29, 0x039c, 0x011c},
> +	{20625000, 6000, 0x02a8e4bd, 0x0154725e, 0x00aa3e81, 0x00aa392f,
> +	 0x00aa33de, 0x0154725e, 0x00aa392f, 0x00551c98, 0x0302, 0x0154},
> +	{20625000, 7000, 0x031a6032, 0x018d3019, 0x00c69e41, 0x00c6980c,
> +	 0x00c691d8, 0x018d3019, 0x00c6980c, 0x00634c06, 0x0294, 0x018d},
> +	{20625000, 8000, 0x038bdba6, 0x01c5edd3, 0x00e2fe02, 0x00e2f6ea,
> +	 0x00e2efd2, 0x01c5edd3, 0x00e2f6ea, 0x00717b75, 0x0242, 0x01c6}
> +};
> +
> +static int it915_coeff_tab_count = ARRAY_SIZE(coeff_tab);
> +
> +static unsigned long it9135_get_coeff_param(struct it9135_coeff_param *coeff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	int i;
> +
> +	deb_info("it9135_get_coeff_param - %ld, %d\n", coeff->adc_freq,
> +		 coeff->bandwidth);
> +
> +	for (i = 0; i < it915_coeff_tab_count; i++) {
> +		if ((coeff->adc_freq == coeff_tab[i].adc_freq)
> +		    && (coeff->bandwidth == coeff_tab[i].bandwidth)) {
> +			memcpy(coeff, &coeff_tab[i], sizeof(*coeff));
> +			deb_info("find coeff table - %ld, %d\n",
> +				 coeff->adc_freq, coeff->bandwidth);
> +			break;
> +		}
> +	}
> +
> +	if (i == it915_coeff_tab_count)
> +		error = ERROR_INVALID_BW;
> +
> +	return error;
> +}
> +
> +/*
> + * Program the bandwidth related parameters to IT9135.
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param bandwidth DVB channel bandwidth in KHz. The possible values
> + *        are 5000, 6000, 7000, and 8000 (KHz).
> + * @param adc_freq The value of desire internal ADC frequency (Hz) ex: 20480000.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +static unsigned long it9135_select_bandwidth(struct it9135_data *data,
> +					     unsigned char chip,
> +					     unsigned short bandwidth,
> +					     unsigned long adc_freq)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	struct it9135_coeff_param coeff;
> +	unsigned char temp0;
> +	unsigned char temp1;
> +	unsigned char temp2;
> +	unsigned char temp3;
> +	unsigned char buffer[36];
> +	unsigned char bw;
> +	unsigned char adc_multiplier;
> +
> +	switch (bandwidth) {
> +	case 5000:
> +		bw = 3;
> +		break;
> +	case 6000:
> +		bw = 0;
> +		break;
> +	case 7000:
> +		bw = 1;
> +		break;
> +	case 8000:
> +		bw = 2;
> +		break;
> +	default:
> +		error = ERROR_INVALID_BW;

-EINVAL

> +		goto exit;
> +	}
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM, g_reg_bw,
> +				  reg_bw_pos, reg_bw_len, bw);
> +	if (error)
> +		goto exit;
> +
> +	/* Program CFOE */
> +	coeff.adc_freq = adc_freq;
> +	coeff.bandwidth = bandwidth;
> +	error = it9135_get_coeff_param(&coeff);
> +	if (error)
> +		goto exit;
> +
> +	/* Get ADC multiplier */
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_OFDM, adcx2, &adc_multiplier);
> +	if (error)
> +		goto exit;
> +
> +	if (adc_multiplier == 1) {
> +		coeff.coeff1_2048Nu /= 2;
> +		coeff.coeff1_4096Nu /= 2;
> +		coeff.coeff1_8191Nu /= 2;
> +		coeff.coeff1_8192Nu /= 2;
> +		coeff.coeff1_8193Nu /= 2;
> +		coeff.coeff2_2k /= 2;
> +		coeff.coeff2_4k /= 2;
> +		coeff.coeff2_8k /= 2;
> +	}
> +
> +	/* Write coeff1_2048Nu */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)(coeff.coeff1_2048Nu & 0x000000FF);
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff1_2048Nu & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff1_2048Nu & 0x00FF0000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff1_2048Nu & 0x03000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_2048_coeff1_25_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_2048_coeff1_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_2048_coeff1_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_2048_coeff1_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff2_2k */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)((coeff.coeff2_2k & 0x000000FF));
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff2_2k & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff2_2k & 0x00FF0000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff2_2k & 0x01000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_2k_coeff2_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_2k_coeff2_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_2k_coeff2_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_2k_coeff2_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff1_8191Nu */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)((coeff.coeff1_8191Nu & 0x000000FF));
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff1_8191Nu & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff1_8191Nu & 0x00FFC000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff1_8191Nu & 0x03000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_8191_coeff1_25_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_8191_coeff1_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_8191_coeff1_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_8191_coeff1_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff1_8192Nu */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)(coeff.coeff1_8192Nu & 0x000000FF);
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff1_8192Nu & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff1_8192Nu & 0x00FFC000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff1_8192Nu & 0x03000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_8192_coeff1_25_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_8192_coeff1_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_8192_coeff1_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_8192_coeff1_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff1_8193Nu */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)((coeff.coeff1_8193Nu & 0x000000FF));
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff1_8193Nu & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff1_8193Nu & 0x00FFC000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff1_8193Nu & 0x03000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_8193_coeff1_25_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_8193_coeff1_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_8193_coeff1_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_8193_coeff1_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff2_8k */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)((coeff.coeff2_8k & 0x000000FF));
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff2_8k & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff2_8k & 0x00FF0000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff2_8k & 0x01000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_8k_coeff2_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_8k_coeff2_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_8k_coeff2_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_8k_coeff2_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff1_4096Nu */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)(coeff.coeff1_4096Nu & 0x000000FF);
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff1_4096Nu & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff1_4096Nu & 0x00FF0000) >> 16);
> +	/* Get unsigned char3[1:0] */
> +	/* Bit[7:2] will be written soon and so don't have to care them */
> +	temp3 = (unsigned char)((coeff.coeff1_4096Nu & 0x03000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_4096_coeff1_25_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_4096_coeff1_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_4096_coeff1_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_4096_coeff1_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Write coeff2_4k */
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)((coeff.coeff2_4k & 0x000000FF));
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.coeff2_4k & 0x0000FF00) >> 8);
> +	/* Get unsigned char2 */
> +	temp2 = (unsigned char)((coeff.coeff2_4k & 0x00FF0000) >> 16);
> +	/* Get unsigned char3 */
> +	temp3 = (unsigned char)((coeff.coeff2_4k & 0x01000000) >> 24);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[cfoe_NS_4k_coeff2_24 - cfoe_NS_2048_coeff1_25_24] = temp3;
> +	buffer[cfoe_NS_4k_coeff2_23_16 - cfoe_NS_2048_coeff1_25_24] = temp2;
> +	buffer[cfoe_NS_4k_coeff2_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[cfoe_NS_4k_coeff2_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)(coeff.bfsfcw_fftindex_ratio & 0x00FF);
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.bfsfcw_fftindex_ratio & 0xFF00) >> 8);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[bfsfcw_fftindex_ratio_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[bfsfcw_fftindex_ratio_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	/* Get unsigned char0 */
> +	temp0 = (unsigned char)(coeff.fftindex_bfsfcw_ratio & 0x00FF);
> +	/* Get unsigned char1 */
> +	temp1 = (unsigned char)((coeff.fftindex_bfsfcw_ratio & 0xFF00) >> 8);
> +
> +	/* Big endian to make 8051 happy */
> +	buffer[fftindex_bfsfcw_ratio_15_8 - cfoe_NS_2048_coeff1_25_24] = temp1;
> +	buffer[fftindex_bfsfcw_ratio_7_0 - cfoe_NS_2048_coeff1_25_24] = temp0;
> +
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM,
> +			      cfoe_NS_2048_coeff1_25_24, 36, buffer);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	return error;
> +}
> +
> +/*
> + * The type defination of band table.
> + */
> +struct it9135_freq_band {
> +	unsigned long mini;	/* The minimum frequency of this band */
> +	unsigned long max;	/* The maximum frequency of this band */
> +};
> +
> +static struct it9135_freq_band it9135_freq_band_tab[] = {
> +	{30000, 300000},	/* VHF 30MHz ~ 300MHz */
> +	{300000, 1000000},	/* UHF 300MHz ~ 1000MHz */
> +	{1670000, 1680000}	/* L-BAND */
> +};
> +
> +static int it915_freq_band_tab_count = ARRAY_SIZE(it9135_freq_band_tab);
> +
> +/*
> + * Set frequency.
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + * @param frequency The desired frequency.
> + * @return ERROR_NO_ERROR: successful, other non-zero error code otherwise.
> + */
> +static unsigned long it9135_set_frequency(struct it9135_data *data,
> +					  unsigned char chip,
> +					  unsigned long frequency)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long freq = frequency;
> +	unsigned char band;
> +	unsigned char i;
> +
> +	/* Clear easy mode flag first */
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, Training_Mode, 0x00);
> +	if (error)
> +		goto exit;
> +
> +	/* Clear empty_channel_status lock flag */
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, empty_channel_status,
> +			     0x00);
> +	if (error)
> +		goto exit;
> +
> +	/* Clear MPEG2 lock flag */
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  r_mp2if_sync_byte_locked,
> +				  mp2if_sync_byte_locked_pos,
> +				  mp2if_sync_byte_locked_len, 0x00);
> +	if (error)
> +		goto exit;
> +
> +	/* Determine frequency band */
> +	band = 0xFF;
> +	for (i = 0; i < it915_freq_band_tab_count; i++) {
> +		if ((frequency >= it9135_freq_band_tab[i].mini)
> +		    && (frequency <= it9135_freq_band_tab[i].max)) {
> +			band = i;
> +			break;
> +		}
> +	}
> +	error = it9135_write_reg(data, chip, PROCESSOR_OFDM, FreBand, band);
> +	if (error)
> +		goto exit;
> +
> +	if (data->chip_num > 1 && chip == 0)
> +		freq += 100;
> +	else if (data->chip_num > 1 && chip == 1)
> +		freq -= 100;
> +
> +	error =
> +	    it9135_tuner_set_freq(data, chip, data->bandwidth[chip], frequency);
> +	if (error)
> +		goto exit;
> +
> +	/* Trigger ofsm */
> +	error = it9135_write_reg(data, chip, PROCESSOR_OFDM, trigger_ofsm, 0);
> +	if (error)
> +		goto exit;
> +
> +	data->frequency[chip] = frequency;
> +
> +exit:
> +	return error;
> +}
> +
> +/*
> + * Load firmware to device
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @fw_codes pointer to fw binary.
> + * @fw_segs pointer to fw segments.
> + * @fw_parts pointer to fw partition.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +static unsigned long it9135_load_firmware(struct it9135_data *data,
> +					  unsigned char *fw_codes,
> +					  struct it9135_segment *fw_segs,
> +					  unsigned char *fw_parts)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long beginPartition = 0;
> +	unsigned long endPartition = 0;
> +	unsigned long version;
> +	unsigned long firmwareLength;
> +	unsigned char *firmwareCodesPointer;
> +	unsigned short command;
> +	unsigned long i;
> +
> +/* Define I2C master speed, the default value 0x07 means 366KHz (1000000000 / (24.4 * 16 * User_I2C_SPEED)). */
> +#define User_I2C_SPEED              0x07
> +
> +	/* Set I2C master clock speed. */
> +	error =
> +	    it9135_write_reg(data, 0, PROCESSOR_LINK,
> +			     p_reg_one_cycle_counter_tuner, User_I2C_SPEED);
> +	if (error)
> +		goto exit;
> +
> +	firmwareCodesPointer = fw_codes;
> +
> +	beginPartition = 0;
> +	endPartition = fw_parts[0];
> +
> +	for (i = beginPartition; i < endPartition; i++) {
> +		firmwareLength = fw_segs[i].length;
> +		if (fw_segs[i].type == 0) {
> +			/* Dwonload firmware */
> +			error =
> +			    it9135_cmd_sendcommand(data, CMD_FW_DOWNLOAD_BEGIN,
> +						   0, PROCESSOR_LINK, 0, NULL,
> +						   0, NULL);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_cmd_loadfirmware(data, firmwareLength,
> +						    firmwareCodesPointer);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_cmd_sendcommand(data, CMD_FW_DOWNLOAD_END, 0,
> +						   PROCESSOR_LINK, 0, NULL, 0,
> +						   NULL);
> +			if (error)
> +				goto exit;
> +		} else if (fw_segs[i].type == 1) {
> +			/* Copy firmware */
> +			error =
> +			    it9135_cmd_sendcommand(data,
> +						   CMD_SCATTER_WRITE, 0,
> +						   PROCESSOR_LINK,
> +						   firmwareLength,
> +						   firmwareCodesPointer, 0,
> +						   NULL);
> +			if (error)
> +				goto exit;
> +		} else {
> +			/* Direct write firmware */
> +			command =
> +			    (unsigned short)(firmwareCodesPointer[0] << 8) +
> +			    (unsigned short)firmwareCodesPointer[1];
> +			error =
> +			    it9135_cmd_sendcommand(data, command, 0,
> +						   PROCESSOR_LINK,
> +						   firmwareLength - 2,
> +						   firmwareCodesPointer + 2, 0,
> +						   NULL);
> +			if (error)
> +				goto exit;
> +		}
> +		firmwareCodesPointer += firmwareLength;
> +	}
> +
> +	/* Boot */
> +	error =
> +	    it9135_cmd_sendcommand(data, CMD_BOOT, 0, PROCESSOR_LINK, 0, NULL,
> +				   0, NULL);
> +	if (error)
> +		goto exit;
> +
> +	mdelay(10);
> +
> +	/* Check if firmware is running */
> +	version = 0;
> +	error = it9135_get_fw_ver(data, PROCESSOR_LINK, &version);
> +	if (error)
> +		goto exit;
> +	if (version == 0)
> +		error = ERROR_BOOT_FAIL;
> +
> +exit:
> +	return error;
> +}
> +
> +/*
> + * Load initial script to device
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @script_sets pointer to script_sets.
> + * @scripts pointer to fw scripts.
> + * @tuner_script_sets pointer to tunerScriptSets.
> + * @tuner_scripts pointer to tunerScripts.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +static unsigned long it9135_load_script(struct it9135_data *data,
> +					unsigned short *script_sets,
> +					struct it9135_val_set *scripts,
> +					unsigned short *tuner_script_sets,
> +					struct it9135_val_set *tuner_scripts)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short beginScript;
> +	unsigned short endScript;
> +	unsigned char i, value1 = 0, prechip_version = 0, supportRelay =
> +	    0, chip_num = 0, bufferLens = 1;
> +	unsigned short j;
> +	unsigned char buffer[20] = { 0 };
> +	unsigned long tunerAddr, tunerAddrTemp;
> +
> +	/* Querry SupportRelayCommandWrite */
> +	error = it9135_read_reg(data, 0, PROCESSOR_OFDM, 0x004D, &supportRelay);
> +	if (error)
> +		goto exit;
> +
> +	if (supportRelay && data->chip_num == 2)
> +		chip_num = 1;
> +	else
> +		chip_num = data->chip_num;
> +
> +	/* Enable RelayCommandWrite */
> +	if (supportRelay) {
> +		error = it9135_write_reg(data, 0, PROCESSOR_OFDM, 0x004E, 1);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	if ((script_sets[0] != 0) && (scripts != NULL)) {
> +		beginScript = 0;
> +		endScript = script_sets[0];
> +
> +		for (i = 0; i < chip_num; i++) {
> +			/* Load OFSM init script */
> +			for (j = beginScript; j < endScript; j++) {
> +				tunerAddr = tunerAddrTemp = scripts[j].address;
> +				buffer[0] = scripts[j].value;
> +
> +				while (j < endScript && bufferLens < 20) {
> +					tunerAddrTemp += 1;
> +					if (tunerAddrTemp !=
> +					    scripts[j + 1].address)
> +						break;
> +
> +					buffer[bufferLens] =
> +					    scripts[j + 1].value;
> +					bufferLens++;
> +					j++;
> +				}
> +
> +				error =
> +				    it9135_write_regs(data, i, PROCESSOR_OFDM,
> +						      tunerAddr, bufferLens,
> +						      buffer);
> +				if (error)
> +					goto exit;
> +				bufferLens = 1;
> +			}
> +		}
> +	}
> +
> +	/* Distinguish chip type */
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_LINK, chip_version_7_0, &value1);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_LINK, prechip_version_7_0,
> +			    &prechip_version);
> +	if (error)
> +		goto exit;
> +
> +	if ((tuner_script_sets[0] != 0) && (tuner_scripts != NULL)) {
> +		if (tuner_script_sets[1] == tuner_script_sets[0]
> +		    && !(data->chip_ver == 0xF8 && prechip_version == 0xEA)) {
> +			/* New version */
> +			beginScript = tuner_script_sets[0];
> +			endScript = tuner_script_sets[0] + tuner_script_sets[1];
> +		} else {
> +			/* Old version */
> +			beginScript = 0;
> +			endScript = tuner_script_sets[0];
> +		}
> +
> +		for (i = 0; i < chip_num; i++) {
> +			/* Load tuner init script */
> +			for (j = beginScript; j < endScript; j++) {
> +				tunerAddr = tunerAddrTemp =
> +				    tuner_scripts[j].address;
> +				buffer[0] = tuner_scripts[j].value;
> +
> +				while (j < endScript && bufferLens < 20) {
> +					tunerAddrTemp += 1;
> +					if (tunerAddrTemp !=
> +					    tuner_scripts[j + 1].address)
> +						break;
> +
> +					buffer[bufferLens] =
> +					    tuner_scripts[j + 1].value;
> +					bufferLens++;
> +					j++;
> +				}
> +
> +				error =
> +				    it9135_write_regs(data, i, PROCESSOR_OFDM,
> +						      tunerAddr, bufferLens,
> +						      buffer);
> +				if (error)
> +					goto exit;
> +				bufferLens = 1;
> +			}
> +		}
> +	}
> +
> +	/* Disable RelayCommandWrite */
> +	if (supportRelay) {
> +		error = it9135_write_reg(data, 0, PROCESSOR_OFDM, 0x004E, 0);
> +		if (error)
> +			goto exit;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +/* end of local functions */
> +
> +unsigned long it9135_write_regs(struct it9135_data *data, unsigned char chip,
> +				unsigned char processor, unsigned long reg_addr,
> +				unsigned long w_buff_len, unsigned char *w_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +	unsigned long remain_len;
> +	unsigned long send_len;
> +	unsigned long i;
> +	unsigned char reg_addr_len = 2;
> +
> +	it9135_enter_mutex(data);
> +
> +	if (w_buff_len == 0)
> +		goto exit;
> +	if (reg_addr_len > 4) {
> +		error = ERROR_PROTOCOL_FORMAT_INVALID;
> +		goto exit;
> +	}
> +
> +	if ((w_buff_len + 12) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	/* add frame header */
> +	command = it9135_build_command(CMD_REG_DEMOD_WRITE, processor, chip);
> +	buffer[1] = (unsigned char)(command >> 8);
> +	buffer[2] = (unsigned char)command;
> +	buffer[3] = (unsigned char)data->cmd_seq++;
> +	buffer[4] = (unsigned char)w_buff_len;
> +	buffer[5] = (unsigned char)reg_addr_len;
> +	buffer[6] = (unsigned char)((reg_addr) >> 24);	/* Get first unsigned char of reg. address  */
> +	buffer[7] = (unsigned char)((reg_addr) >> 16);	/* Get second unsigned char of reg. address */
> +	buffer[8] = (unsigned char)((reg_addr) >> 8);	/* Get third unsigned char of reg. address  */
> +	buffer[9] = (unsigned char)(reg_addr);	/* Get fourth unsigned char of reg. address */
> +
> +	/* add frame data */
> +	for (i = 0; i < w_buff_len; i++)
> +		buffer[10 + i] = w_buff[i];
> +
> +	/* add frame check-sum */
> +	buff_len = 10 + w_buff_len;
> +	error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* send frame */
> +	i = 0;
> +	send_len = 0;
> +	remain_len = buff_len;
> +	while (remain_len > 0) {
> +		i = (remain_len > IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +		    : (remain_len);
> +		error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +		if (error)
> +			goto exit;
> +
> +		send_len += i;
> +		remain_len -= i;
> +	}
> +
> +	/* get reply frame */
> +	buff_len = 5;
> +	error = it9135_cmd_bus_rx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* remove check-sum from reply frame */
> +	error = it9135_cmd_remove_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +unsigned long it9135_write_gen_regs(struct it9135_data *data,
> +				    unsigned char chip,
> +				    unsigned char interfaceIndex,
> +				    unsigned char slaveAddress,
> +				    unsigned char buff_len,
> +				    unsigned char *buffer)
> +{
> +	unsigned char w_buff[256];
> +	unsigned char i;
> +
> +	w_buff[0] = buff_len;
> +	w_buff[1] = interfaceIndex;
> +	w_buff[2] = slaveAddress;
> +
> +	for (i = 0; i < buff_len; i++)
> +		w_buff[3 + i] = buffer[i];
> +
> +	return it9135_cmd_sendcommand(data, CMD_GENERIC_WRITE, chip,
> +				      PROCESSOR_LINK, buff_len + 3, w_buff, 0,
> +				      NULL);
> +}
> +
> +unsigned long it9135_write_reg(struct it9135_data *data, unsigned char chip,
> +			       unsigned char processor, unsigned long reg_addr,
> +			       unsigned char value)
> +{
> +	return it9135_write_regs(data, chip, processor, reg_addr, 1, &value);
> +}
> +
> +unsigned long it9135_write_ee_vals(struct it9135_data *data, unsigned char chip,
> +				   unsigned short reg_addr,
> +				   unsigned char w_buff_len,
> +				   unsigned char *w_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +	unsigned long remain_len;
> +	unsigned long send_len;
> +	unsigned long i;
> +	unsigned char eeprom_addr = 1;
> +	unsigned char reg_addr_len = 1;
> +
> +	it9135_enter_mutex(data);
> +
> +	if (w_buff_len == 0)
> +		goto exit;
> +
> +	if ((unsigned long)(w_buff_len + 11) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	/* add frame header */
> +	command =
> +	    it9135_build_command(CMD_REG_EEPROM_WRITE, PROCESSOR_LINK, chip);
> +	buffer[1] = (unsigned char)(command >> 8);
> +	buffer[2] = (unsigned char)command;
> +	buffer[3] = (unsigned char)data->cmd_seq++;
> +	buffer[4] = (unsigned char)w_buff_len;
> +	buffer[5] = (unsigned char)eeprom_addr;
> +	buffer[6] = (unsigned char)reg_addr_len;
> +	buffer[7] = (unsigned char)(reg_addr >> 8);	/* Get high unsigned char of reg. address */
> +	buffer[8] = (unsigned char)reg_addr;	/* Get low unsigned char of reg. address  */
> +
> +	/* add frame data */
> +	for (i = 0; i < w_buff_len; i++)
> +		buffer[9 + i] = w_buff[i];
> +
> +	/* add frame check-sum */
> +	buff_len = 9 + w_buff_len;
> +	error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* send frame */
> +	i = 0;
> +	send_len = 0;
> +	remain_len = buff_len;
> +	while (remain_len > 0) {
> +		i = (remain_len > IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +		    : (remain_len);
> +		error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +		if (error)
> +			goto exit;
> +
> +		send_len += i;
> +		remain_len -= i;
> +	}
> +
> +	/* get reply frame */
> +	buff_len = 5;
> +	error = it9135_cmd_bus_rx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* remove check-sum from reply frame */
> +	error = it9135_cmd_remove_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +static unsigned char it9135_reg_bit_mask[8] = {
> +	0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF
> +};
> +
> +unsigned long it9135_write_reg_bits(struct it9135_data *data,
> +				    unsigned char chip, unsigned char processor,
> +				    unsigned long reg_addr,
> +				    unsigned char position,
> +				    unsigned char length, unsigned char value)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +
> +	if (length == 8) {
> +		error =
> +		    it9135_write_regs(data, chip, processor, reg_addr, 1,
> +				      &value);
> +	} else {
> +		error =
> +		    it9135_read_regs(data, chip, processor, reg_addr, 1, &temp);
> +		if (error)
> +			goto exit;
> +
> +		temp =
> +		    REG_CREATE(it9135_reg_bit_mask, value, temp, position,
> +			       length);
> +
> +		error =
> +		    it9135_write_regs(data, chip, processor, reg_addr, 1,
> +				      &temp);
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_read_reg(struct it9135_data *data, unsigned char chip,
> +			      unsigned char processor, unsigned long reg_addr,
> +			      unsigned char *value)
> +{
> +	return it9135_read_regs(data, chip, processor, reg_addr, 1, value);
> +}
> +
> +unsigned long it9135_read_regs(struct it9135_data *data, unsigned char chip,
> +			       unsigned char processor, unsigned long reg_addr,
> +			       unsigned long r_buff_len, unsigned char *r_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +	unsigned long send_len;
> +	unsigned long remain_len;
> +	unsigned long i, k;
> +	unsigned char reg_addr_len = 2;
> +
> +	it9135_enter_mutex(data);
> +
> +	if (r_buff_len == 0)
> +		goto exit;
> +	if (reg_addr_len > 4) {
> +		error = ERROR_PROTOCOL_FORMAT_INVALID;
> +		goto exit;
> +	}
> +
> +	if ((r_buff_len + 5) > IT9135_MAX_PKT_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	if ((r_buff_len + 5) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	/* add frame header */
> +	command = it9135_build_command(CMD_REG_DEMOD_READ, processor, chip);
> +	buffer[1] = (unsigned char)(command >> 8);
> +	buffer[2] = (unsigned char)command;
> +	buffer[3] = (unsigned char)data->cmd_seq++;
> +	buffer[4] = (unsigned char)r_buff_len;
> +	buffer[5] = (unsigned char)reg_addr_len;
> +	buffer[6] = (unsigned char)(reg_addr >> 24);	/* Get first unsigned char of reg. address  */
> +	buffer[7] = (unsigned char)(reg_addr >> 16);	/* Get second unsigned char of reg. address */
> +	buffer[8] = (unsigned char)(reg_addr >> 8);	/* Get third unsigned char of reg. address  */
> +	buffer[9] = (unsigned char)(reg_addr);	/* Get fourth unsigned char of reg. address */
> +
> +	/* add frame check-sum */
> +	buff_len = 10;
> +	error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* send frame */
> +	i = 0;
> +	send_len = 0;
> +	remain_len = buff_len;
> +	while (remain_len > 0) {
> +		i = (remain_len > IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +		    : (remain_len);
> +		error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +		if (error)
> +			goto exit;
> +
> +		send_len += i;
> +		remain_len -= i;
> +	}
> +
> +	/* get reply frame */
> +	buff_len = 5 + r_buff_len;
> +	error = it9135_cmd_bus_rx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* remove check-sum from reply frame */
> +	error = it9135_cmd_remove_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	for (k = 0; k < r_buff_len; k++)
> +		r_buff[k] = buffer[k + 3];
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +unsigned long it9135_read_gen_regs(struct it9135_data *data, unsigned char chip,
> +				   unsigned char interfaceIndex,
> +				   unsigned char slaveAddress,
> +				   unsigned char buff_len,
> +				   unsigned char *buffer)
> +{
> +	unsigned char w_buff[3];
> +
> +	w_buff[0] = buff_len;
> +	w_buff[1] = interfaceIndex;
> +	w_buff[2] = slaveAddress;
> +
> +	return it9135_cmd_sendcommand(data, CMD_GENERIC_READ, chip,
> +				      PROCESSOR_LINK, 3, w_buff, buff_len,
> +				      buffer);
> +}
> +
> +unsigned long it9135_read_ee_vals(struct it9135_data *data, unsigned char chip,
> +				  unsigned short reg_addr,
> +				  unsigned char r_buff_len,
> +				  unsigned char *r_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short command;
> +	unsigned char buffer[255];
> +	unsigned long buff_len;
> +	unsigned long remain_len;
> +	unsigned long send_len;
> +	unsigned long i, k;
> +	unsigned char eeprom_addr = 1;
> +	unsigned char reg_addr_len = 1;
> +
> +	it9135_enter_mutex(data);
> +
> +	if (r_buff_len == 0)
> +		goto exit;
> +
> +	if ((unsigned long)(r_buff_len + 5) > IT9135_MAX_PKT_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	if ((unsigned long)(r_buff_len + 5) > IT9135_MAX_CMD_SIZE) {
> +		error = ERROR_INVALID_DATA_LENGTH;
> +		goto exit;
> +	}
> +
> +	/* add command header */
> +	command =
> +	    it9135_build_command(CMD_REG_EEPROM_READ, PROCESSOR_LINK, chip);
> +	buffer[1] = (unsigned char)(command >> 8);
> +	buffer[2] = (unsigned char)command;
> +	buffer[3] = (unsigned char)data->cmd_seq++;
> +	buffer[4] = (unsigned char)r_buff_len;
> +	buffer[5] = (unsigned char)eeprom_addr;
> +	buffer[6] = (unsigned char)reg_addr_len;
> +	buffer[7] = (unsigned char)(reg_addr >> 8);	/* Get high unsigned char of reg. address */
> +	buffer[8] = (unsigned char)reg_addr;	/* Get low unsigned char of reg. address  */
> +
> +	/* add frame check-sum */
> +	buff_len = 9;
> +	error = it9135_cmd_add_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* send frame */
> +	i = 0;
> +	send_len = 0;
> +	remain_len = buff_len;
> +	while (remain_len > 0) {
> +		i = (remain_len > IT9135_MAX_PKT_SIZE) ? (IT9135_MAX_PKT_SIZE)
> +		    : (remain_len);
> +		error = it9135_cmd_bus_tx(data, i, &buffer[send_len]);
> +		if (error)
> +			goto exit;
> +
> +		send_len += i;
> +		remain_len -= i;
> +	}
> +
> +	/* get reply frame */
> +	buff_len = 5 + r_buff_len;
> +	error = it9135_cmd_bus_rx(data, buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	/* remove frame check-sum */
> +	error = it9135_cmd_remove_checksum(data, &buff_len, buffer);
> +	if (error)
> +		goto exit;
> +
> +	for (k = 0; k < r_buff_len; k++)
> +		r_buff[k] = buffer[k + 3];
> +
> +exit:
> +	it9135_leave_mutex(data);
> +	return error;
> +}
> +
> +unsigned long it9135_read_reg_bits(struct it9135_data *data,
> +				   unsigned char chip, unsigned char processor,
> +				   unsigned long reg_addr,
> +				   unsigned char position, unsigned char length,
> +				   unsigned char *value)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp = 0;
> +
> +	error = it9135_read_regs(data, chip, processor, reg_addr, 1, &temp);
> +	if (error)
> +		goto exit;
> +
> +	if (length == 8) {
> +		*value = temp;
> +	} else {
> +		temp = REG_GET(it9135_reg_bit_mask, temp, position, length);
> +		*value = temp;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_get_fw_ver(struct it9135_data *data,
> +				unsigned char processor, unsigned long *version)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char w_buff[1] = { 1 };
> +	unsigned char r_buff[4] = { 0, 0, 0, 0 };
> +
> +	error =
> +	    it9135_cmd_sendcommand(data, CMD_QUERYINFO, 0, processor, 1, w_buff,
> +				   4, r_buff);
> +	if (error)
> +		goto exit;
> +
> +	*version =
> +	    (unsigned long)(((unsigned long)r_buff[0] << 24) +
> +			    ((unsigned long)r_buff[1] << 16) +
> +			    ((unsigned long)r_buff[2] << 8) +
> +			    (unsigned long)r_buff[3]);
> +
> +exit:
> +	return error;
> +}
> +
> +/*
> + * Set the counting range for Post-Viterbi and Post-Viterbi.
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param post_err_cnt the number of super frame for Pre-Viterbi (24 bits).
> + * @param post_bit_cnt the number of packet unit for Post-Viterbi (16 bits).
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_post_vitber(struct it9135_data *data,
> +				     unsigned char chip,
> +				     unsigned long *post_err_cnt,
> +				     unsigned long *post_bit_cnt,
> +				     unsigned short *abort_cnt)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long err_cnt;
> +	unsigned long bit_cnt;
> +	unsigned char buffer[7];
> +	unsigned short abort;
> +
> +	*post_err_cnt = 0;
> +	*post_bit_cnt = 0;
> +
> +	error =
> +	    it9135_read_regs(data, chip, PROCESSOR_OFDM,
> +			     rsd_abort_packet_cnt_7_0,
> +			     r_rsd_packet_unit_15_8 - rsd_abort_packet_cnt_7_0 +
> +			     1, buffer);
> +	if (error)
> +		goto exit;
> +
> +	abort = ((unsigned short)
> +		 buffer[rsd_abort_packet_cnt_15_8 - rsd_abort_packet_cnt_7_0]
> +		 << 8) + buffer[rsd_abort_packet_cnt_7_0 -
> +				rsd_abort_packet_cnt_7_0];
> +	err_cnt = ((unsigned long)
> +		   buffer[rsd_bit_err_cnt_23_16 -
> +			  rsd_abort_packet_cnt_7_0] << 16) + ((unsigned long)
> +							      buffer
> +							      [rsd_bit_err_cnt_15_8
> +							       -
> +							       rsd_abort_packet_cnt_7_0]
> +							      << 8) +
> +	    buffer[rsd_bit_err_cnt_7_0 - rsd_abort_packet_cnt_7_0];
> +	bit_cnt = ((unsigned long)
> +		   buffer[r_rsd_packet_unit_15_8 -
> +			  rsd_abort_packet_cnt_7_0] << 8) +
> +	    buffer[r_rsd_packet_unit_7_0 - rsd_abort_packet_cnt_7_0];
> +
> +	if (bit_cnt == 0) {
> +		/*error = ERROR_RSD_PKT_CNT_0; */
> +		*post_err_cnt = 1;
> +		*post_bit_cnt = 2;
> +		*abort_cnt = 1000;
> +		goto exit;
> +	}
> +
> +	*abort_cnt = abort;
> +	bit_cnt = bit_cnt - (unsigned long)abort;
> +	if (bit_cnt == 0) {
> +		*post_err_cnt = 1;
> +		*post_bit_cnt = 2;
> +	} else {
> +		*post_err_cnt = err_cnt - (unsigned long)abort * 8 * 8;
> +		*post_bit_cnt = bit_cnt * 204 * 8;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +/* NorDig 3.4.4.6 & Table 3.4 */
> +static int it9135_Pref_values[3][5] = {
> +	{-93, -91, -90, -89, -88},	/* QPSK    CodeRate 1/2 ~ 7/8 Pref Values */
> +	{-87, -85, -84, -83, -82},	/* 16QAM   CodeRate 1/2 ~ 7/8 Pref Values */
> +	{-82, -80, -78, -77, -76},	/* 64QAM   CodeRate 1/2 ~ 7/8 Pref Values */
> +};
> +
> +/*
> + * Get siganl quality.


typo: signal instead of siganl

> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param quality The value of signal quality.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_signal_quality(struct it9135_data *data,
> +					unsigned char chip,
> +					unsigned char *quality)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	error = it9135_read_reg(data, chip, PROCESSOR_OFDM, signal_quality, quality);
> +	
> +	return (error);

Don't use parenthesis for return. You should check your code with:

	scripts/checkpatch.pl

This script points you about trivial Coding Style issues like that.


> +}
> +
> +unsigned long it9135_get_strength(struct it9135_data *data, unsigned char chip,
> +				  unsigned char *strength)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp, lna_gain_offset;
> +	struct it9135_ch_modulation ch_modulation;
> +	int Prec, Pref, Prel;
> +
> +	error =
> +	    it9135_read_reg(data, chip, PROCESSOR_OFDM, var_p_inband, &temp);
> +	if (error)
> +		goto exit;
> +
> +	error = it9135_get_ch_modulation(data, chip, &ch_modulation);
> +	if (error)
> +		goto exit;
> +
> +	if (ch_modulation.frequency < 300000)
> +		lna_gain_offset = 7;	/* VHF */
> +	else
> +		lna_gain_offset = 14;	/* UHF */
> +
> +	Prec = (temp - 100) - lna_gain_offset;
> +
> +	if (ch_modulation.priority == PRIORITY_HIGH)
> +		Pref = it9135_Pref_values[ch_modulation.constellation]
> +		    [ch_modulation.h_code_rate];
> +	else
> +		Pref = it9135_Pref_values[ch_modulation.constellation]
> +		    [ch_modulation.l_code_rate];
> +
> +	Prel = Prec - Pref;
> +
> +	if (Prel < -15)
> +		*strength = 0;
> +	else if ((-15 <= Prel) && (Prel < 0))
> +		*strength = (unsigned char)((2 * (Prel + 15)) / 3);
> +	else if ((0 <= Prel) && (Prel < 20))
> +		*strength = (unsigned char)(4 * Prel + 10);
> +	else if ((20 <= Prel) && (Prel < 35))
> +		*strength = ((unsigned char)(2 * (Prel - 20)) / 3 + 90);
> +	else if (Prel >= 35)
> +		*strength = 100;
> +
> +exit:
> +	return error;
> +}
> +
> +/* @param strength_dbm: DBm */
> +unsigned long it9135_get_strength_dbm(struct it9135_data *data,
> +				      unsigned char chip, long *strength_dbm)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +
> +	error =
> +	    it9135_read_reg(data, chip, PROCESSOR_OFDM, var_p_inband, &temp);
> +	if (error)
> +		goto exit;
> +
> +	*strength_dbm = (long)(temp - 100);
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_load_ir_tab(struct it9135_data *data,
> +				 unsigned short tab_len, unsigned char *table)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char base_high;
> +	unsigned char base_low;
> +	unsigned short reg_base;
> +	unsigned short i;
> +
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_LINK, ir_table_start_15_8,
> +			    &base_high);
> +	if (error)
> +		goto exit;
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_LINK, ir_table_start_7_0,
> +			    &base_low);
> +	if (error)
> +		goto exit;
> +
> +	reg_base = (unsigned short)(base_high << 8) + (unsigned short)base_low;
> +
> +	if (reg_base) {
> +		for (i = 0; i < tab_len; i++) {
> +			error =
> +			    it9135_write_reg(data, 0, PROCESSOR_LINK,
> +					     reg_base + i, table[i]);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +static struct it9135_freq_clk it9135_freq_clk_tab[2] = {
> +	{12000, 20250000},
> +	{20480, 20480000}
> +};
> +
> +unsigned long it9135_dev_init(struct it9135_data *data, unsigned char chip_num,
> +			      unsigned short saw_band, unsigned char streamType,
> +			      unsigned char architecture)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long crystal = 0;
> +	unsigned long adc = 0;
> +	unsigned long fcw = 0;
> +	unsigned char buffer[4];
> +	unsigned long version = 0;
> +	unsigned short *tuner_script_sets = NULL;
> +	struct it9135_val_set *tuner_scripts = NULL;
> +	unsigned char i;
> +	unsigned char var[2];
> +
> +#define IT9135_IF_FREQUENCY				0
> +#define IT9135_IF_INVERSION				0
> +/* Define I2C address of secondary chip when Diversity mode or PIP mode is active. */
> +#define IT9135_CHIP2_I2C_ADDR      0x3A
> +
> +	data->chip_num = chip_num;
> +	data->fcw = 0x00000000;
> +	data->frequency[0] = 642000;
> +	data->frequency[1] = 642000;
> +	data->inited = 0;
> +	data->host_if[0] = 0;
> +	data->cmd_seq = 0;
> +	data->pid_info.pid_init = 0;
> +
> +	error =
> +	    it9135_read_reg(data, 0, PROCESSOR_LINK, chip_version_7_0,
> +			    &data->chip_ver);
> +	if (error)
> +		goto exit;
> +	error =
> +	    it9135_read_regs(data, 0, PROCESSOR_LINK, chip_version_7_0 + 1, 2,
> +			     var);
> +	if (error)
> +		goto exit;
> +	data->chip_type = var[1] << 8 | var[0];
> +
> +	if (data->busId == 0xFFFF || data->tuner_desc.id == 0xFFFF)
> +		goto exit;
> +
> +	error = it9135_get_fw_ver(data, PROCESSOR_LINK, &version);
> +	if (error)
> +		goto exit;
> +	if (version != 0)
> +		data->booted = 1;
> +	else
> +		data->booted = 0;
> +
> +	/*if (data->chip_type == 0x9135 && data->chip_ver == 2) {
> +	   data->fw_codes = FirmwareV2_codes;
> +	   data->fw_segs = FirmwareV2_segments;
> +	   data->fw_parts = FirmwareV2_partitions;
> +	   data->script_sets = FirmwareV2_scriptSets;
> +	   data->scripts = FirmwareV2_scripts;
> +	   } else {
> +	   data->fw_codes = Firmware_codes;
> +	   data->fw_segs = Firmware_segments;
> +	   data->fw_parts = Firmware_partitions;
> +	   data->script_sets = Firmware_scriptSets;
> +	   data->scripts = Firmware_scripts;
> +	   } */

Better to put commented code like the above into:

#if 0
	dead_code();
#endif

Also, identation of the above is broken.

Btw, doesn't it needed to be uncommented? Maybe you should add there
something like:

#if 0
	/* FIXME: add support for version 2 of the chipset */
...
#endif

> +	tuner_script_sets = data->tuner_desc.script_sets;
> +	tuner_scripts = data->tuner_desc.scripts;
> +
> +	error =
> +	    it9135_read_reg_bits(data, 0, PROCESSOR_LINK,
> +				 r_io_mux_pwron_clk_strap,
> +				 io_mux_pwron_clk_strap_pos,
> +				 io_mux_pwron_clk_strap_len, &i);
> +	if (error)
> +		goto exit;
> +
> +	data->crystal_Freq = it9135_freq_clk_tab[0].crystal_Freq;
> +	data->adc_freq = it9135_freq_clk_tab[0].adc_freq;
> +
> +	/* Write secondary I2C address to device */
> +	/* Enable or disable clock for 2nd chip power saving */
> +	if (data->chip_num > 1) {
> +		error =
> +		    it9135_write_reg(data, 0, PROCESSOR_LINK,
> +				     second_i2c_address, IT9135_CHIP2_I2C_ADDR);
> +		if (error)
> +			goto exit;
> +
> +		error =
> +		    it9135_write_reg(data, 0, PROCESSOR_LINK, p_reg_top_clkoen,
> +				     1);
> +		if (error)
> +			goto exit;
> +
> +	} else {
> +		error =
> +		    it9135_write_reg(data, 0, PROCESSOR_LINK,
> +				     second_i2c_address, 0x00);
> +		if (error)
> +			goto exit;
> +
> +		error =
> +		    it9135_write_reg(data, 0, PROCESSOR_LINK, p_reg_top_clkoen,
> +				     0);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Load firmware */
> +	if (data->fw_codes != NULL) {
> +		if (!data->booted) {
> +			error =
> +			    it9135_load_firmware(data,
> +						 data->fw_codes, data->fw_segs,
> +						 &data->fw_parts);
> +			if (error)
> +				goto exit;
> +			data->booted = 1;
> +		}
> +	}
> +
> +	/* Set I2C master clock 100k in order to support tuner I2C. */
> +	error =
> +	    it9135_write_reg(data, 0, PROCESSOR_LINK,
> +			     p_reg_one_cycle_counter_tuner, 0x1a);
> +	if (error)
> +		goto exit;
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		error = it9135_write_reg(data, i, PROCESSOR_OFDM, 0xEC4C, 0x68);
> +		if (error)
> +			goto exit;
> +		mdelay(10);
> +	}
> +
> +	if (data->chip_type == 0x9135 && data->chip_ver == 1) {
> +		/* Open tuner */
> +		for (i = 0; i < data->chip_num; i++) {
> +
> +			/* Set 0xD827 to 0 as open drain for tuner i2c */
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_LINK,
> +					     p_reg_top_padodpu, 0);
> +			if (error)
> +				goto exit;
> +
> +			/* Set 0xD829 to 0 as push pull for tuner AGC */
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_LINK,
> +					     p_reg_top_agc_od, 0);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		for (i = 0; i < data->chip_num; i++) {
> +			error = it9135_tuner_init(data, i);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		/* Tell firmware the type of tuner. */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_link_ofsm_dummy_15_8,
> +				     (unsigned char)data->tuner_desc.id);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Initialize OFDM */
> +	if (data->booted) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			/* Set read-update bit to 1 for constellation */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_reg_feq_read_update,
> +						  reg_feq_read_update_pos,
> +						  reg_feq_read_update_len, 1);
> +			if (error)
> +				goto exit;
> +
> +			/* Enable FEC Monitor */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_fec_vtb_rsd_mon_en,
> +						  fec_vtb_rsd_mon_en_pos,
> +						  fec_vtb_rsd_mon_en_len, 1);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Compute ADC and load them to device */
> +		error =
> +		    it9135_compute_crystal(data,
> +					   (long)data->crystal_Freq * 1000,
> +					   &crystal);
> +		if (error)
> +			goto exit;
> +
> +		buffer[0] = (unsigned char)(crystal & 0x000000FF);
> +		buffer[1] = (unsigned char)((crystal & 0x0000FF00) >> 8);
> +		buffer[2] = (unsigned char)((crystal & 0x00FF0000) >> 16);
> +		buffer[3] = (unsigned char)((crystal & 0xFF000000) >> 24);
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_regs(data, i, PROCESSOR_OFDM,
> +					      crystal_clk_7_0, 4, buffer);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Compute ADC and load them to device */
> +		error = it9135_compute_adc(data, (long)data->adc_freq, &adc);
> +		if (error)
> +			goto exit;
> +
> +		buffer[0] = (unsigned char)(adc & 0x000000FF);
> +		buffer[1] = (unsigned char)((adc & 0x0000FF00) >> 8);
> +		buffer[2] = (unsigned char)((adc & 0x00FF0000) >> 16);
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_regs(data, i, PROCESSOR_OFDM,
> +					      p_reg_f_adc_7_0, 3, buffer);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Compute FCW and load them to device */
> +		error =
> +		    it9135_compute_fcw(data,
> +				       (long)data->adc_freq,
> +				       (long)IT9135_IF_FREQUENCY,
> +				       IT9135_IF_INVERSION, &fcw);
> +		if (error)
> +			goto exit;
> +		data->fcw = fcw;
> +
> +		buffer[0] = (unsigned char)(fcw & 0x000000FF);
> +		buffer[1] = (unsigned char)((fcw & 0x0000FF00) >> 8);
> +		buffer[2] = (unsigned char)((fcw & 0x007F0000) >> 16);
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_regs(data, i,
> +					      PROCESSOR_OFDM, bfs_fcw_7_0,
> +					      bfs_fcw_22_16 - bfs_fcw_7_0 + 1,
> +					      buffer);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	/* Load script */
> +	if (data->scripts != NULL) {
> +		error =
> +		    it9135_load_script(data, data->script_sets,
> +				       data->scripts, tuner_script_sets,
> +				       tuner_scripts);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	if ((data->chip_type == 0x9135 && data->chip_ver == 2)
> +	    || data->chip_type == 0x9175) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_OFDM,
> +					     trigger_ofsm, 0x01);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Open tuner */
> +		for (i = 0; i < data->chip_num; i++) {
> +
> +			/* Set 0xD827 to 0 as open drain for tuner i2c */
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_LINK,
> +					     p_reg_top_padodpu, 0);
> +			if (error)
> +				goto exit;
> +
> +			/* Set 0xD829 to 0 as push pull for tuner AGC */
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_LINK,
> +					     p_reg_top_agc_od, 0);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		for (i = 0; i < data->chip_num; i++) {
> +			error = it9135_tuner_init(data, i);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	/* Set the desired stream type */
> +	error = it9135_set_stream_type(data, streamType);
> +	if (error)
> +		goto exit;
> +
> +	/* Set the desired architecture type */
> +	error = it9135_set_arch(data, architecture);
> +	if (error)
> +		goto exit;
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		/* Set H/W MPEG2 locked detection */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_top_lock3_out, 1);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_top_padmiscdrsr, 1);
> +		if (error)
> +			goto exit;
> +		/* Set registers for driving power 0xD830 */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_top_padmiscdr2, 0);
> +		if (error)
> +			goto exit;
> +		/* enhance the performance while using DIP crystals */
> +		error = it9135_write_reg(data, i, PROCESSOR_OFDM, 0xEC57, 0);
> +		if (error)
> +			goto exit;
> +		error = it9135_write_reg(data, i, PROCESSOR_OFDM, 0xEC58, 0);
> +		if (error)
> +			goto exit;
> +		/* Set ADC frequency multiplier */
> +		error = it9135_set_multiplier(data, Multiplier_2X);
> +		if (error)
> +			goto exit;
> +		/* Set registers for driving power 0xD831 */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_top_padmiscdr4, 0);
> +		if (error)
> +			goto exit;
> +		/* Set registers for driving power 0xD832 */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_LINK,
> +				     p_reg_top_padmiscdr8, 0);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	data->inited = 1;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_tps_locked(struct it9135_data *data, unsigned char chip,
> +				int *locked)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +
> +	*locked = 0;
> +
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM, p_fd_tpsd_lock,
> +				 fd_tpsd_lock_pos, fd_tpsd_lock_len, &temp);
> +	if (error)
> +		goto exit;
> +	if (temp)
> +		*locked = 1;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_mp2_locked(struct it9135_data *data, unsigned char chip,
> +				int *locked)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +
> +	*locked = 0;
> +
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 r_mp2if_sync_byte_locked,
> +				 mp2if_sync_byte_locked_pos,
> +				 mp2if_sync_byte_locked_len, &temp);
> +	if (error)
> +		goto exit;
> +
> +	if (temp)
> +		*locked = 1;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_freq_locked(struct it9135_data *data, unsigned char chip,
> +				 int *locked)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short empty_loop = 0;
> +	unsigned short tps_loop = 0;
> +	unsigned short mpeg2_loop = 0;
> +	unsigned char channels[2];
> +	unsigned char begin;
> +	unsigned char end;
> +	unsigned char i;
> +	unsigned char empty_ch = 1;
> +	unsigned char tps_locked = 0;
> +	int retry = 1;
> +
> +check_lock:
> +	*locked = 0;
> +
> +	if (data->architecture == ARCHITECTURE_DCA) {
> +		begin = 0;
> +		end = data->chip_num;
> +	} else {
> +		begin = chip;
> +		end = begin + 1;
> +	}
> +
> +	for (i = begin; i < end; i++) {
> +		data->statistic[i].presented = 0;
> +		data->statistic[i].locked = 0;
> +		data->statistic[i].quality = 0;
> +		data->statistic[i].strength = 0;
> +	}
> +
> +	channels[0] = 2;
> +	channels[1] = 2;
> +	while (empty_loop < 40) {
> +		for (i = begin; i < end; i++) {
> +			error =
> +			    it9135_read_reg(data, i, PROCESSOR_OFDM,
> +					    empty_channel_status, &channels[i]);
> +			if (error)
> +				goto exit;
> +		}
> +		if ((channels[0] == 1) || (channels[1] == 1)) {
> +			empty_ch = 0;
> +			break;
> +		}
> +		if ((channels[0] == 2) && (channels[1] == 2)) {
> +			empty_ch = 1;
> +			goto exit;
> +		}
> +		mdelay(25);
> +		empty_loop++;
> +	}
> +
> +	if (empty_ch == 1)
> +		goto exit;
> +
> +	while (tps_loop < 50) {
> +		for (i = begin; i < end; i++) {
> +			/* TPS check */
> +			error =
> +			    it9135_tps_locked(data, i,
> +					      &data->statistic[i].presented);
> +			if (error)
> +				goto exit;
> +			if (data->statistic[i].presented) {
> +				tps_locked = 1;
> +				break;
> +			}
> +		}
> +
> +		if (tps_locked == 1)
> +			break;
> +
> +		mdelay(25);
> +		tps_loop++;
> +	}
> +
> +	if (tps_locked == 0)
> +		goto exit;
> +
> +	while (mpeg2_loop < 40) {
> +		if (data->architecture == ARCHITECTURE_DCA) {
> +			error =
> +			    it9135_mp2_locked(data, 0,
> +					      &data->statistic[0].locked);
> +			if (error)
> +				goto exit;
> +			if (data->statistic[0].locked) {
> +				for (i = begin; i < end; i++) {
> +					data->statistic[i].quality = 80;
> +					data->statistic[i].strength = 80;
> +				}
> +				*locked = 1;
> +				break;
> +			}
> +		} else {
> +			error =
> +			    it9135_mp2_locked(data, chip,
> +					      &data->statistic[chip].locked);
> +			if (error)
> +				goto exit;
> +			if (data->statistic[chip].locked) {
> +				data->statistic[chip].quality = 80;
> +				data->statistic[chip].strength = 80;
> +				*locked = 1;
> +				break;
> +			}
> +		}
> +		mdelay(25);
> +		mpeg2_loop++;
> +	}
> +	for (i = begin; i < end; i++) {
> +		data->statistic[i].quality = 0;
> +		data->statistic[i].strength = 20;
> +	}
> +
> +exit:
> +	if (*locked == 0 && retry == 1) {
> +		retry = 0;
> +		mpeg2_loop = 0;
> +		tps_loop = 0;
> +		empty_loop = 0;
> +		empty_ch = 1;
> +		tps_locked = 0;
> +		/* Clear empty_channel_status lock flag */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM,
> +				     empty_channel_status, 0x00);
> +		if (error)
> +			goto exit;
> +
> +		/* Trigger ofsm */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, trigger_ofsm,
> +				     0);
> +		if (error)
> +			goto exit;
> +
> +		goto check_lock;
> +	}
> +
> +	return error;
> +}
> +
> +unsigned long it9135_get_ch_modulation(struct it9135_data *data,
> +				       unsigned char chip,
> +				       struct it9135_ch_modulation
> +				       *ch_modulation)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +
> +	/* Get constellation type */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 g_reg_tpsd_const, reg_tpsd_const_pos,
> +				 reg_tpsd_const_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->constellation = temp;
> +
> +	/* Get TPS hierachy and alpha value */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 g_reg_tpsd_hier, reg_tpsd_hier_pos,
> +				 reg_tpsd_hier_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->hierarchy = temp;
> +
> +	/* Get high/low priority */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM, g_reg_dec_pri,
> +				 reg_dec_pri_pos, reg_dec_pri_len, &temp);
> +	if (error)
> +		goto exit;
> +	if (temp)
> +		ch_modulation->priority = PRIORITY_HIGH;
> +	else
> +		ch_modulation->priority = PRIORITY_LOW;
> +
> +	/* Get high code rate */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 g_reg_tpsd_hpcr, reg_tpsd_hpcr_pos,
> +				 reg_tpsd_hpcr_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->h_code_rate = temp;
> +
> +	/* Get low code rate */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 g_reg_tpsd_lpcr, reg_tpsd_lpcr_pos,
> +				 reg_tpsd_lpcr_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->l_code_rate = temp;
> +
> +	/* Get guard interval */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM, g_reg_tpsd_gi,
> +				 reg_tpsd_gi_pos, reg_tpsd_gi_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->interval = temp;
> +
> +	/* Get FFT mode */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM,
> +				 g_reg_tpsd_txmod, reg_tpsd_txmod_pos,
> +				 reg_tpsd_txmod_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->trans_mode = temp;
> +
> +	/* Get bandwidth */
> +	error =
> +	    it9135_read_reg_bits(data, chip, PROCESSOR_OFDM, g_reg_bw,
> +				 reg_bw_pos, reg_bw_len, &temp);
> +	if (error)
> +		goto exit;
> +	ch_modulation->bandwidth = temp;
> +
> +	/* Get frequency */
> +	ch_modulation->frequency = data->frequency[chip];
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_acquire_ch(struct it9135_data *data, unsigned char chip,
> +				unsigned short bandwidth,
> +				unsigned long frequency)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char begin;
> +	unsigned char end;
> +	unsigned char i;
> +
> +	if (data->architecture == ARCHITECTURE_DCA) {
> +		begin = 0;
> +		end = data->chip_num;
> +	} else {
> +		begin = chip;
> +		end = begin + 1;
> +	}
> +
> +	for (i = begin; i < end; i++) {
> +		error =
> +		    it9135_select_bandwidth(data, i, bandwidth, data->adc_freq);
> +		if (error)
> +			goto exit;
> +		data->bandwidth[i] = bandwidth;
> +	}
> +
> +	error = it9135_mask_dca_output(data);
> +	if (error)
> +		goto exit;
> +
> +	/* Set frequency */
> +	for (i = begin; i < end; i++) {
> +		error = it9135_set_frequency(data, i, frequency);
> +		if (error)
> +			goto exit;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_set_stream_type(struct it9135_data *data,
> +				     unsigned char streamType)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char i;
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		error =
> +		    it9135_write_reg_bits(data, i, PROCESSOR_OFDM,
> +					  p_reg_mpeg_full_speed,
> +					  reg_mpeg_full_speed_pos,
> +					  reg_mpeg_full_speed_len, 0);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Enable DVB-T mode */
> +	for (i = 0; i < data->chip_num; i++) {
> +		error =
> +		    it9135_write_reg_bits(data, i, PROCESSOR_LINK,
> +					  p_reg_dvbt_en, reg_dvbt_en_pos,
> +					  reg_dvbt_en_len, 1);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Pictor & Orion & Omega & Omega_LNA */
> +	if (data->tuner_desc.id == 0x35
> +	    || data->tuner_desc.id == 0x39
> +	    || data->tuner_desc.id == 0x3A || data->chip_type == 0x9135
> +	    || data->chip_type == 0x9175) {
> +		/* Enter sub mode */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_mp2if_mpeg_ser_mode,
> +					  mp2if_mpeg_ser_mode_pos,
> +					  mp2if_mpeg_ser_mode_len, 0);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_mp2if_mpeg_par_mode,
> +					  mp2if_mpeg_par_mode_pos,
> +					  mp2if_mpeg_par_mode_len, 0);
> +		if (error)
> +			goto exit;
> +		/* Fix current leakage */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_LINK,
> +					  p_reg_top_hostb_mpeg_ser_mode,
> +					  reg_top_hostb_mpeg_ser_mode_pos,
> +					  reg_top_hostb_mpeg_ser_mode_len, 0);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_LINK,
> +					  p_reg_top_hostb_mpeg_par_mode,
> +					  reg_top_hostb_mpeg_par_mode_pos,
> +					  reg_top_hostb_mpeg_par_mode_len, 0);
> +		if (error)
> +			goto exit;
> +	} else {
> +		/* Enter sub mode */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_mp2if_mpeg_ser_mode,
> +					  mp2if_mpeg_ser_mode_pos,
> +					  mp2if_mpeg_ser_mode_len, 0);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_mp2if_mpeg_par_mode,
> +					  mp2if_mpeg_par_mode_pos,
> +					  mp2if_mpeg_par_mode_len, 0);
> +		if (error)
> +			goto exit;
> +		/* Fix current leakage */
> +		if (data->chip_num > 1) {
> +			if (data->host_if[0]) {
> +				error =
> +				    it9135_write_reg_bits(data, 0,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hostb_mpeg_ser_mode,
> +							  reg_top_hostb_mpeg_ser_mode_pos,
> +							  reg_top_hostb_mpeg_ser_mode_len,
> +							  0);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits(data, 0,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hostb_mpeg_par_mode,
> +							  reg_top_hostb_mpeg_par_mode_pos,
> +							  reg_top_hostb_mpeg_par_mode_len,
> +							  1);
> +				if (error)
> +					goto exit;
> +			} else {
> +				error =
> +				    it9135_write_reg_bits(data, 0,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hosta_mpeg_ser_mode,
> +							  reg_top_hosta_mpeg_ser_mode_pos,
> +							  reg_top_hosta_mpeg_ser_mode_len,
> +							  0);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits(data, 0,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hosta_mpeg_par_mode,
> +							  reg_top_hosta_mpeg_par_mode_pos,
> +							  reg_top_hosta_mpeg_par_mode_len,
> +							  1);
> +				if (error)
> +					goto exit;
> +			}
> +		} else {
> +			error =
> +			    it9135_write_reg_bits(data, 0,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hosta_mpeg_ser_mode,
> +						  reg_top_hosta_mpeg_ser_mode_pos,
> +						  reg_top_hosta_mpeg_ser_mode_len,
> +						  0);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, 0,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hosta_mpeg_par_mode,
> +						  reg_top_hosta_mpeg_par_mode_pos,
> +						  reg_top_hosta_mpeg_par_mode_len,
> +						  1);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, 0,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_mpeg_ser_mode,
> +						  reg_top_hostb_mpeg_ser_mode_pos,
> +						  reg_top_hostb_mpeg_ser_mode_len,
> +						  0);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, 0,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_mpeg_par_mode,
> +						  reg_top_hostb_mpeg_par_mode_pos,
> +						  reg_top_hostb_mpeg_par_mode_len,
> +						  1);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_set_arch(struct it9135_data *data,
> +			      unsigned char architecture)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned short frame_sz;
> +	unsigned char packet_sz;
> +	unsigned char buffer[2];
> +	unsigned char standalone[2];
> +	unsigned char upper_chip[2];
> +	unsigned char upper_host[2];
> +	unsigned char lower_chip[2];
> +	unsigned char lower_host[2];
> +	unsigned char dca_en[2];
> +	unsigned char phase_latch[2];
> +	unsigned char fpga_latch[2];
> +	unsigned char i;
> +	int pip_valid = 0;
> +
> +/* Define USB frame size */
> +#define IT9135_USB20_MAX_PACKET_SIZE      512
> +#ifdef DVB_USB_ADAP_NEED_PID_FILTER
> +#define IT9135_USB20_FRAME_SIZE           (188 * 21)
> +#else
> +#define IT9135_USB20_FRAME_SIZE           (188 * 348)
> +#endif
> +#define IT9135_USB20_FRAME_SIZE_DW        (IT9135_USB20_FRAME_SIZE / 4)
> +#define IT9135_USB11_MAX_PACKET_SIZE      64
> +#define IT9135_USB11_FRAME_SIZE           (188 * 21)
> +#define IT9135_USB11_FRAME_SIZE_DW        (IT9135_USB11_FRAME_SIZE / 4)
> +
> +	if (architecture == ARCHITECTURE_DCA) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			standalone[i] = 0;
> +			upper_chip[i] = 0;
> +			upper_host[i] = 0;
> +			lower_chip[i] = 0;
> +			lower_host[i] = 0;
> +			dca_en[i] = 1;
> +			phase_latch[i] = 0;
> +			fpga_latch[i] = 0;
> +		}
> +
> +		if (data->chip_num == 1) {
> +			standalone[0] = 1;
> +			dca_en[0] = 0;
> +		} else {
> +			/* Pictor & Orion & Omega */
> +			if (data->tuner_desc.id == 0x35
> +			    || data->tuner_desc.id == 0x39
> +			    || data->tuner_desc.id == 0x3A) {
> +				upper_chip[data->chip_num - 1] = 1;
> +				upper_host[0] = 1;
> +				lower_chip[0] = 1;
> +				lower_host[data->chip_num - 1] = 1;
> +				phase_latch[0] = 0;
> +				phase_latch[data->chip_num - 1] = 0;
> +				fpga_latch[0] = 0;
> +				fpga_latch[data->chip_num - 1] = 0;
> +			} else if (data->chip_type == 0x9135
> +				   || data->chip_type == 0x9175) {
> +				upper_chip[data->chip_num - 1] = 1;
> +				upper_host[0] = 1;
> +
> +				lower_chip[0] = 1;
> +				lower_host[data->chip_num - 1] = 1;
> +
> +				phase_latch[0] = 1;
> +				phase_latch[data->chip_num - 1] = 1;
> +
> +				fpga_latch[0] = 0x44;
> +				fpga_latch[data->chip_num - 1] = 0x44;
> +			} else {
> +				upper_chip[data->chip_num - 1] = 1;
> +				upper_host[0] = 1;
> +				lower_chip[0] = 1;
> +				lower_host[data->chip_num - 1] = 1;
> +				phase_latch[0] = 1;
> +				phase_latch[data->chip_num - 1] = 1;
> +				fpga_latch[0] = 0x77;
> +				fpga_latch[data->chip_num - 1] = 0x77;
> +			}
> +		}
> +	} else {
> +		for (i = 0; i < data->chip_num; i++) {
> +			standalone[i] = 1;
> +			upper_chip[i] = 0;
> +			upper_host[i] = 0;
> +			lower_chip[i] = 0;
> +			lower_host[i] = 0;
> +			dca_en[i] = 0;
> +			phase_latch[i] = 0;
> +			fpga_latch[i] = 0;
> +		}
> +	}
> +
> +	if (data->inited) {
> +		error = it9135_mask_dca_output(data);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Pictor & Orion & Omega & Omega_LNA */
> +	if (data->tuner_desc.id == 0x35
> +	    || data->tuner_desc.id == 0x39
> +	    || data->tuner_desc.id == 0x3A || data->chip_type == 0x9135
> +	    || data->chip_type == 0x9175) {
> +		for (i = data->chip_num; i > 0; i--) {
> +			/* Set dca_upper_chip */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_upper_chip,
> +						  reg_dca_upper_chip_pos,
> +						  reg_dca_upper_chip_len,
> +						  upper_chip[i - 1]);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_dca_upper,
> +						  reg_top_hostb_dca_upper_pos,
> +						  reg_top_hostb_dca_upper_len,
> +						  upper_host[i - 1]);
> +			if (error)
> +				goto exit;
> +
> +			/* Set dca_lower_chip */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_lower_chip,
> +						  reg_dca_lower_chip_pos,
> +						  reg_dca_lower_chip_len,
> +						  lower_chip[i - 1]);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_dca_lower,
> +						  reg_top_hostb_dca_lower_pos,
> +						  reg_top_hostb_dca_lower_len,
> +						  lower_host[i - 1]);
> +			if (error)
> +				goto exit;
> +
> +			/* Set phase latch */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_platch,
> +						  reg_dca_platch_pos,
> +						  reg_dca_platch_len,
> +						  phase_latch[i - 1]);
> +			if (error)
> +				goto exit;
> +
> +			/* Set fpga latch */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1, PROCESSOR_OFDM,
> +						  p_reg_dca_fpga_latch,
> +						  reg_dca_fpga_latch_pos,
> +						  reg_dca_fpga_latch_len,
> +						  fpga_latch[i - 1]);
> +			if (error)
> +				goto exit;
> +		}
> +	} else {
> +		/* Set upper chip first in order to avoid I/O conflict */
> +		for (i = data->chip_num; i > 0; i--) {
> +			/* Set dca_upper_chip */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_upper_chip,
> +						  reg_dca_upper_chip_pos,
> +						  reg_dca_upper_chip_len,
> +						  upper_chip[i - 1]);
> +			if (error)
> +				goto exit;
> +			if (i == 1) {
> +				if (data->host_if[0]) {
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hosta_dca_upper,
> +					     reg_top_hosta_dca_upper_pos,
> +					     reg_top_hosta_dca_upper_len,
> +					     upper_host[i - 1]);
> +					if (error)
> +						goto exit;
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hostb_dca_upper,
> +					     reg_top_hostb_dca_upper_pos,
> +					     reg_top_hostb_dca_upper_len, 0);
> +					if (error)
> +						goto exit;
> +				} else {
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hostb_dca_upper,
> +					     reg_top_hostb_dca_upper_pos,
> +					     reg_top_hostb_dca_upper_len,
> +					     upper_host[i - 1]);
> +					if (error)
> +						goto exit;
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hosta_dca_upper,
> +					     reg_top_hosta_dca_upper_pos,
> +					     reg_top_hosta_dca_upper_len, 0);
> +					if (error)
> +						goto exit;
> +				}
> +			} else {
> +				error =
> +				    it9135_write_reg_bits(data,
> +							  i - 1,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hostb_dca_upper,
> +							  reg_top_hostb_dca_upper_pos,
> +							  reg_top_hostb_dca_upper_len,
> +							  upper_host[i - 1]);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits(data,
> +							  i - 1,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hosta_dca_upper,
> +							  reg_top_hosta_dca_upper_pos,
> +							  reg_top_hosta_dca_upper_len,
> +							  0);
> +				if (error)
> +					goto exit;
> +			}
> +
> +			/* Set dca_lower_chip */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_lower_chip,
> +						  reg_dca_lower_chip_pos,
> +						  reg_dca_lower_chip_len,
> +						  lower_chip[i - 1]);
> +			if (error)
> +				goto exit;
> +			if (i == 1) {
> +				if (data->host_if[0]) {
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hosta_dca_lower,
> +					     reg_top_hosta_dca_lower_pos,
> +					     reg_top_hosta_dca_lower_len,
> +					     lower_host[i - 1]);
> +					if (error)
> +						goto exit;
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hostb_dca_lower,
> +					     reg_top_hostb_dca_lower_pos,
> +					     reg_top_hostb_dca_lower_len, 0);
> +					if (error)
> +						goto exit;
> +				} else {
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hostb_dca_lower,
> +					     reg_top_hostb_dca_lower_pos,
> +					     reg_top_hostb_dca_lower_len,
> +					     lower_host[i - 1]);
> +					if (error)
> +						goto exit;
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, i - 1, PROCESSOR_LINK,
> +					     p_reg_top_hosta_dca_lower,
> +					     reg_top_hosta_dca_lower_pos,
> +					     reg_top_hosta_dca_lower_len, 0);
> +					if (error)
> +						goto exit;
> +				}
> +			} else {
> +				error =
> +				    it9135_write_reg_bits(data,
> +							  i - 1,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hostb_dca_lower,
> +							  reg_top_hostb_dca_lower_pos,
> +							  reg_top_hostb_dca_lower_len,
> +							  lower_host[i - 1]);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits(data,
> +							  i - 1,
> +							  PROCESSOR_LINK,
> +							  p_reg_top_hosta_dca_lower,
> +							  reg_top_hosta_dca_lower_pos,
> +							  reg_top_hosta_dca_lower_len,
> +							  0);
> +				if (error)
> +					goto exit;
> +			}
> +
> +			/* Set phase latch */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_platch,
> +						  reg_dca_platch_pos,
> +						  reg_dca_platch_len,
> +						  phase_latch[i - 1]);
> +			if (error)
> +				goto exit;
> +
> +			/* Set fpga latch */
> +			error =
> +			    it9135_write_reg_bits(data, i - 1,
> +						  PROCESSOR_OFDM,
> +						  p_reg_dca_fpga_latch,
> +						  reg_dca_fpga_latch_pos,
> +						  reg_dca_fpga_latch_len,
> +						  fpga_latch[i - 1]);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		/* Set stand alone */
> +		error =
> +		    it9135_write_reg_bits(data, i, PROCESSOR_OFDM,
> +					  p_reg_dca_stand_alone,
> +					  reg_dca_stand_alone_pos,
> +					  reg_dca_stand_alone_len,
> +					  standalone[i]);
> +		if (error)
> +			goto exit;
> +
> +		/* Set DCA enable */
> +		error =
> +		    it9135_write_reg_bits(data, i, PROCESSOR_OFDM,
> +					  p_reg_dca_en, reg_dca_en_pos,
> +					  reg_dca_en_len, dca_en[i]);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	if (data->inited) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_reg(data, i, PROCESSOR_OFDM,
> +					     trigger_ofsm, 0);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	frame_sz = IT9135_USB20_FRAME_SIZE_DW;
> +	packet_sz = (unsigned char)(IT9135_USB20_MAX_PACKET_SIZE / 4);
> +
> +	if (data->busId == IT9135_BUS_USB11) {
> +		frame_sz = IT9135_USB11_FRAME_SIZE_DW;
> +		packet_sz = (unsigned char)(IT9135_USB11_MAX_PACKET_SIZE / 4);
> +	}
> +
> +	if ((data->chip_num > 1) && (architecture == ARCHITECTURE_PIP))
> +		pip_valid = 1;
> +
> +	/* Reset EP4 */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM, p_reg_mp2_sw_rst,
> +				  reg_mp2_sw_rst_pos, reg_mp2_sw_rst_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	/* Reset EP5 */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +				  p_reg_mp2if2_sw_rst, reg_mp2if2_sw_rst_pos,
> +				  reg_mp2if2_sw_rst_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	/* Disable EP4 */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_LINK, p_reg_ep4_tx_en,
> +				  reg_ep4_tx_en_pos, reg_ep4_tx_en_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	/* Disable EP5 */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_LINK, p_reg_ep5_tx_en,
> +				  reg_ep5_tx_en_pos, reg_ep5_tx_en_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	/* Disable EP4 NAK */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_LINK, p_reg_ep4_tx_nak,
> +				  reg_ep4_tx_nak_pos, reg_ep4_tx_nak_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	/* Disable EP5 NAK */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_LINK, p_reg_ep5_tx_nak,
> +				  reg_ep5_tx_nak_pos, reg_ep5_tx_nak_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	/* Enable EP4 */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_LINK, p_reg_ep4_tx_en,
> +				  reg_ep4_tx_en_pos, reg_ep4_tx_en_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	/* Set EP4 transfer length */
> +	buffer[p_reg_ep4_tx_len_7_0 - p_reg_ep4_tx_len_7_0] =
> +	    (unsigned char)frame_sz;
> +	buffer[p_reg_ep4_tx_len_15_8 - p_reg_ep4_tx_len_7_0] =
> +	    (unsigned char)(frame_sz >> 8);
> +	error =
> +	    it9135_write_regs(data, 0, PROCESSOR_LINK, p_reg_ep4_tx_len_7_0, 2,
> +			      buffer);
> +
> +	/* Set EP4 packet size */
> +	error =
> +	    it9135_write_reg(data, 0, PROCESSOR_LINK, p_reg_ep4_max_pkt,
> +			     packet_sz);
> +	if (error)
> +		goto exit;
> +
> +	if (pip_valid) {
> +		/* Enable EP5 */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_LINK,
> +					  p_reg_ep5_tx_en, reg_ep5_tx_en_pos,
> +					  reg_ep5_tx_en_len, 1);
> +		if (error)
> +			goto exit;
> +
> +		/* Set EP5 transfer length */
> +		buffer[p_reg_ep5_tx_len_7_0 - p_reg_ep5_tx_len_7_0] =
> +		    (unsigned char)frame_sz;
> +		buffer[p_reg_ep5_tx_len_15_8 - p_reg_ep5_tx_len_7_0] =
> +		    (unsigned char)(frame_sz >> 8);
> +		error =
> +		    it9135_write_regs(data, 0, PROCESSOR_LINK,
> +				      p_reg_ep5_tx_len_7_0, 2, buffer);
> +
> +		/* Set EP5 packet size */
> +		error =
> +		    it9135_write_reg(data, 0, PROCESSOR_LINK, p_reg_ep5_max_pkt,
> +				     packet_sz);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Disable 15 SER/PAR mode */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +				  p_mp2if_mpeg_ser_mode,
> +				  mp2if_mpeg_ser_mode_pos,
> +				  mp2if_mpeg_ser_mode_len, 0);
> +	if (error)
> +		goto exit;
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +				  p_mp2if_mpeg_par_mode,
> +				  mp2if_mpeg_par_mode_pos,
> +				  mp2if_mpeg_par_mode_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	if (pip_valid) {
> +		/* Enable mp2if2 */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_mp2if2_en, reg_mp2if2_en_pos,
> +					  reg_mp2if2_en_len, 1);
> +		if (error)
> +			goto exit;
> +
> +		for (i = 1; i < data->chip_num; i++) {
> +			/* Enable serial mode */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_mp2if_mpeg_ser_mode,
> +						  mp2if_mpeg_ser_mode_pos,
> +						  mp2if_mpeg_ser_mode_len, 1);
> +			if (error)
> +				goto exit;
> +
> +			/* Enable HostB serial */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_mpeg_ser_mode,
> +						  reg_top_hostb_mpeg_ser_mode_pos,
> +						  reg_top_hostb_mpeg_ser_mode_len,
> +						  1);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Enable tsis */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_tsis_en, reg_tsis_en_pos,
> +					  reg_tsis_en_len, 1);
> +		if (error)
> +			goto exit;
> +	} else {
> +		/* Disable mp2if2 */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_mp2if2_en, reg_mp2if2_en_pos,
> +					  reg_mp2if2_en_len, 0);
> +		if (error)
> +			goto exit;
> +
> +		for (i = 1; i < data->chip_num; i++) {
> +			/* Disable serial mode */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_mp2if_mpeg_ser_mode,
> +						  mp2if_mpeg_ser_mode_pos,
> +						  mp2if_mpeg_ser_mode_len, 0);
> +			if (error)
> +				goto exit;
> +
> +			/* Disable HostB serial */
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_LINK,
> +						  p_reg_top_hostb_mpeg_ser_mode,
> +						  reg_top_hostb_mpeg_ser_mode_pos,
> +						  reg_top_hostb_mpeg_ser_mode_len,
> +						  0);
> +			if (error)
> +				goto exit;
> +		}
> +
> +		/* Disable tsis */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_tsis_en, reg_tsis_en_pos,
> +					  reg_tsis_en_len, 0);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Negate EP4 reset */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM, p_reg_mp2_sw_rst,
> +				  reg_mp2_sw_rst_pos, reg_mp2_sw_rst_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	/* Negate EP5 reset */
> +	error =
> +	    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +				  p_reg_mp2if2_sw_rst, reg_mp2if2_sw_rst_pos,
> +				  reg_mp2if2_sw_rst_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	if (pip_valid) {
> +		/* Split 15 PSB to 1K + 1K and enable flow control */
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_mp2if2_half_psb,
> +					  reg_mp2if2_half_psb_pos,
> +					  reg_mp2if2_half_psb_len, 0);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg_bits(data, 0, PROCESSOR_OFDM,
> +					  p_reg_mp2if_stop_en,
> +					  reg_mp2if_stop_en_pos,
> +					  reg_mp2if_stop_en_len, 1);
> +		if (error)
> +			goto exit;
> +
> +		for (i = 1; i < data->chip_num; i++) {
> +			error =
> +			    it9135_write_reg_bits(data, i, PROCESSOR_OFDM,
> +						  p_reg_mpeg_full_speed,
> +						  reg_mpeg_full_speed_pos,
> +						  reg_mpeg_full_speed_len, 1);
> +			if (error)
> +				goto exit;
> +			error =
> +			    it9135_write_reg_bits(data, i,
> +						  PROCESSOR_OFDM,
> +						  p_reg_mp2if_stop_en,
> +						  reg_mp2if_stop_en_pos,
> +						  reg_mp2if_stop_en_len, 0);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	data->architecture = architecture;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_get_statistic(struct it9135_data *data, unsigned char chip,
> +				   struct it9135_statistic *statistic)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char quality = 0;
> +	unsigned char strength;
> +	unsigned char buffer[2];
> +
> +	/* Get statistic by stream type */
> +	error =
> +	    it9135_read_regs(data, chip, PROCESSOR_OFDM, tpsd_lock,
> +			     mpeg_lock - tpsd_lock + 1, buffer);
> +	if (error)
> +		goto exit;
> +
> +	if (buffer[tpsd_lock - tpsd_lock])
> +		data->statistic[chip].presented = 1;
> +	else
> +		data->statistic[chip].presented = 0;
> +
> +	if (buffer[mpeg_lock - tpsd_lock])
> +		data->statistic[chip].locked = 1;
> +	else
> +		data->statistic[chip].locked = 0;
> +
> +	error = it9135_get_signal_quality(data, chip, &quality);
> +	if (error)
> +		goto exit;
> +
> +	data->statistic[chip].quality = quality;
> +	error = it9135_get_strength(data, chip, &strength);
> +	if (error)
> +		goto exit;
> +
> +	data->statistic[chip].strength = strength;
> +
> +	*statistic = data->statistic[chip];
> +
> +exit:
> +	return error;
> +}
> +
> +/* get ir raw code (4 unsigned chars) */
> +unsigned long it9135_get_ir_code(struct it9135_data *data, unsigned long *code)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char r_buff[4];
> +
> +	error =
> +	    it9135_cmd_sendcommand(data, CMD_IR_GET, 0, PROCESSOR_LINK, 0, NULL,
> +				   4, r_buff);
> +	if (error)
> +		goto exit;
> +
> +	*code =
> +	    (unsigned long)((r_buff[0] << 24) + (r_buff[1] << 16) +
> +			    (r_buff[2] << 8) + r_buff[3]);
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_dev_reboot(struct it9135_data *data)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long version;
> +	unsigned char i;
> +
> +	error = it9135_get_fw_ver(data, PROCESSOR_LINK, &version);
> +	if (error)
> +		goto exit;
> +	if (version == 0xFFFFFFFF)
> +		goto exit;	/* I2M and I2U */
> +	if (version != 0) {
> +		for (i = data->chip_num; i > 0; i--) {
> +			error = it9135_cmd_reboot(data, i - 1);
> +			mdelay(1);
> +			if (error)
> +				goto exit;
> +		}
> +	}
> +
> +	data->booted = 0;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_ctrl_pw_saving(struct it9135_data *data,
> +				    unsigned char chip, unsigned char control)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char temp;
> +	unsigned char j;
> +
> +	if (control) {
> +		/* Power up case */
> +		error =
> +		    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +					  p_reg_afe_mem0, 3, 1, 0);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_dyn0_clk,
> +				     0);
> +		if (error)
> +			goto exit;
> +
> +		/* Fixed current leakage */
> +		if ((data->chip_num > 1) && (chip > 0)) {
> +			/* Pictor & Orion & Omega & Omega_LNA */
> +			if (data->tuner_desc.id == 0x35
> +			    || data->tuner_desc.id == 0x39) {
> +				/* Disable HostB parallel */
> +				error =
> +				    it9135_write_reg_bits
> +				    (data, chip, PROCESSOR_LINK,
> +				     p_reg_top_hostb_mpeg_ser_mode,
> +				     reg_top_hostb_mpeg_ser_mode_pos,
> +				     reg_top_hostb_mpeg_ser_mode_len, 0);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits
> +				    (data, chip, PROCESSOR_LINK,
> +				     p_reg_top_hostb_mpeg_par_mode,
> +				     reg_top_hostb_mpeg_par_mode_pos,
> +				     reg_top_hostb_mpeg_par_mode_len, 0);
> +				if (error)
> +					goto exit;
> +			} else if (data->chip_type == 0x9135
> +				   || data->chip_type == 0x9175) {
> +				/* Enable HostB serial */
> +				if ((data->architecture == ARCHITECTURE_PIP))
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, chip,
> +					     PROCESSOR_LINK,
> +					     p_reg_top_hostb_mpeg_ser_mode,
> +					     reg_top_hostb_mpeg_ser_mode_pos,
> +					     reg_top_hostb_mpeg_ser_mode_len,
> +					     1);
> +				else
> +					error =
> +					    it9135_write_reg_bits
> +					    (data, chip,
> +					     PROCESSOR_LINK,
> +					     p_reg_top_hostb_mpeg_ser_mode,
> +					     reg_top_hostb_mpeg_ser_mode_pos,
> +					     reg_top_hostb_mpeg_ser_mode_len,
> +					     0);
> +				if (error)
> +					goto exit;
> +				/* Disable HostB parallel */
> +				error =
> +				    it9135_write_reg_bits
> +				    (data, chip, PROCESSOR_LINK,
> +				     p_reg_top_hostb_mpeg_par_mode,
> +				     reg_top_hostb_mpeg_par_mode_pos,
> +				     reg_top_hostb_mpeg_par_mode_len, 0);
> +				if (error)
> +					goto exit;
> +			}
> +		}
> +	} else {
> +		/* Power down case */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, suspend_flag,
> +				     1);
> +		if (error)
> +			goto exit;
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, trigger_ofsm,
> +				     0);
> +		if (error)
> +			goto exit;
> +
> +		for (j = 0; j < 150; j++) {
> +			error =
> +			    it9135_read_reg(data, chip, PROCESSOR_OFDM,
> +					    suspend_flag, &temp);
> +			if (error)
> +				goto exit;
> +			if (!temp)
> +				break;
> +			mdelay(10);
> +		}
> +		/* power down demod adc */
> +		error =
> +		    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +					  p_reg_afe_mem0, 3, 1, 1);
> +		if (error)
> +			goto exit;
> +
> +		/* Fixed current leakage */
> +		if ((data->chip_num > 1) && (chip > 0)) {
> +			/* Pictor & Orion & Omega */
> +			if (data->tuner_desc.id ==
> +			    0x35
> +			    || data->tuner_desc.id ==
> +			    0x39 || data->chip_type == 0x9135
> +			    || data->chip_type == 0x9175) {
> +				/* Enable HostB parallel */
> +				error =
> +				    it9135_write_reg_bits
> +				    (data, chip, PROCESSOR_LINK,
> +				     p_reg_top_hostb_mpeg_ser_mode,
> +				     reg_top_hostb_mpeg_ser_mode_pos,
> +				     reg_top_hostb_mpeg_ser_mode_len, 0);
> +				if (error)
> +					goto exit;
> +				error =
> +				    it9135_write_reg_bits
> +				    (data, chip, PROCESSOR_LINK,
> +				     p_reg_top_hostb_mpeg_par_mode,
> +				     reg_top_hostb_mpeg_par_mode_pos,
> +				     reg_top_hostb_mpeg_par_mode_len, 1);
> +				if (error)
> +					goto exit;
> +			}
> +		}
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_ctrl_tuner_leakage(struct it9135_data *data,
> +					unsigned char chip,
> +					unsigned char control)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char value[15] = { 0 };
> +
> +	if (control) {
> +		/* Power up case */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_p_if_en,
> +				     1);
> +		if (error)
> +			goto exit;
> +	} else {
> +		/* Fixed tuner current leakage */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_dyn0_clk,
> +				     0);
> +		if (error)
> +			goto exit;
> +		/* 0xec40 */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_p_if_en,
> +				     0);
> +		if (error)
> +			goto exit;
> +
> +		value[1] = 0x0c;
> +
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_pd_a,
> +				      15, value);
> +		if (error)
> +			goto exit;
> +
> +		value[1] = 0;
> +
> +		/* 0xec12~0xec15 */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_lna_g,
> +				      4, value);
> +		if (error)
> +			goto exit;
> +		/* oxec17~0xec1f */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_pgc, 9,
> +				      value);
> +		if (error)
> +			goto exit;
> +		/* 0xec22~0xec2b */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM,
> +				      p_reg_clk_del_sel, 10, value);
> +		if (error)
> +			goto exit;
> +		/* 0xec20 */
> +		error = it9135_write_reg(data, chip, PROCESSOR_OFDM, 0xec20, 0);
> +		if (error)
> +			goto exit;
> +		/* 0xec3f */
> +		error = it9135_write_reg(data, chip, PROCESSOR_OFDM, 0xec3F, 1);
> +		if (error)
> +			goto exit;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_ctrl_tuner_pw_saving(struct it9135_data *data,
> +					  unsigned char chip,
> +					  unsigned char control)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char value[15] = { 0 };
> +
> +	if (control) {
> +		/* Power up case */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_p_if_en,
> +				     1);
> +		if (error)
> +			goto exit;
> +	} else {
> +		/* tuner power down */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_dyn0_clk,
> +				     0);
> +		if (error)
> +			goto exit;
> +		/* 0xec40 */
> +		error =
> +		    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_reg_p_if_en,
> +				     0);
> +		if (error)
> +			goto exit;
> +
> +		value[0] = 0x3F;	/* 0xec02 */
> +		value[1] = 0x1F;	/* 0xec03 */
> +		value[2] = 0x3F;	/* 0xec04 */
> +		value[3] = 0x3E;	/* 0xec05 */
> +
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_pd_a,
> +				      15, value);
> +		if (error)
> +			goto exit;
> +
> +		value[0] = 0;
> +		value[1] = 0;
> +		value[2] = 0;
> +		value[3] = 0;
> +
> +		/* 0xec12~0xec15 */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_lna_g,
> +				      4, value);
> +		if (error)
> +			goto exit;
> +		/* oxec17~0xec1f */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_reg_pgc, 9,
> +				      value);
> +		if (error)
> +			goto exit;
> +		/* 0xec22~0xec2b */
> +		error =
> +		    it9135_write_regs(data, chip, PROCESSOR_OFDM,
> +				      p_reg_clk_del_sel, 10, value);
> +		if (error)
> +			goto exit;
> +		/* 0xec20 */
> +		error = it9135_write_reg(data, chip, PROCESSOR_OFDM, 0xec20, 0);
> +		if (error)
> +			goto exit;
> +		/* 0xec3f */
> +		error = it9135_write_reg(data, chip, PROCESSOR_OFDM, 0xec3F, 1);
> +		if (error)
> +			goto exit;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_ctrl_pid_filter(struct it9135_data *data,
> +				     unsigned char chip, unsigned char control)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  p_mp2if_pid_en, mp2if_pid_en_pos,
> +				  mp2if_pid_en_len, control);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_reset_pid_filter(struct it9135_data *data,
> +				      unsigned char chip)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM, p_mp2if_pid_rst,
> +				  mp2if_pid_rst_pos, mp2if_pid_rst_len, 1);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_add_pid_filter(struct it9135_data *data,
> +				    unsigned char chip, unsigned char index,
> +				    unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char w_buff[2];
> +
> +	/* Enable pid filter */
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM, p_mp2if_pid_en,
> +				  mp2if_pid_en_pos, mp2if_pid_en_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	w_buff[0] = (unsigned char)pid;
> +	w_buff[1] = (unsigned char)(pid >> 8);
> +
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_mp2if_pid_dat_l, 2,
> +			      w_buff);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  p_mp2if_pid_index_en, mp2if_pid_index_en_pos,
> +				  mp2if_pid_index_en_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_mp2if_pid_index,
> +			     index);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_get_snr(struct it9135_data *data, unsigned char chip,
> +			     unsigned char *snr)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	struct it9135_ch_modulation ch_modulation;
> +	unsigned long snr_value;
> +
> +	error = it9135_get_ch_modulation(data, chip, &ch_modulation);
> +	if (error)
> +		goto exit;
> +
> +	error = it9135_get_snr_val(data, chip, &snr_value);
> +	if (error)
> +		goto exit;
> +
> +	if (ch_modulation.trans_mode == TransmissionMode_2K)
> +		snr_value = snr_value * 4;
> +	else if (ch_modulation.trans_mode == TransmissionMode_4K)
> +		snr_value = snr_value * 2;
> +	else
> +		snr_value = snr_value * 1;
> +
> +	if (ch_modulation.constellation == 0) {	/* CONSTELLATION_QPSK */
> +		if (snr_value < 0xB4771)
> +			*snr = 0;
> +		else if (snr_value < 0xC1AED)
> +			*snr = 1;
> +		else if (snr_value < 0xD0D27)
> +			*snr = 2;
> +		else if (snr_value < 0xE4D19)
> +			*snr = 3;
> +		else if (snr_value < 0xE5DA8)
> +			*snr = 4;
> +		else if (snr_value < 0x107097)
> +			*snr = 5;
> +		else if (snr_value < 0x116975)
> +			*snr = 6;
> +		else if (snr_value < 0x1252D9)
> +			*snr = 7;
> +		else if (snr_value < 0x131FA4)
> +			*snr = 8;
> +		else if (snr_value < 0x13D5E1)
> +			*snr = 9;
> +		else if (snr_value < 0x148E53)
> +			*snr = 10;
> +		else if (snr_value < 0x15358B)
> +			*snr = 11;
> +		else if (snr_value < 0x15DD29)
> +			*snr = 12;
> +		else if (snr_value < 0x168112)
> +			*snr = 13;
> +		else if (snr_value < 0x170B61)
> +			*snr = 14;
> +		else if (snr_value < 0x17A532)
> +			*snr = 15;
> +		else if (snr_value < 0x180F94)
> +			*snr = 16;
> +		else if (snr_value < 0x186ED2)
> +			*snr = 17;
> +		else if (snr_value < 0x18B271)
> +			*snr = 18;
> +		else if (snr_value < 0x18E118)
> +			*snr = 19;
> +		else if (snr_value < 0x18FF4B)
> +			*snr = 20;
> +		else if (snr_value < 0x190AF1)
> +			*snr = 21;
> +		else if (snr_value < 0x191451)
> +			*snr = 22;
> +		else
> +			*snr = 23;
> +	} else if (ch_modulation.constellation == 1) {	/* CONSTELLATION_16QAM */
> +		if (snr_value < 0x4F0D5)
> +			*snr = 0;
> +		else if (snr_value < 0x5387A)
> +			*snr = 1;
> +		else if (snr_value < 0x573A4)
> +			*snr = 2;
> +		else if (snr_value < 0x5A99E)
> +			*snr = 3;
> +		else if (snr_value < 0x5CC80)
> +			*snr = 4;
> +		else if (snr_value < 0x5EB62)
> +			*snr = 5;
> +		else if (snr_value < 0x5FECF)
> +			*snr = 6;
> +		else if (snr_value < 0x60B80)
> +			*snr = 7;
> +		else if (snr_value < 0x62501)
> +			*snr = 8;
> +		else if (snr_value < 0x64865)
> +			*snr = 9;
> +		else if (snr_value < 0x69604)
> +			*snr = 10;
> +		else if (snr_value < 0x6F356)
> +			*snr = 11;
> +		else if (snr_value < 0x7706A)
> +			*snr = 12;
> +		else if (snr_value < 0x804D3)
> +			*snr = 13;
> +		else if (snr_value < 0x89D1A)
> +			*snr = 14;
> +		else if (snr_value < 0x93E3D)
> +			*snr = 15;
> +		else if (snr_value < 0x9E35D)
> +			*snr = 16;
> +		else if (snr_value < 0xA7C3C)
> +			*snr = 17;
> +		else if (snr_value < 0xAFAF8)
> +			*snr = 18;
> +		else if (snr_value < 0xB719D)
> +			*snr = 19;
> +		else if (snr_value < 0xBDA6A)
> +			*snr = 20;
> +		else if (snr_value < 0xC0C75)
> +			*snr = 21;
> +		else if (snr_value < 0xC3F7D)
> +			*snr = 22;
> +		else if (snr_value < 0xC5E62)
> +			*snr = 23;
> +		else if (snr_value < 0xC6C31)
> +			*snr = 24;
> +		else if (snr_value < 0xC7925)
> +			*snr = 25;
> +		else
> +			*snr = 26;
> +	} else if (ch_modulation.constellation == 2) {	/* CONSTELLATION_64QAM */
> +		if (snr_value < 0x256D0)
> +			*snr = 0;
> +		else if (snr_value < 0x27A65)
> +			*snr = 1;
> +		else if (snr_value < 0x29873)
> +			*snr = 2;
> +		else if (snr_value < 0x2B7FE)
> +			*snr = 3;
> +		else if (snr_value < 0x2CF1E)
> +			*snr = 4;
> +		else if (snr_value < 0x2E234)
> +			*snr = 5;
> +		else if (snr_value < 0x2F409)
> +			*snr = 6;
> +		else if (snr_value < 0x30046)
> +			*snr = 7;
> +		else if (snr_value < 0x30844)
> +			*snr = 8;
> +		else if (snr_value < 0x30A02)
> +			*snr = 9;
> +		else if (snr_value < 0x30CDE)
> +			*snr = 10;
> +		else if (snr_value < 0x31031)
> +			*snr = 11;
> +		else if (snr_value < 0x3144C)
> +			*snr = 12;
> +		else if (snr_value < 0x315DD)
> +			*snr = 13;
> +		else if (snr_value < 0x31920)
> +			*snr = 14;
> +		else if (snr_value < 0x322D0)
> +			*snr = 15;
> +		else if (snr_value < 0x339FC)
> +			*snr = 16;
> +		else if (snr_value < 0x364A1)
> +			*snr = 17;
> +		else if (snr_value < 0x38BCC)
> +			*snr = 18;
> +		else if (snr_value < 0x3C7D3)
> +			*snr = 19;
> +		else if (snr_value < 0x408CC)
> +			*snr = 20;
> +		else if (snr_value < 0x43BED)
> +			*snr = 21;
> +		else if (snr_value < 0x48061)
> +			*snr = 22;
> +		else if (snr_value < 0x4BE95)
> +			*snr = 23;
> +		else if (snr_value < 0x4FA7D)
> +			*snr = 24;
> +		else if (snr_value < 0x52405)
> +			*snr = 25;
> +		else if (snr_value < 0x5570D)
> +			*snr = 26;
> +		else if (snr_value < 0x59FEB)
> +			*snr = 27;
> +		else if (snr_value < 0x5BF38)
> +			*snr = 28;
> +		else if (snr_value < 0x5F78F)
> +			*snr = 29;
> +		else if (snr_value < 0x612C3)
> +			*snr = 30;
> +		else if (snr_value < 0x626BE)
> +			*snr = 31;
> +		else
> +			*snr = 32;


The above function seems weird for me. Maximum value for SNR in Linux
should be 65535, and not 32. It seems that all you need is to do something
like (for CONSTELLATION_64QAM. Same logic applies also to the other constellation):

	if (snr_value >=  0x626BE)
		*snr = 65535;
	else	{
		u64 snr64 = snr_value * 65536;
		*snr = do_div_u64 (snr64, 0x626BE);
	}


> +	} else
> +		goto exit;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_get_snr_val(struct it9135_data *data, unsigned char chip,
> +				 unsigned long *snr_value)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char super_frame_num = 0;
> +	unsigned char snr_reg[3];
> +
> +	error = it9135_read_regs(data, chip, PROCESSOR_OFDM, 0x2c, 3, snr_reg);
> +	if (error)
> +		goto exit;
> +
> +	*snr_value = (snr_reg[2] << 16) + (snr_reg[1] << 8) + snr_reg[0];
> +
> +	/* gets superFrame num */
> +	error =
> +	    it9135_read_reg(data, chip, PROCESSOR_OFDM, 0xF78b,
> +			    (unsigned char *)&super_frame_num);
> +	if (error)
> +		goto exit;
> +
> +	if (super_frame_num)
> +		*snr_value /= super_frame_num;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_set_multiplier(struct it9135_data *data,
> +				    unsigned char multiplier)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char new_adc_mul = 0;
> +	unsigned char buffer[3];
> +	long ctl_word;
> +	unsigned char i;
> +
> +	if (multiplier == Multiplier_1X)
> +		new_adc_mul = 0;
> +	else
> +		new_adc_mul = 1;
> +
> +	for (i = 0; i < data->chip_num; i++) {
> +		/* Write ADC multiplier factor to firmware. */
> +		error =
> +		    it9135_write_reg(data, i, PROCESSOR_OFDM, adcx2,
> +				     new_adc_mul);
> +		if (error)
> +			goto exit;
> +	}
> +
> +	/* Compute FCW and load them to device */
> +	if (data->fcw >= 0x00400000)
> +		ctl_word = data->fcw - 0x00800000;
> +	else
> +		ctl_word = data->fcw;
> +
> +	if (new_adc_mul == 1)
> +		ctl_word /= 2;
> +	else
> +		ctl_word *= 2;
> +
> +	data->fcw = 0x7FFFFF & ctl_word;
> +
> +	buffer[0] = (unsigned char)(data->fcw & 0x000000FF);
> +	buffer[1] = (unsigned char)((data->fcw & 0x0000FF00) >> 8);
> +	buffer[2] = (unsigned char)((data->fcw & 0x007F0000) >> 16);
> +	for (i = 0; i < data->chip_num; i++)
> +		error =
> +		    it9135_write_regs(data, i, PROCESSOR_OFDM, bfs_fcw_7_0,
> +				      bfs_fcw_22_16 - bfs_fcw_7_0 + 1, buffer);
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_reset_pid(struct it9135_data *data, unsigned char chip)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char i;
> +
> +	for (i = 0; i < 32; i++)
> +		data->pid_info.pid_tab[chip].pid[i] = 0xFFFF;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM, p_mp2if_pid_rst,
> +				  mp2if_pid_rst_pos, mp2if_pid_rst_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	data->pid_info.pid_cnt = 0;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_remove_pid_at(struct it9135_data *data, unsigned char chip,
> +				   unsigned char index, unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  p_mp2if_pid_index_en, mp2if_pid_index_en_pos,
> +				  mp2if_pid_index_en_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_mp2if_pid_index,
> +			     index);
> +	if (error)
> +		goto exit;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_get_ch_statistic(struct it9135_data *data,
> +				      unsigned char chip,
> +				      struct it9135_ch_statistic *ch_statistic)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long post_err_cnt;
> +	unsigned long post_bit_cnt;
> +	unsigned short rsd_abort_cnt;
> +
> +	/* Get BER if couter is ready, error = ERROR_RSD_COUNTER_NOT_READY if counter is not ready */
> +	if (data->architecture == ARCHITECTURE_PIP) {
> +		error =
> +		    it9135_get_post_vitber(data, chip, &post_err_cnt,
> +					   &post_bit_cnt, &rsd_abort_cnt);
> +		if (error == ERROR_NO_ERROR) {
> +			data->ch_statistic[chip].post_vit_err_cnt =
> +			    post_err_cnt;
> +			data->ch_statistic[chip].post_vitbit_cnt = post_bit_cnt;
> +			data->ch_statistic[chip].abort_cnt = rsd_abort_cnt;
> +		}
> +	} else {
> +		error =
> +		    it9135_get_post_vitber(data, 0, &post_err_cnt,
> +					   &post_bit_cnt, &rsd_abort_cnt);
> +		if (error == ERROR_NO_ERROR) {
> +			data->ch_statistic[chip].post_vit_err_cnt =
> +			    post_err_cnt;
> +			data->ch_statistic[chip].post_vitbit_cnt = post_bit_cnt;
> +			data->ch_statistic[chip].abort_cnt = rsd_abort_cnt;
> +		}
> +	}
> +
> +	*ch_statistic = data->ch_statistic[chip];
> +
> +	return error;
> +}
> +
> +static struct it9135_tuner_desc tuner_def_desc = {
> +	NULL,
> +	NULL,
> +	0x38,			/* tuner id */
> +};
> +
> +unsigned long it9135_set_bus_tuner(struct it9135_data *data,
> +				   unsigned short busId,
> +				   unsigned short tuner_id)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char support_type = OMEGA_NORMAL;
> +
> +	data->busId = busId;
> +	memcpy(&data->tuner_desc, &tuner_def_desc, sizeof(data->tuner_desc));
> +
> +	switch (tuner_id) {
> +	case IT9135_TUNER_ID:
> +		support_type = OMEGA_NORMAL;
> +		break;
> +	case IT9135_TUNER_ID_LNA_CONFIG1:
> +		support_type = OMEGA_LNA_CONFIG1;
> +		break;
> +	case IT9135_TUNER_ID_LNA_CONFIG2:
> +		support_type = OMEGA_LNA_CONFIG2;
> +		break;
> +	case IT9135_TUNER_ID_V2:
> +		support_type = OMEGA_NORMAL;
> +		break;
> +	case IT9135_TUNER_ID_V2_LNA_CONFIG1:
> +		support_type = OMEGA_LNA_CONFIG1;
> +		break;
> +	case IT9135_TUNER_ID_V2_LNA_CONFIG2:
> +		support_type = OMEGA_LNA_CONFIG2;
> +		break;

Please split the tuner code from the main driver. How are tuner is interconnected?
Via I2C? If so, the tuner should use I2C core.

> +	default:
> +		error = ERROR_INVALID_TUNER_TYPE;
> +		goto exit;
> +	}
> +
> +	if (data->chip_type == 0x9135 && data->chip_ver == 2) {
> +		switch (support_type) {
> +		case OMEGA_NORMAL:
> +			data->tuner_desc.scripts = data->tuner_script_normal;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_normal;
> +			data->tuner_desc.id = IT9135_TUNER_ID_V2;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		case OMEGA_LNA_CONFIG1:
> +			data->tuner_desc.scripts = data->tuner_script_lna1;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_lna1;
> +			data->tuner_desc.id = IT9135_TUNER_ID_V2_LNA_CONFIG1;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		case OMEGA_LNA_CONFIG2:
> +			data->tuner_desc.scripts = data->tuner_script_lna2;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_lna2;
> +			data->tuner_desc.id = IT9135_TUNER_ID_V2_LNA_CONFIG2;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else {
> +		switch (support_type) {
> +		case OMEGA_NORMAL:
> +			data->tuner_desc.scripts = data->tuner_script_normal;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_normal;
> +			data->tuner_desc.id = IT9135_TUNER_ID;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		case OMEGA_LNA_CONFIG1:
> +			data->tuner_desc.scripts = data->tuner_script_lna1;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_lna1;
> +			data->tuner_desc.id = IT9135_TUNER_ID_LNA_CONFIG1;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		case OMEGA_LNA_CONFIG2:
> +			data->tuner_desc.scripts = data->tuner_script_lna2;
> +			data->tuner_desc.script_sets =
> +			    &data->tuner_script_sets_lna2;
> +			data->tuner_desc.id = IT9135_TUNER_ID_LNA_CONFIG2;
> +			error = ERROR_NO_ERROR;
> +			break;
> +		default:
> +
> +			break;
> +		}
> +	}
> +
> +	if (data->tuner_desc.scripts == NULL) {
> +		data->tuner_desc.scripts = NULL;
> +		data->tuner_desc.script_sets = NULL;
> +	}
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_add_pid(struct it9135_data *data, unsigned char chip,
> +			     unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char w_buff[2];
> +	unsigned char i, j;
> +	int found = 0;
> +
> +	if (!data->pid_info.pid_init) {
> +		for (i = 0; i < data->chip_num; i++) {
> +			for (j = 0; j < 32; j++)
> +				data->pid_info.pid_tab[i].pid[j] = 0xFFFF;
> +		}
> +		data->pid_info.pid_init = 1;
> +	}
> +
> +	/* Enable pid filter */
> +	if (data->pid_info.pid_cnt == 0) {
> +		error =
> +		    it9135_write_reg_bits(data, chip,
> +					  PROCESSOR_OFDM, p_mp2if_pid_en,
> +					  mp2if_pid_en_pos, mp2if_pid_en_len,
> +					  1);
> +		if (error)
> +			goto exit;
> +	} else {
> +		for (i = 0; i < 32; i++) {
> +			if (data->pid_info.pid_tab[chip].pid[i] == pid) {
> +				found = 1;
> +				break;
> +			}
> +		}
> +		if (found)
> +			goto exit;
> +	}
> +
> +	for (i = 0; i < 32; i++) {
> +		if (data->pid_info.pid_tab[chip].pid[i] == 0xFFFF)
> +			break;
> +	}
> +	if (i == 32) {
> +		error = ERROR_PID_FILTER_FULL;
> +		goto exit;
> +	}
> +
> +	w_buff[0] = (unsigned char)pid;
> +	w_buff[1] = (unsigned char)(pid >> 8);
> +
> +	error =
> +	    it9135_write_regs(data, chip, PROCESSOR_OFDM, p_mp2if_pid_dat_l, 2,
> +			      w_buff);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  p_mp2if_pid_index_en, mp2if_pid_index_en_pos,
> +				  mp2if_pid_index_en_len, 1);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_mp2if_pid_index, i);
> +	if (error)
> +		goto exit;
> +
> +	data->pid_info.pid_tab[chip].pid[i] = pid;
> +	data->pid_info.pid_cnt++;
> +
> +exit:
> +	return error;
> +}
> +
> +unsigned long it9135_add_pid_at(struct it9135_data *data, unsigned char chip,
> +				unsigned char index, unsigned short pid)
> +{
> +	return it9135_add_pid_filter(data, chip, index, pid);
> +}
> +
> +unsigned long it9135_remove_pid(struct it9135_data *data, unsigned char chip,
> +				unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char i;
> +	int found = 0;
> +
> +	for (i = 0; i < 32; i++) {
> +		if (data->pid_info.pid_tab[chip].pid[i] == pid) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg_bits(data, chip, PROCESSOR_OFDM,
> +				  p_mp2if_pid_index_en, mp2if_pid_index_en_pos,
> +				  mp2if_pid_index_en_len, 0);
> +	if (error)
> +		goto exit;
> +
> +	error =
> +	    it9135_write_reg(data, chip, PROCESSOR_OFDM, p_mp2if_pid_index, i);
> +	if (error)
> +		goto exit;
> +
> +	data->pid_info.pid_tab[chip].pid[i] = 0xFFFF;
> +
> +	/* Disable pid filter */
> +	if (data->pid_info.pid_cnt == 1) {
> +		error =
> +		    it9135_write_reg_bits(data, chip,
> +					  PROCESSOR_OFDM, p_mp2if_pid_en,
> +					  mp2if_pid_en_pos, mp2if_pid_en_len,
> +					  0);
> +	}
> +
> +	data->pid_info.pid_cnt--;
> +
> +exit:
> +	return error;
> +}
> diff --git a/drivers/media/dvb/dvb-usb/it9135-fe.h b/drivers/media/dvb/dvb-usb/it9135-fe.h
> new file mode 100644
> index 0000000..1744ba4
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/it9135-fe.h
> @@ -0,0 +1,1632 @@
> +/*
> + * DVB USB Linux driver for IT9135 DVB-T USB2.0 receiver
> + *
> + * Copyright (C) 2011 ITE Technologies, INC.
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + */
> +
> +#ifndef __IT9135_FE_H__
> +#define __IT9135_FE_H__
> +
> +#define IT9135_API_VER_NUM	0x0203
> +#define IT9135_API_DATE		0x20110426
> +#define IT9135_API_BUILD	0x00
> +
> +/*
> + * Hardware register define
> + */
> +#define    p_reg_pd_a				0xEC02
> +#define	reg_pd_a_pos 0
> +#define	reg_pd_a_len 6
> +#define	reg_pd_a_lsb 0
> +#define    p_reg_pd_c				0xEC04
> +#define	reg_pd_c_pos 0
> +#define	reg_pd_c_len 6
> +#define	reg_pd_c_lsb 0
> +#define    p_reg_pd_d				0xEC05
> +#define	reg_pd_d_pos 0
> +#define	reg_pd_d_len 6
> +#define	reg_pd_d_lsb 0
> +#define    p_reg_tst_a				0xEC06
> +#define	reg_tst_a_pos 0
> +#define	reg_tst_a_len 6
> +#define	reg_tst_a_lsb 0
> +#define    p_reg_tst_b				0xEC07
> +#define	reg_tst_b_pos 0
> +#define	reg_tst_b_len 2
> +#define	reg_tst_b_lsb 0
> +#define    p_reg_ctrl_a				0xEC08
> +#define	reg_ctrl_a_pos 0
> +#define	reg_ctrl_a_len 6
> +#define	reg_ctrl_a_lsb 0
> +#define    p_reg_ctrl_b				0xEC09
> +#define	reg_ctrl_b_pos 0
> +#define	reg_ctrl_b_len 2
> +#define	reg_ctrl_b_lsb 0
> +#define    p_reg_cal_freq_a			0xEC0A
> +#define	reg_cal_freq_a_pos 0
> +#define	reg_cal_freq_a_len 6
> +#define	reg_cal_freq_a_lsb 0
> +#define    p_reg_cal_freq_b			0xEC0B
> +#define	reg_cal_freq_b_pos 0
> +#define	reg_cal_freq_b_len 6
> +#define	reg_cal_freq_b_lsb 0
> +#define    p_reg_cal_freq_c			0xEC0C
> +#define	reg_cal_freq_c_pos 0
> +#define	reg_cal_freq_c_len 4
> +#define	reg_cal_freq_c_lsb 0
> +#define    p_reg_lo_freq_a			0xEC0D
> +#define	reg_lo_freq_a_pos 0
> +#define	reg_lo_freq_a_len 6
> +#define	reg_lo_freq_a_lsb 0
> +#define    p_reg_lo_freq_b			0xEC0E
> +#define	reg_lo_freq_b_pos 0
> +#define	reg_lo_freq_b_len 6
> +#define	reg_lo_freq_b_lsb 0
> +#define    p_reg_lo_freq_c			0xEC0F
> +#define	reg_lo_freq_c_pos 0
> +#define	reg_lo_freq_c_len 4
> +#define	reg_lo_freq_c_lsb 0
> +#define    p_reg_lo_cap				0xEC10
> +#define	reg_lo_cap_pos 0
> +#define	reg_lo_cap_len 6
> +#define	reg_lo_cap_lsb 0
> +#define    p_reg_clk02_select			0xEC11
> +#define	reg_clk02_select_pos 0
> +#define	reg_clk02_select_len 3
> +#define	reg_clk02_select_lsb 0
> +#define    p_reg_clk01_select			0xEC11
> +#define	reg_clk01_select_pos 3
> +#define	reg_clk01_select_len 3
> +#define	reg_clk01_select_lsb 0
> +#define    p_reg_lna_cap			0xEC13
> +#define	reg_lna_cap_pos 0
> +#define	reg_lna_cap_len 6
> +#define	reg_lna_cap_lsb 0
> +#define    p_reg_lna_g				0xEC12
> +#define	reg_lna_g_pos 0
> +#define	reg_lna_g_len 3
> +#define	reg_lna_g_lsb 0
> +#define    p_reg_lna_band			0xEC14
> +#define	reg_lna_band_pos 0
> +#define	reg_lna_band_len 3
> +#define	reg_lna_band_lsb 0
> +#define    p_reg_pga				0xEC15
> +#define	reg_pga_pos 0
> +#define	reg_pga_len 6
> +#define	reg_pga_lsb 0
> +#define    p_reg_pgc				0xEC17
> +#define	reg_pgc_pos 0
> +#define	reg_pgc_len 3
> +#define	reg_pgc_lsb 0
> +#define    p_reg_lpf_cap			0xEC18
> +#define	reg_lpf_cap_pos 0
> +#define	reg_lpf_cap_len 5
> +#define	reg_lpf_cap_lsb 0
> +#define    p_reg_lpf_bw				0xEC19
> +#define	reg_lpf_bw_pos 0
> +#define	reg_lpf_bw_len 3
> +#define	reg_lpf_bw_lsb 0
> +#define    p_reg_ofsi				0xEC1A
> +#define	reg_ofsi_pos 0
> +#define	reg_ofsi_len 6
> +#define	reg_ofsi_lsb 0
> +#define    p_reg_ofsq				0xEC1B
> +#define	reg_ofsq_pos 0
> +#define	reg_ofsq_len 6
> +#define	reg_ofsq_lsb 0
> +#define    p_reg_dcxo_a				0xEC1C
> +#define	reg_dcxo_a_pos 0
> +#define	reg_dcxo_a_len 6
> +#define	reg_dcxo_a_lsb 0
> +#define    p_reg_dcxo_b				0xEC1D
> +#define	reg_dcxo_b_pos 0
> +#define	reg_dcxo_b_len 4
> +#define	reg_dcxo_b_lsb 0
> +#define    p_reg_tddo				0xEC1E
> +#define	reg_tddo_pos 0
> +#define	reg_tddo_len 6
> +#define	reg_tddo_lsb 0
> +#define    p_reg_strength_setting		0xEC1F
> +#define	reg_strength_setting_pos 0
> +#define	reg_strength_setting_len 6
> +#define	reg_strength_setting_lsb 0
> +#define    p_reg_gi				0xEC22
> +#define	reg_gi_pos 0
> +#define	reg_gi_len 2
> +#define	reg_gi_lsb 0
> +#define    p_reg_clk_del_sel			0xEC22
> +#define	reg_clk_del_sel_pos 2
> +#define	reg_clk_del_sel_len 2
> +#define	reg_clk_del_sel_lsb 0
> +#define    p_reg_p2s_ck_sel			0xEC22
> +#define	reg_p2s_ck_sel_pos 4
> +#define	reg_p2s_ck_sel_len 1
> +#define	reg_p2s_ck_sel_lsb 0
> +#define    p_reg_rssi_sel			0xEC22
> +#define	reg_rssi_sel_pos 5
> +#define	reg_rssi_sel_len 1
> +#define	reg_rssi_sel_lsb 0
> +#define    p_reg_tst_sel			0xEC23
> +#define	reg_tst_sel_pos 4
> +#define	reg_tst_sel_len 2
> +#define	reg_tst_sel_lsb 0
> +#define    p_reg_ctrl_c				0xEC24
> +#define	reg_ctrl_c_pos 0
> +#define	reg_ctrl_c_len 6
> +#define	reg_ctrl_c_lsb 0
> +#define    p_reg_ctrl_d				0xEC25
> +#define	reg_ctrl_d_pos 0
> +#define	reg_ctrl_d_len 6
> +#define	reg_ctrl_d_lsb 0
> +#define    p_reg_ctrl_e				0xEC26
> +#define	reg_ctrl_e_pos 0
> +#define	reg_ctrl_e_len 6
> +#define	reg_ctrl_e_lsb 0
> +#define    p_reg_ctrl_f				0xEC27
> +#define	reg_ctrl_f_pos 0
> +#define	reg_ctrl_f_len 6
> +#define	reg_ctrl_f_lsb 0
> +#define    p_reg_lo_bias			0xEC28
> +#define	reg_lo_bias_pos 0
> +#define	reg_lo_bias_len 3
> +#define	reg_lo_bias_lsb 0
> +#define    p_reg_ext_lna_en			0xEC29
> +#define	reg_ext_lna_en_pos 0
> +#define	reg_ext_lna_en_len 1
> +#define	reg_ext_lna_en_lsb 0
> +#define    p_reg_pga_bak			0xEC2A
> +#define	reg_pga_bak_pos 0
> +#define	reg_pga_bak_len 3
> +#define	reg_pga_bak_lsb 0
> +#define    p_reg_cpll_cap			0xEC2B
> +#define	reg_cpll_cap_pos 0
> +#define	reg_cpll_cap_len 6
> +#define	reg_cpll_cap_lsb 0
> +#define    p_reg_p_if_en			0xEC40
> +#define	reg_p_if_en_pos 0
> +#define	reg_p_if_en_len 2
> +#define	reg_p_if_en_lsb 0
> +#define    p_reg_one_cycle_counter_tuner	0xF103
> +#define	reg_one_cycle_counter_tuner_pos 0
> +#define	reg_one_cycle_counter_tuner_len 8
> +#define	reg_one_cycle_counter_tuner_lsb 0
> +#define    p_reg_f_adc_7_0			0xF1CD
> +#define	reg_f_adc_7_0_pos 0
> +#define	reg_f_adc_7_0_len 8
> +#define	reg_f_adc_7_0_lsb 0
> +#define    p_reg_dvbt_en			0xF41A
> +#define	reg_dvbt_en_pos 0
> +#define	reg_dvbt_en_len 1
> +#define	reg_dvbt_en_lsb 0
> +#define    p_fd_tpsd_lock			0xF5A9
> +#define	fd_tpsd_lock_pos 0
> +#define	fd_tpsd_lock_len 1
> +#define	fd_tpsd_lock_lsb 0
> +#define    p_reg_feq_read_update		0xF5CA
> +#define	reg_feq_read_update_pos 0
> +#define	reg_feq_read_update_len 1
> +#define	reg_feq_read_update_lsb 0
> +#define    p_reg_link_ofsm_dummy_15_8		0xF641
> +#define	reg_link_ofsm_dummy_15_8_pos 0
> +#define	reg_link_ofsm_dummy_15_8_len 8
> +#define	reg_link_ofsm_dummy_15_8_lsb 8
> +#define    p_fec_vtb_rsd_mon_en			0xF715
> +#define	fec_vtb_rsd_mon_en_pos 0
> +#define	fec_vtb_rsd_mon_en_len 1
> +#define	fec_vtb_rsd_mon_en_lsb 0
> +#define    p_reg_dca_platch			0xF730
> +#define	reg_dca_platch_pos 0
> +#define	reg_dca_platch_len 1
> +#define	reg_dca_platch_lsb 0
> +#define    p_reg_dca_upper_chip			0xF731
> +#define	reg_dca_upper_chip_pos 0
> +#define	reg_dca_upper_chip_len 1
> +#define	reg_dca_upper_chip_lsb 0
> +#define    p_reg_dca_lower_chip			0xF732
> +#define	reg_dca_lower_chip_pos 0
> +#define	reg_dca_lower_chip_len 1
> +#define	reg_dca_lower_chip_lsb 0
> +#define    p_reg_dca_stand_alone		0xF73C
> +#define	reg_dca_stand_alone_pos 0
> +#define	reg_dca_stand_alone_len 1
> +#define	reg_dca_stand_alone_lsb 0
> +#define    p_reg_dca_upper_out_en		0xF73D
> +#define	reg_dca_upper_out_en_pos 0
> +#define	reg_dca_upper_out_en_len 1
> +#define	reg_dca_upper_out_en_lsb 0
> +#define    p_reg_dca_en				0xF776
> +#define	reg_dca_en_pos 0
> +#define	reg_dca_en_len 1
> +#define	reg_dca_en_lsb 0
> +#define    p_reg_dca_fpga_latch			0xF778
> +#define	reg_dca_fpga_latch_pos 0
> +#define	reg_dca_fpga_latch_len 8
> +#define	reg_dca_fpga_latch_lsb 0
> +#define    g_reg_tpsd_txmod			0xF900
> +#define	reg_tpsd_txmod_pos 0
> +#define	reg_tpsd_txmod_len 2
> +#define	reg_tpsd_txmod_lsb 0
> +#define    g_reg_tpsd_gi			0xF901
> +#define	reg_tpsd_gi_pos 0
> +#define	reg_tpsd_gi_len 2
> +#define	reg_tpsd_gi_lsb 0
> +#define    g_reg_tpsd_hier			0xF902
> +#define	reg_tpsd_hier_pos 0
> +#define	reg_tpsd_hier_len 3
> +#define	reg_tpsd_hier_lsb 0
> +#define    g_reg_tpsd_const			0xF903
> +#define	reg_tpsd_const_pos 0
> +#define	reg_tpsd_const_len 2
> +#define	reg_tpsd_const_lsb 0
> +#define    g_reg_bw				0xF904
> +#define	reg_bw_pos 0
> +#define	reg_bw_len 2
> +#define	reg_bw_lsb 0
> +#define    g_reg_dec_pri			0xF905
> +#define	reg_dec_pri_pos 0
> +#define	reg_dec_pri_len 1
> +#define	reg_dec_pri_lsb 0
> +#define    g_reg_tpsd_hpcr			0xF906
> +#define	reg_tpsd_hpcr_pos 0
> +#define	reg_tpsd_hpcr_len 3
> +#define	reg_tpsd_hpcr_lsb 0
> +#define    g_reg_tpsd_lpcr			0xF907
> +#define	reg_tpsd_lpcr_pos 0
> +#define	reg_tpsd_lpcr_len 3
> +#define	reg_tpsd_lpcr_lsb 0
> +#define    p_mp2if_mpeg_ser_mode		0xF985
> +#define	mp2if_mpeg_ser_mode_pos 0
> +#define	mp2if_mpeg_ser_mode_len 1
> +#define	mp2if_mpeg_ser_mode_lsb 0
> +#define    p_mp2if_mpeg_par_mode		0xF986
> +#define	mp2if_mpeg_par_mode_pos 0
> +#define	mp2if_mpeg_par_mode_len 1
> +#define	mp2if_mpeg_par_mode_lsb 0
> +#define    p_reg_mpeg_full_speed		0xF990
> +#define	reg_mpeg_full_speed_pos 0
> +#define	reg_mpeg_full_speed_len 1
> +#define	reg_mpeg_full_speed_lsb 0
> +#define    p_mp2if_pid_rst			0xF992
> +#define	mp2if_pid_rst_pos 0
> +#define	mp2if_pid_rst_len 1
> +#define	mp2if_pid_rst_lsb 0
> +#define    p_mp2if_pid_en			0xF993
> +#define	mp2if_pid_en_pos 0
> +#define	mp2if_pid_en_len 1
> +#define	mp2if_pid_en_lsb 0
> +#define    p_mp2if_pid_index_en			0xF994
> +#define	mp2if_pid_index_en_pos 0
> +#define	mp2if_pid_index_en_len 1
> +#define	mp2if_pid_index_en_lsb 0
> +#define    p_mp2if_pid_index			0xF995
> +#define	mp2if_pid_index_pos 0
> +#define	mp2if_pid_index_len 5
> +#define	mp2if_pid_index_lsb 0
> +#define    p_mp2if_pid_dat_l			0xF996
> +#define	mp2if_pid_dat_l_pos 0
> +#define	mp2if_pid_dat_l_len 8
> +#define	mp2if_pid_dat_l_lsb 0
> +#define    r_mp2if_sync_byte_locked		0xF999
> +#define	mp2if_sync_byte_locked_pos 0
> +#define	mp2if_sync_byte_locked_len 1
> +#define	mp2if_sync_byte_locked_lsb 0
> +#define    p_reg_mp2_sw_rst			0xF99D
> +#define	reg_mp2_sw_rst_pos 0
> +#define	reg_mp2_sw_rst_len 1
> +#define	reg_mp2_sw_rst_lsb 0
> +#define    p_reg_mp2if2_en			0xF9A3
> +#define	reg_mp2if2_en_pos 0
> +#define	reg_mp2if2_en_len 1
> +#define	reg_mp2if2_en_lsb 0
> +#define    p_reg_mp2if2_sw_rst			0xF9A4
> +#define	reg_mp2if2_sw_rst_pos 0
> +#define	reg_mp2if2_sw_rst_len 1
> +#define	reg_mp2if2_sw_rst_lsb 0
> +#define    p_reg_mp2if2_half_psb		0xF9A5
> +#define	reg_mp2if2_half_psb_pos 0
> +#define	reg_mp2if2_half_psb_len 1
> +#define	reg_mp2if2_half_psb_lsb 0
> +#define    p_reg_mp2if_stop_en			0xF9B5
> +#define	reg_mp2if_stop_en_pos 0
> +#define	reg_mp2if_stop_en_len 1
> +#define	reg_mp2if_stop_en_lsb 0
> +#define    p_reg_tsis_en			0xF9CD
> +#define	reg_tsis_en_pos 0
> +#define	reg_tsis_en_len 1
> +#define	reg_tsis_en_lsb 0
> +#define    p_reg_afe_mem0			0xFB24
> +#define	reg_afe_mem0_pos 0
> +#define	reg_afe_mem0_len 8
> +#define	reg_afe_mem0_lsb 0
> +#define    p_reg_dyn0_clk			0xFBA8
> +#define	reg_dyn0_clk_pos 0
> +#define	reg_dyn0_clk_len 1
> +#define	reg_dyn0_clk_lsb 0
> +#define    r_io_mux_pwron_clk_strap		0xD800
> +#define	io_mux_pwron_clk_strap_pos 0
> +#define	io_mux_pwron_clk_strap_len 4
> +#define	io_mux_pwron_clk_strap_lsb 0
> +#define    p_reg_top_pwrdw_hwen			0xD809
> +#define	reg_top_pwrdw_hwen_pos 0
> +#define	reg_top_pwrdw_hwen_len 1
> +#define	reg_top_pwrdw_hwen_lsb 0
> +#define    p_reg_top_pwrdw			0xD80B
> +#define	reg_top_pwrdw_pos 0
> +#define	reg_top_pwrdw_len 1
> +#define	reg_top_pwrdw_lsb 0
> +#define    p_reg_top_padodpu			0xD827
> +#define	reg_top_padodpu_pos 0
> +#define	reg_top_padodpu_len 1
> +#define	reg_top_padodpu_lsb 0
> +#define    p_reg_top_agc_od			0xD829
> +#define	reg_top_agc_od_pos 0
> +#define	reg_top_agc_od_len 1
> +#define	reg_top_agc_od_lsb 0
> +#define    p_reg_top_padmiscdr2			0xD830
> +#define	reg_top_padmiscdr2_pos 0
> +#define	reg_top_padmiscdr2_len 1
> +#define	reg_top_padmiscdr2_lsb 0
> +#define    p_reg_top_padmiscdr4			0xD831
> +#define	reg_top_padmiscdr4_pos 0
> +#define	reg_top_padmiscdr4_len 1
> +#define	reg_top_padmiscdr4_lsb 0
> +#define    p_reg_top_padmiscdr8			0xD832
> +#define	reg_top_padmiscdr8_pos 0
> +#define	reg_top_padmiscdr8_len 1
> +#define	reg_top_padmiscdr8_lsb 0
> +#define    p_reg_top_padmiscdrsr		0xD833
> +#define	reg_top_padmiscdrsr_pos 0
> +#define	reg_top_padmiscdrsr_len 1
> +#define	reg_top_padmiscdrsr_lsb 0
> +#define    p_reg_top_gpioh1_o			0xD8AF
> +#define	reg_top_gpioh1_o_pos 0
> +#define	reg_top_gpioh1_o_len 1
> +#define	reg_top_gpioh1_o_lsb 0
> +#define    p_reg_top_gpioh1_en			0xD8B0
> +#define	reg_top_gpioh1_en_pos 0
> +#define	reg_top_gpioh1_en_len 1
> +#define	reg_top_gpioh1_en_lsb 0
> +#define    p_reg_top_gpioh1_on			0xD8B1
> +#define	reg_top_gpioh1_on_pos 0
> +#define	reg_top_gpioh1_on_len 1
> +#define	reg_top_gpioh1_on_lsb 0
> +#define    p_reg_top_gpioh3_o			0xD8B3
> +#define	reg_top_gpioh3_o_pos 0
> +#define	reg_top_gpioh3_o_len 1
> +#define	reg_top_gpioh3_o_lsb 0
> +#define    p_reg_top_gpioh3_en			0xD8B4
> +#define	reg_top_gpioh3_en_pos 0
> +#define	reg_top_gpioh3_en_len 1
> +#define	reg_top_gpioh3_en_lsb 0
> +#define    p_reg_top_gpioh3_on			0xD8B5
> +#define	reg_top_gpioh3_on_pos 0
> +#define	reg_top_gpioh3_on_len 1
> +#define	reg_top_gpioh3_on_lsb 0
> +#define    p_reg_top_gpioh5_o			0xD8BB
> +#define	reg_top_gpioh5_o_pos 0
> +#define	reg_top_gpioh5_o_len 1
> +#define	reg_top_gpioh5_o_lsb 0
> +#define    p_reg_top_gpioh5_en			0xD8BC
> +#define	reg_top_gpioh5_en_pos 0
> +#define	reg_top_gpioh5_en_len 1
> +#define	reg_top_gpioh5_en_lsb 0
> +#define    p_reg_top_gpioh5_on			0xD8BD
> +#define	reg_top_gpioh5_on_pos 0
> +#define	reg_top_gpioh5_on_len 1
> +#define	reg_top_gpioh5_on_lsb 0
> +#define    p_reg_top_gpioh7_en			0xD8C4
> +#define	reg_top_gpioh7_en_pos 0
> +#define	reg_top_gpioh7_en_len 1
> +#define	reg_top_gpioh7_en_lsb 0
> +#define    p_reg_top_gpioh7_on			0xD8C5
> +#define	reg_top_gpioh7_on_pos 0
> +#define	reg_top_gpioh7_on_len 1
> +#define	reg_top_gpioh7_on_lsb 0
> +#define    p_reg_top_lock3_out			0xD8FD
> +#define	reg_top_lock3_out_pos 0
> +#define	reg_top_lock3_out_len 1
> +#define	reg_top_lock3_out_lsb 0
> +#define    p_reg_top_hostb_mpeg_par_mode	0xD91B
> +#define	reg_top_hostb_mpeg_par_mode_pos 0
> +#define	reg_top_hostb_mpeg_par_mode_len 1
> +#define	reg_top_hostb_mpeg_par_mode_lsb 0
> +#define    p_reg_top_hostb_mpeg_ser_mode	0xD91C
> +#define	reg_top_hostb_mpeg_ser_mode_pos 0
> +#define	reg_top_hostb_mpeg_ser_mode_len 1
> +#define	reg_top_hostb_mpeg_ser_mode_lsb 0
> +#define    p_reg_top_hostb_dca_upper		0xD91E
> +#define	reg_top_hostb_dca_upper_pos 0
> +#define	reg_top_hostb_dca_upper_len 1
> +#define	reg_top_hostb_dca_upper_lsb 0
> +#define    p_reg_top_hostb_dca_lower		0xD91F
> +#define	reg_top_hostb_dca_lower_pos 0
> +#define	reg_top_hostb_dca_lower_len 1
> +#define	reg_top_hostb_dca_lower_lsb 0
> +#define    p_reg_ep4_max_pkt			0xDD0C
> +#define	reg_ep4_max_pkt_pos 0
> +#define	reg_ep4_max_pkt_len 8
> +#define	reg_ep4_max_pkt_lsb 0
> +#define    p_reg_ep5_max_pkt			0xDD0D
> +#define	reg_ep5_max_pkt_pos 0
> +#define	reg_ep5_max_pkt_len 8
> +#define	reg_ep5_max_pkt_lsb 0
> +#define    p_reg_ep4_tx_en			0xDD11
> +#define	reg_ep4_tx_en_pos 5
> +#define	reg_ep4_tx_en_len 1
> +#define	reg_ep4_tx_en_lsb 0
> +#define    p_reg_ep5_tx_en			0xDD11
> +#define	reg_ep5_tx_en_pos 6
> +#define	reg_ep5_tx_en_len 1
> +#define	reg_ep5_tx_en_lsb 0
> +#define    p_reg_ep4_tx_nak			0xDD13
> +#define	reg_ep4_tx_nak_pos 5
> +#define	reg_ep4_tx_nak_len 1
> +#define	reg_ep4_tx_nak_lsb 0
> +#define    p_reg_ep5_tx_nak			0xDD13
> +#define	reg_ep5_tx_nak_pos 6
> +#define	reg_ep5_tx_nak_len 1
> +#define	reg_ep5_tx_nak_lsb 0
> +#define    p_reg_ep4_tx_len_7_0			0xDD88
> +#define	reg_ep4_tx_len_7_0_pos 0
> +#define	reg_ep4_tx_len_7_0_len 8
> +#define	reg_ep4_tx_len_7_0_lsb 0
> +#define    p_reg_ep4_tx_len_15_8		0xDD89
> +#define	reg_ep4_tx_len_15_8_pos 0
> +#define	reg_ep4_tx_len_15_8_len 8
> +#define	reg_ep4_tx_len_15_8_lsb 8
> +#define    p_reg_ep5_tx_len_7_0			0xDD8A
> +#define	reg_ep5_tx_len_7_0_pos 0
> +#define	reg_ep5_tx_len_7_0_len 8
> +#define	reg_ep5_tx_len_7_0_lsb 0
> +#define    p_reg_ep5_tx_len_15_8		0xDD8B
> +#define	reg_ep5_tx_len_15_8_pos 0
> +#define	reg_ep5_tx_len_15_8_len 8
> +#define	reg_ep5_tx_len_15_8_lsb 8
> +#define    r_reg_aagc_rf_gain			0xCFFF
> +#define	reg_aagc_rf_gain_pos 0
> +#define	reg_aagc_rf_gain_len 8
> +#define	reg_aagc_rf_gain_lsb 0
> +#define    r_reg_aagc_if_gain			0xCFFF
> +#define	reg_aagc_if_gain_pos 0
> +#define	reg_aagc_if_gain_len 8
> +#define	reg_aagc_if_gain_lsb 0
> +#define    p_reg_top_clkoen			0xCFFF
> +#define reg_top_clkoen_pos 0
> +#define reg_top_clkoen_len 1
> +#define reg_top_clkoen_lsb 0
> +#define    p_reg_top_hosta_mpeg_ser_mode	0xCFFF
> +#define reg_top_hosta_mpeg_ser_mode_pos 0
> +#define reg_top_hosta_mpeg_ser_mode_len 1
> +#define reg_top_hosta_mpeg_ser_mode_lsb 0
> +#define    p_reg_top_hosta_mpeg_par_mode	0xCFFF
> +#define reg_top_hosta_mpeg_par_mode_pos 0
> +#define reg_top_hosta_mpeg_par_mode_len 1
> +#define reg_top_hosta_mpeg_par_mode_lsb 0
> +#define    p_reg_top_hosta_dca_upper		0xCFFF
> +#define reg_top_hosta_dca_upper_pos 0
> +#define reg_top_hosta_dca_upper_len 1
> +#define reg_top_hosta_dca_upper_lsb 0
> +#define    p_reg_top_hosta_dca_lower		0xCFFF
> +#define reg_top_hosta_dca_lower_pos 0
> +#define reg_top_hosta_dca_lower_len 1
> +#define reg_top_hosta_dca_lower_lsb 0
> +
> +/*
> + * IT9135 variable defines
> + */
> +/* ----- LL variables ----- */
> +#define OVA_BASE			0x4C00	/* omega variable address base */
> +#define OVA_LINK_VERSION		(OVA_BASE-4)	/* 4 bytes */
> +#define OVA_LINK_VERSION_31_24		(OVA_LINK_VERSION+0)
> +#define OVA_LINK_VERSION_23_16		(OVA_LINK_VERSION+1)
> +#define OVA_LINK_VERSION_15_8		(OVA_LINK_VERSION+2)
> +#define OVA_LINK_VERSION_7_0		(OVA_LINK_VERSION+3)
> +#define OVA_SECOND_DEMOD_I2C_ADDR	(OVA_BASE-5)
> +#define OVA_EEPROM_CFG			(OVA_BASE-620)	/* 256 bytes */
> +#define OVA_IR_TABLE_ADDR		(OVA_BASE-363)	/* 2 bytes pointer point to IR_TABLE */
> +#define OVA_IR_TABLE_ADDR_15_18		(OVA_IR_TABLE_ADDR+0)
> +#define OVA_IR_TABLE_ADDR_7_0		(OVA_IR_TABLE_ADDR+1)
> +
> +/* For API variable name, not use in firmware */
> +#define second_i2c_address		OVA_SECOND_DEMOD_I2C_ADDR
> +#define ir_table_start_15_8		OVA_IR_TABLE_ADDR_15_18
> +#define ir_table_start_7_0		OVA_IR_TABLE_ADDR_7_0
> +#define prechip_version_7_0		0x384F
> +#define chip_version_7_0		0x1222
> +#define link_version_31_24		OVA_LINK_VERSION_31_24
> +#define link_version_23_16		OVA_LINK_VERSION_23_16
> +#define link_version_15_8		OVA_LINK_VERSION_15_8
> +#define link_version_7_0		OVA_LINK_VERSION_7_0
> +
> +/* ----- OFDM variables ----- */
> +/* 2k */
> +#define var_addr_base			0x418b
> +#define log_addr_base			0x418d
> +#define log_data_base			0x418f
> +#define LowerLocalRetra			0x43bb
> +
> +#define trigger_ofsm			0x0000
> +#define cfoe_NS_2048_coeff1_25_24	0x0001
> +#define cfoe_NS_2048_coeff1_23_16	0x0002
> +#define cfoe_NS_2048_coeff1_15_8	0x0003
> +#define cfoe_NS_2048_coeff1_7_0		0x0004
> +#define cfoe_NS_2k_coeff2_24		0x0005
> +#define cfoe_NS_2k_coeff2_23_16		0x0006
> +#define cfoe_NS_2k_coeff2_15_8		0x0007
> +#define cfoe_NS_2k_coeff2_7_0		0x0008
> +
> +/* 8k */
> +#define cfoe_NS_8191_coeff1_25_24	0x0009
> +#define cfoe_NS_8191_coeff1_23_16	0x000a
> +#define cfoe_NS_8191_coeff1_15_8	0x000b
> +#define cfoe_NS_8191_coeff1_7_0		0x000c
> +#define cfoe_NS_8192_coeff1_25_24	0x000d
> +#define cfoe_NS_8192_coeff1_23_16	0x000e
> +#define cfoe_NS_8192_coeff1_15_8	0x000f
> +#define cfoe_NS_8192_coeff1_7_0		0x0010
> +#define cfoe_NS_8193_coeff1_25_24	0x0011
> +#define cfoe_NS_8193_coeff1_23_16	0x0012
> +#define cfoe_NS_8193_coeff1_15_8	0x0013
> +#define cfoe_NS_8193_coeff1_7_0		0x0014
> +
> +#define cfoe_NS_8k_coeff2_24		0x0015
> +#define cfoe_NS_8k_coeff2_23_16		0x0016
> +#define cfoe_NS_8k_coeff2_15_8		0x0017
> +#define cfoe_NS_8k_coeff2_7_0		0x0018
> +
> +/* 4k */
> +#define cfoe_NS_4096_coeff1_25_24	0x0019
> +#define cfoe_NS_4096_coeff1_23_16	0x001a
> +#define cfoe_NS_4096_coeff1_15_8	0x001b
> +#define cfoe_NS_4096_coeff1_7_0		0x001c
> +#define cfoe_NS_4k_coeff2_24		0x001d
> +#define cfoe_NS_4k_coeff2_23_16		0x001e
> +#define cfoe_NS_4k_coeff2_15_8		0x001f
> +#define cfoe_NS_4k_coeff2_7_0		0x0020
> +
> +#define bfsfcw_fftindex_ratio_7_0	0x0021
> +#define bfsfcw_fftindex_ratio_15_8	0x0022
> +#define fftindex_bfsfcw_ratio_7_0	0x0023
> +#define fftindex_bfsfcw_ratio_15_8	0x0024
> +
> +#define crystal_clk_7_0			0x0025
> +#define crystal_clk_15_8		0x0026
> +#define crystal_clk_23_16		0x0027
> +#define crystal_clk_31_24		0x0028
> +
> +#define bfs_fcw_7_0			0x0029
> +#define bfs_fcw_15_8			0x002a
> +#define bfs_fcw_22_16			0x002b
> +
> +#define rsd_abort_packet_cnt_7_0	0x0032
> +#define rsd_abort_packet_cnt_15_8	0x0033
> +#define rsd_bit_err_cnt_7_0		0x0034
> +#define rsd_bit_err_cnt_15_8		0x0035
> +#define rsd_bit_err_cnt_23_16		0x0036
> +#define r_rsd_packet_unit_7_0		0x0037
> +#define r_rsd_packet_unit_15_8		0x0038
> +
> +#define tpsd_lock			0x003c
> +#define mpeg_lock			0x003d
> +
> +#define Training_Mode			0x0040
> +
> +#define adcx2				0x0045
> +
> +#define empty_channel_status		0x0047
> +#define signal_quality			0x0049
> +
> +#define FreBand				0x004b
> +#define suspend_flag			0x004c
> +
> +#define var_p_inband			0x00f7
> +
> +#define var_pre_lo_freq_7_0		0x011e
> +#define var_pre_lo_freq_15_8		0x011f
> +#define var_pre_lna_cap_sel		0x0120
> +
> +#define ofdm_version_31_24		0x4191
> +#define ofdm_version_23_16		0x4192
> +#define ofdm_version_15_8		0x4193
> +#define ofdm_version_7_0		0x4194
> +
> +/*
> + * Error code
> + */
> +enum it9135_err_code {
> +	ERROR_NO_ERROR = 0x00000000ul,
> +	ERROR_RESET_TIMEOUT = 0x00000001ul,
> +	ERROR_WRITE_REG_TIMEOUT = 0x00000002ul,
> +	ERROR_WRITE_TUNER_TIMEOUT = 0x00000003ul,
> +	ERROR_WRITE_TUNER_FAIL = 0x00000004ul,
> +	ERROR_RSD_COUNTER_NOT_READY = 0x00000005ul,
> +	ERROR_VTB_COUNTER_NOT_READY = 0x00000006ul,
> +	ERROR_FEC_MON_NOT_ENABLED = 0x00000007ul,
> +	ERROR_INVALID_DEV_TYPE = 0x00000008ul,
> +	ERROR_INVALID_TUNER_TYPE = 0x00000009ul,
> +	ERROR_OPEN_FILE_FAIL = 0x0000000Aul,
> +	ERROR_WRITEFILE_FAIL = 0x0000000Bul,
> +	ERROR_READFILE_FAIL = 0x0000000Cul,
> +	ERROR_CREATEFILE_FAIL = 0x0000000Dul,
> +	ERROR_MALLOC_FAIL = 0x0000000Eul,
> +	ERROR_INVALID_FILE_SIZE = 0x0000000Ful,
> +	ERROR_INVALID_READ_SIZE = 0x00000010ul,
> +	ERROR_LOAD_FW_DONE_BUT_FAIL = 0x00000011ul,
> +	ERROR_NOT_IMPLEMENTED = 0x00000012ul,
> +	ERROR_NOT_SUPPORT = 0x00000013ul,
> +	ERROR_WRITE_MBX_TUNER_TIMEOUT = 0x00000014ul,
> +	ERROR_DIV_MORE_THAN_8_CHIPS = 0x00000015ul,
> +	ERROR_DIV_NO_CHIPS = 0x00000016ul,
> +	ERROR_SUPER_FRAME_CNT_0 = 0x00000017ul,
> +	ERROR_INVALID_FFT_MODE = 0x00000018ul,
> +	ERROR_INVALID_CONSTELLATION_MODE = 0x00000019ul,
> +	ERROR_RSD_PKT_CNT_0 = 0x0000001Aul,
> +	ERROR_FFT_SHIFT_TIMEOUT = 0x0000001Bul,
> +	ERROR_WAIT_TPS_TIMEOUT = 0x0000001Cul,
> +	ERROR_INVALID_BW = 0x0000001Dul,
> +	ERROR_INVALID_BUF_LEN = 0x0000001Eul,
> +	ERROR_NULL_PTR = 0x0000001Ful,
> +	ERROR_INVALID_AGC_VOLT = 0x00000020ul,
> +	ERROR_MT_OPEN_FAIL = 0x00000021ul,
> +	ERROR_MT_TUNE_FAIL = 0x00000022ul,
> +	ERROR_CMD_NOT_SUPPORTED = 0x00000023ul,
> +	ERROR_CE_NOT_READY = 0x00000024ul,
> +	ERROR_EMBX_INT_NOT_CLEARED = 0x00000025ul,
> +	ERROR_INV_PULLUP_VOLT = 0x00000026ul,
> +	ERROR_FREQ_OUT_OF_RANGE = 0x00000027ul,
> +	ERROR_INDEX_OUT_OF_RANGE = 0x00000028ul,
> +	ERROR_NULL_SETTUNER_PTR = 0x00000029ul,
> +	ERROR_NULL_INITSCRIPT_PTR = 0x0000002Aul,
> +	ERROR_INVALID_INITSCRIPT_LEN = 0x0000002Bul,
> +	ERROR_INVALID_POS = 0x0000002Cul,
> +	ERROR_BACK_TO_BOOTCODE_FAIL = 0x0000002Dul,
> +	ERROR_GET_BUFFER_VALUE_FAIL = 0x0000002Eul,
> +	ERROR_INVALID_REG_VALUE = 0x0000002Ful,
> +	ERROR_INVALID_INDEX = 0x00000030ul,
> +	ERROR_READ_TUNER_TIMEOUT = 0x00000031ul,
> +	ERROR_READ_TUNER_FAIL = 0x00000032ul,
> +	ERROR_UNDEFINED_SAW_BW = 0x00000033ul,
> +	ERROR_MT_NOT_AVAILABLE = 0x00000034ul,
> +	ERROR_NO_SUCH_TABLE = 0x00000035ul,
> +	ERROR_WRONG_CHECKSUM = 0x00000036ul,
> +	ERROR_INVALID_XTAL_FREQ = 0x00000037ul,
> +	ERROR_COUNTER_NOT_AVAILABLE = 0x00000038ul,
> +	ERROR_INVALID_DATA_LENGTH = 0x00000039ul,
> +	ERROR_BOOT_FAIL = 0x0000003Aul,
> +	ERROR_BUFFER_INSUFFICIENT = 0x0000003Bul,
> +	ERROR_NOT_READY = 0x0000003Cul,
> +	ERROR_DRIVER_INVALID = 0x0000003Dul,
> +	ERROR_INTERFACE_FAIL = 0x0000003Eul,
> +	ERROR_PID_FILTER_FULL = 0x0000003Ful,
> +	ERROR_OPERATION_TIMEOUT = 0x00000040ul,
> +	ERROR_LOADFIRMWARE_SKIPPED = 0x00000041ul,
> +	ERROR_REBOOT_FAIL = 0x00000042ul,
> +	ERROR_PROTOCOL_FORMAT_INVALID = 0x00000043ul,
> +	ERROR_ACTIVESYNC_ERROR = 0x00000044ul,
> +	ERROR_CE_READWRITEBUS_ERROR = 0x00000045ul,
> +	ERROR_CE_NODATA_ERROR = 0x00000046ul,
> +	ERROR_NULL_FW_SCRIPT = 0x00000047ul,
> +	ERROR_NULL_TUNER_SCRIPT = 0x00000048ul,
> +	ERROR_INVALID_CHIP_TYPE = 0x00000049ul,
> +	ERROR_TUNER_TYPE_NOT_COMPATIBLE = 0x0000004Aul,
> +	/* Error Code of Gemini System */
> +	ERROR_INVALID_INDICATOR_TYPE = 0x00000101ul,
> +	ERROR_INVALID_SC_NUMBER = 0x00000102ul,
> +	ERROR_INVALID_SC_INFO = 0x00000103ul,
> +	ERROR_FIGBYPASS_FAIL = 0x00000104ul,
> +	/* Error Code of Firmware */
> +	ERROR_FIRMWARE_STATUS = 0x01000000ul,
> +	/* Error Code of I2C Module */
> +	ERROR_I2C_DATA_HIGH_FAIL = 0x02001000ul,
> +	ERROR_I2C_CLK_HIGH_FAIL = 0x02002000ul,
> +	ERROR_I2C_WRITE_NO_ACK = 0x02003000ul,
> +	ERROR_I2C_DATA_LOW_FAIL = 0x02004000ul,
> +	/* Error Code of USB Module */
> +	ERROR_USB_NULL_HANDLE = 0x03010001ul,
> +	ERROR_USB_WRITEFILE_FAIL = 0x03000002ul,
> +	ERROR_USB_READFILE_FAIL = 0x03000003ul,
> +	ERROR_USB_INVALID_READ_SIZE = 0x03000004ul,
> +	ERROR_USB_INVALID_STATUS = 0x03000005ul,
> +	ERROR_USB_INVALID_SN = 0x03000006ul,
> +	ERROR_USB_INVALID_PKT_SIZE = 0x03000007ul,
> +	ERROR_USB_INVALID_HEADER = 0x03000008ul,
> +	ERROR_USB_NO_IR_PKT = 0x03000009ul,
> +	ERROR_USB_INVALID_IR_PKT = 0x0300000Aul,
> +	ERROR_USB_INVALID_DATA_LEN = 0x0300000Bul,
> +	ERROR_USB_EP4_READFILE_FAIL = 0x0300000Cul,
> +	ERROR_USB_EP$_INVALID_READ_SIZE = 0x0300000Dul,
> +	ERROR_USB_BOOT_INVALID_PKT_TYPE = 0x0300000Eul,
> +	ERROR_USB_BOOT_BAD_CONFIG_HEADER = 0x0300000Ful,
> +	ERROR_USB_BOOT_BAD_CONFIG_SIZE = 0x03000010ul,
> +	ERROR_USB_BOOT_BAD_CONFIG_SN = 0x03000011ul,
> +	ERROR_USB_BOOT_BAD_CONFIG_SUBTYPE = 0x03000012ul,
> +	ERROR_USB_BOOT_BAD_CONFIG_VALUE = 0x03000013ul,
> +	ERROR_USB_BOOT_BAD_CONFIG_CHKSUM = 0x03000014ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_HEADER = 0x03000015ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_SIZE = 0x03000016ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_SN = 0x03000017ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_SUBTYPE = 0x03000018ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_VALUE = 0x03000019ul,
> +	ERROR_USB_BOOT_BAD_CONFIRM_CHKSUM = 0x03000020ul,
> +	ERROR_USB_BOOT_BAD_BOOT_HEADER = 0x03000021ul,
> +	ERROR_USB_BOOT_BAD_BOOT_SIZE = 0x03000022ul,
> +	ERROR_USB_BOOT_BAD_BOOT_SN = 0x03000023ul,
> +	ERROR_USB_BOOT_BAD_BOOT_PATTERN_01 = 0x03000024ul,
> +	ERROR_USB_BOOT_BAD_BOOT_PATTERN_10 = 0x03000025ul,
> +	ERROR_USB_BOOT_BAD_BOOT_CHKSUM = 0x03000026ul,
> +	ERROR_USB_INVALID_BOOT_PKT_TYPE = 0x03000027ul,
> +	ERROR_USB_BOOT_BAD_CONFIG_VAlUE = 0x03000028ul,
> +	ERROR_USB_COINITIALIZEEX_FAIL = 0x03000029ul,
> +	ERROR_USB_COCREATEINSTANCE_FAIL = 0x0300003Aul,
> +	ERROR_USB_COCREATCLSEENUMERATOR_FAIL = 0x0300002Bul,
> +	ERROR_USB_QUERY_INTERFACE_FAIL = 0x0300002Cul,
> +	ERROR_USB_PKSCTRL_NULL = 0x0300002Dul,
> +	ERROR_USB_INVALID_REGMODE = 0x0300002Eul,
> +	ERROR_USB_INVALID_REG_COUNT = 0x0300002Ful,
> +	ERROR_USB_INVALID_HANDLE = 0x03000100ul,
> +	ERROR_USB_WRITE_FAIL = 0x03000200ul,
> +	ERROR_USB_UNEXPECTED_WRITE_LEN = 0x03000300ul,
> +	ERROR_USB_READ_FAIL = 0x03000400ul,
> +	/* Error code of Omega */
> +	ERROR_TUNER_INIT_FAIL = 0x05000000ul
> +};

Please, don't create your own error space. Error codes on Linux are well
defined, and specified at the DVB API spec. For example, the generic
error codes are:
	http://linuxtv.org/downloads/v4l-dvb-apis/gen_errors.html#gen-errors

And some ioctl's also device special meanings for some error codes, like:
http://linuxtv.org/downloads/v4l-dvb-apis/frontend_fcalls.html#FE_SET_FRONTEND


> +
> +enum it9135_tuner_id {
> +	/* 0x50~0x5f reserved for OMEGA use */
> +	IT9135_TUNER_ID = 0x38,
> +	IT9135_TUNER_ID_LNA_CONFIG1 = 0x51,
> +	IT9135_TUNER_ID_LNA_CONFIG2 = 0x52,
> +	/* 0x60~0x6f reserved for OMEGA V2 use */
> +	IT9135_TUNER_ID_V2 = 0x60,
> +	IT9135_TUNER_ID_V2_LNA_CONFIG1 = 0x61,
> +	IT9135_TUNER_ID_V2_LNA_CONFIG2 = 0x62
> +};
> +
> +enum it9135_tuner_lna {
> +	OMEGA_NORMAL = 0x00,
> +	OMEGA_LNA_CONFIG1 = 0x01,
> +	OMEGA_LNA_CONFIG2 = 0x02,
> +};
> +
> +struct it9135_val_set {
> +	unsigned long address;	/* The address of target register */
> +	unsigned char value;	/* The value of target register   */
> +};
> +
> +struct it9135_tuner_desc {
> +	struct it9135_val_set *scripts;
> +	unsigned short *script_sets;
> +	unsigned short id;
> +};
> +
> +/*
> + * The type defination of clock table.
> + */
> +struct it9135_freq_clk {
> +	unsigned long crystal_Freq;	/* The frequency of crystal. */
> +	unsigned long adc_freq;	/* The frequency of ADC.     */
> +};
> +
> +#define IT9135_MAX_PKT_SIZE	255
> +
> +/* Define commands */
> +enum it9135_cmd {
> +	CMD_REG_DEMOD_READ = 0x0000,
> +	CMD_REG_DEMOD_WRITE = 0x0001,
> +	CMD_REG_EEPROM_READ = 0x0004,
> +	CMD_REG_EEPROM_WRITE = 0x0005,
> +	CMD_IR_GET = 0x0018,
> +	CMD_FW_DOWNLOAD = 0x0021,
> +	CMD_QUERYINFO = 0x0022,
> +	CMD_BOOT = 0x0023,
> +	CMD_REBOOT = 0x0023,
> +	CMD_FW_DOWNLOAD_BEGIN = 0x0024,
> +	CMD_FW_DOWNLOAD_END = 0x0025,
> +	CMD_SCATTER_WRITE = 0x0029,
> +	CMD_GENERIC_READ = 0x002A,
> +	CMD_GENERIC_WRITE = 0x002B
> +};
> +
> +#define it9135_build_command(command, processor, chip) \
> +		(command + (unsigned short) (processor << 12) + (unsigned short) (chip << 12))
> +
> +/*
> + * The type defination of channel Statistic.
> + */
> +struct it9135_ch_statistic {
> +	unsigned short abort_cnt;
> +	unsigned long post_vitbit_cnt;
> +	unsigned long post_vit_err_cnt;
> +};
> +
> +/*
> + * The type defination of Segment
> + */
> +struct it9135_segment {
> +	unsigned char type;	/* 0:Firmware download 1:Rom copy 2:Direct command */
> +	unsigned long length;
> +};
> +
> +/*
> + * The type defination of TransmissionMode.
> + */
> +enum it9135_transmission_modes {
> +	TransmissionMode_2K = 0,	/* OFDM frame consists of 2048 different carriers (2K FFT mode) */
> +	TransmissionMode_8K,	/* OFDM frame consists of 8192 different carriers (8K FFT mode) */
> +	TransmissionMode_4K	/* OFDM frame consists of 4096 different carriers (4K FFT mode) */
> +};
> +
> +/*
> + * The type defination of Priority.
> + */
> +enum it9135_priority {
> +	PRIORITY_HIGH = 0,	/* DVB-T and DVB-H - identifies high-priority stream */
> +	PRIORITY_LOW		/* DVB-T and DVB-H - identifies low-priority stream  */
> +};
> +
> +/*
> + * The type defination of CodeRate.
> + */
> +enum it9135_code_rate {
> +	CodeRate_1_OVER_2 = 0,	/* Signal uses FEC coding ratio of 1/2 */
> +	CodeRate_2_OVER_3,	/* Signal uses FEC coding ratio of 2/3 */
> +	CodeRate_3_OVER_4,	/* Signal uses FEC coding ratio of 3/4 */
> +	CodeRate_5_OVER_6,	/* Signal uses FEC coding ratio of 5/6 */
> +	CodeRate_7_OVER_8,	/* Signal uses FEC coding ratio of 7/8 */
> +	CodeRate_NONE		/* None, NXT doesn't have this one     */
> +};
> +
> +/*
> + * TPS Hierarchy and Alpha value.
> + */
> +enum it9135_hierarchy {
> +	Hierarchy_NONE = 0,	/* Signal is non-hierarchical        */
> +	Hierarchy_ALPHA_1,	/* Signalling format uses alpha of 1 */
> +	Hierarchy_ALPHA_2,	/* Signalling format uses alpha of 2 */
> +	Hierarchy_ALPHA_4	/* Signalling format uses alpha of 4 */
> +};
> +
> +/*
> + * The type defination of Multiplier.
> + */
> +enum it9135_multiplier {
> +	Multiplier_1X = 0,
> +	Multiplier_2X
> +};
> +
> +/*
> + * The type defination of StreamType.
> + */
> +enum it9135_stream_type {
> +	STREAM_TYPE_NONE = 0,	/* Invalid (Null) StreamType                */
> +	STREAM_TYPE_DVBT_DATAGRAM = 3,	/* DVB-T mode, store data in device buffer  */
> +	STREAM_TYPE_DVBT_PARALLEL,	/* DVB-T mode, output via paralle interface */
> +	STREAM_TYPE_DVBT_SERIAL,	/* DVB-T mode, output via serial interface  */
> +};
> +
> +/*
> + * The type defination of Architecture.
> + */
> +enum it9135_architecture {
> +	ARCHITECTURE_NONE = 0,	/* Inavalid (Null) Architecture.                                    */
> +	ARCHITECTURE_DCA,	/* Diversity combine architecture. Only valid when chip number > 1. */
> +	ARCHITECTURE_PIP	/* Picture in picture. Only valid when chip number > 1.             */
> +};
> +
> +/*
> + * The type defination of processor.
> + */
> +enum it9135_processor {
> +	PROCESSOR_LINK = 0,
> +	PROCESSOR_OFDM = 8
> +};
> +
> +/*
> + * The type defination of Constellation.
> + */
> +enum Constellation {
> +	CONSTELLATION_QPSK = 0,	/* Signal uses QPSK constellation  */
> +	CONSTELLATION_16QAM,	/* Signal uses 16QAM constellation */
> +	CONSTELLATION_64QAM	/* Signal uses 64QAM constellation */
> +};
> +
> +/*
> + * The defination of ChannelModulation.
> + */
> +struct it9135_ch_modulation {
> +	unsigned long frequency;	/* Channel frequency in KHz.                                */
> +	unsigned char trans_mode;	/* Number of carriers used for OFDM signal                  */
> +	unsigned char constellation;	/* Constellation scheme (FFT mode) in use           */
> +	unsigned char interval;	/* Fraction of symbol length used as guard (Guard Interval) */
> +	unsigned char priority;	/* The priority of stream                                   */
> +	unsigned char h_code_rate;	/* FEC coding ratio of high-priority stream                 */
> +	unsigned char l_code_rate;	/* FEC coding ratio of low-priority stream                  */
> +	unsigned char hierarchy;	/* Hierarchy levels of OFDM signal                          */
> +	unsigned char bandwidth;
> +};
> +
> +/*
> + * The type defination of Statistic.
> + */
> +struct it9135_statistic {
> +	int presented;		/* Signal is presented.                           */
> +	int locked;		/* Signal is locked.                              */
> +	unsigned char quality;	/* Signal quality, from 0 (poor) to 100 (good).   */
> +	unsigned char strength;	/* Signal strength from 0 (weak) to 100 (strong). */
> +};
> +
> +/*
> + * The type defination of PidTable
> + */
> +struct it9135_pid_tab {
> +	unsigned short pid[32];
> +};
> +
> +struct it9135_pid_info {
> +	struct it9135_pid_tab pid_tab[2];
> +	unsigned char pid_cnt;
> +	int pid_init;
> +};
> +
> +/*
> + * The data structure of IT9135
> + */
> +struct it9135_data {
> +	/* Basic structure */
> +	void *driver;
> +
> +/* Bus types */
> +#define IT9135_BUS_USB20	2
> +#define IT9135_BUS_USB11           5
> +	unsigned short busId;
> +
> +	unsigned short tuner_id;
> +	struct it9135_tuner_desc tuner_desc;
> +
> +	unsigned char *fw_codes;
> +	struct it9135_segment *fw_segs;	/* FW seqments */
> +	unsigned char fw_parts;	/* FW partitions */
> +	unsigned short *script_sets;
> +	struct it9135_val_set *scripts;
> +	unsigned short *tuner_script_sets;
> +	struct it9135_val_set *tuner_scripts;
> +
> +	const struct firmware *it9135_fw;
> +	unsigned char chip_ver;
> +	unsigned long chip_type;
> +	unsigned char chip_num;
> +	unsigned char streamType;
> +	unsigned char architecture;
> +	unsigned long crystal_Freq;
> +	unsigned long adc_freq;
> +	unsigned short bandwidth[2];
> +	unsigned long frequency[2];
> +	unsigned long fcw;
> +	struct it9135_statistic statistic[2];
> +	struct it9135_ch_statistic ch_statistic[2];	/* releaseExternalRemove */
> +	unsigned char host_if[2];	/* Host Interface */
> +	unsigned char cmd_seq;	/* command sequence */
> +	struct it9135_pid_info pid_info;
> +	unsigned char pre_sqi;
> +
> +	int booted;
> +	int inited;
> +
> +	unsigned char clock_mode;
> +	unsigned int fxtal_khz;
> +	unsigned int fdiv;
> +
> +	/* for linux kernel driver */
> +	struct it9135_val_set *tuner_script_normal;
> +	unsigned short tuner_script_sets_normal;
> +	struct it9135_val_set *tuner_script_lna1;
> +	unsigned short tuner_script_sets_lna1;
> +	struct it9135_val_set *tuner_script_lna2;
> +	unsigned short tuner_script_sets_lna2;
> +};
> +
> +#define REG_MASK(mask, pos, len)		(mask[len-1] << pos)
> +#define REG_CLEAR(mask, temp, pos, len)		(temp & (~REG_MASK(mask, pos, len)))
> +#define REG_CREATE(mask, val, temp, pos, len)	((val << pos) | (REG_CLEAR(mask, temp, pos, len)))
> +#define REG_GET(mask, value, pos, len)		((value & REG_MASK(mask, pos, len)) >> pos)
> +#define LOWBYTE(w)				((unsigned char)((w) & 0xff))
> +#define HIGHBYTE(w)				((unsigned char)((w >> 8) & 0xff))
> +
> +struct it9135_coeff_param {
> +	unsigned long adc_freq;
> +	unsigned short bandwidth;
> +	unsigned long coeff1_2048Nu;
> +	unsigned long coeff1_4096Nu;
> +	unsigned long coeff1_8191Nu;
> +	unsigned long coeff1_8192Nu;
> +	unsigned long coeff1_8193Nu;
> +	unsigned long coeff2_2k;
> +	unsigned long coeff2_4k;
> +	unsigned long coeff2_8k;
> +	unsigned short bfsfcw_fftindex_ratio;
> +	unsigned short fftindex_bfsfcw_ratio;
> +};
> +
> +/*
> + * Write one unsigned char (8 bits) to a specific register in IT9135.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the address of the register to be written.
> + * @param value: the value to be written.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_write_reg(struct it9135_data *data, unsigned char chip,
> +			       unsigned char processor, unsigned long reg_addr,
> +			       unsigned char value);
> +
> +/*
> + * Write a sequence of unsigned chars to the contiguous registers in IT9135.
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 5.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the start address of the registers to be written.
> + * @param post_err_cnt: the number of registers to be written.
> + * @param buffer: a unsigned char array which is used to store values to be written.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_write_regs(struct it9135_data *data, unsigned char chip,
> +				unsigned char processor, unsigned long reg_addr,
> +				unsigned long w_buff_len,
> +				unsigned char *w_buff);
> +
> +/*
> + * Write a sequence of unsigned chars to the contiguous registers in slave device
> + * through specified interface (1, 2, 3).
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 6 (one more unsigned char to specify tuner address).
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param interfaceIndex: the index of interface. The possible values are 1~3.
> + * @param slaveAddress: the I2c address of slave device.
> + * @param post_err_cnt: the number of registers to be read.
> + * @param buffer: a unsigned char array which is used to store values to be read.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_write_gen_regs(struct it9135_data *data,
> +				    unsigned char chip,
> +				    unsigned char interfaceIndex,
> +				    unsigned char slaveAddress,
> +				    unsigned char post_err_cnt,
> +				    unsigned char *buffer);
> +
> +/*
> + * Write a sequence of unsigned chars to the contiguous cells in the EEPROM.
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 5 (firmware will detect EEPROM address).
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param reg_addr: the start address of the cells to be written.
> + * @param post_err_cnt: the number of cells to be written.
> + * @param buffer: a unsigned char array which is used to store values to be written.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_write_ee_vals(struct it9135_data *data, unsigned char chip,
> +				   unsigned short reg_addr,
> +				   unsigned char w_buff_len,
> +				   unsigned char *w_buff);
> +
> +/*
> + * Modify bits in the specific register.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the address of the register to be written.
> + * @param position: the start position of bits to be modified (0 means the
> + *        LSB of the specifyed register).
> + * @param length: the length of bits.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_write_reg_bits(struct it9135_data *data,
> +				    unsigned char chip, unsigned char processor,
> +				    unsigned long reg_addr,
> +				    unsigned char position,
> +				    unsigned char length, unsigned char value);
> +
> +/*
> + * Read one unsigned char (8 bits) from a specific register in IT9135.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the address of the register to be read.
> + * @param value: the pointer used to store the value read from IT9135 register.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_read_reg(struct it9135_data *data, unsigned char chip,
> +			      unsigned char processor, unsigned long reg_addr,
> +			      unsigned char *value);
> +
> +/*
> + * Read a sequence of unsigned chars from the contiguous registers in IT9135.
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 5.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the address of the register to be read.
> + * @param post_err_cnt: the number of registers to be read.
> + * @param buffer: a unsigned char array which is used to store values to be read.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_read_regs(struct it9135_data *data, unsigned char chip,
> +			       unsigned char processor, unsigned long reg_addr,
> +			       unsigned long r_buff_len, unsigned char *r_buff);
> +
> +/*
> + * Read a sequence of unsigned chars from the contiguous registers in slave device
> + * through specified interface (1, 2, 3).
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 6 (one more unsigned char to specify tuner address).
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param interfaceIndex: the index of interface. The possible values are 1~3.
> + * @param slaveAddress: the I2c address of slave device.
> + * @param post_err_cnt: the number of registers to be read.
> + * @param buffer: a unsigned char array which is used to store values to be read.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_read_gen_regs(struct it9135_data *data,
> +				   unsigned char chip,
> +				   unsigned char interfaceIndex,
> +				   unsigned char slaveAddress,
> +				   unsigned char post_err_cnt,
> +				   unsigned char *buffer);
> +
> +/*
> + * Read a sequence of unsigned chars from the contiguous cells in the EEPROM.
> + * The maximum burst size is restricted by the capacity of bus. If bus
> + * could transfer N unsigned chars in one cycle, then the maximum value of
> + * post_err_cnt would be N - 5 (firmware will detect EEPROM address).
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + * @param reg_addr the start address of the cells to be read.
> + * @param registerAddressLength the valid unsigned chars of reg_addr.
> + * @param post_err_cnt the number of cells to be read.
> + * @param buffer a unsigned char array which is used to store values to be read.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_read_ee_vals(struct it9135_data *data, unsigned char chip,
> +				  unsigned short reg_addr,
> +				  unsigned char r_buff_len,
> +				  unsigned char *r_buff);
> +
> +/*
> + * Read bits of the specified register.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param processor: The processor of specified register. Because each chip
> + *        has two processor so user have to specify the processor. The
> + *        possible values are PROCESSOR_LINK and PROCESSOR_OFDM.
> + * @param reg_addr: the address of the register to be read.
> + * @param position: the start position of bits to be read (0 means the
> + *        LSB of the specifyed register).
> + * @param length: the length of bits.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_read_reg_bits(struct it9135_data *data,
> +				   unsigned char chip, unsigned char processor,
> +				   unsigned long reg_addr,
> +				   unsigned char position, unsigned char length,
> +				   unsigned char *value);
> +
> +/*
> + * Get the version of firmware.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param version: the version of firmware.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_fw_ver(struct it9135_data *data,
> +				unsigned char processor,
> +				unsigned long *version);
> +
> +/*
> + * Get siganl strength Indication.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param strength: The value of signal strength that calculations of "score mapping" from the signal strength (dBm) to the "0-100" scoring.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_strength(struct it9135_data *data, unsigned char chip,
> +				  unsigned char *strength);
> +
> +/*
> + * Get signal strength in dbm
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param rfpullUpVolt_X10: the pullup voltag of RF multiply 10.
> + * @param ifpullUpVolt_X10: the pullup voltag of IF multiply 10.
> + * @param strengthDbm: The value of signal strength in DBm.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_strength_dbm(struct it9135_data *data,
> +				      unsigned char chip, long *strength_dbm);
> +
> +/*
> + * Load the IR table for USB device.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param tab_len: The length of IR table.
> + * @param table: The content of IR table.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_load_ir_tab(struct it9135_data *data,
> +				 unsigned short tab_len, unsigned char *table);
> +
> +/*
> + * First, download firmware from host to IT9135. Actually, firmware is
> + * put in firmware.h as a part of source code. Therefore, in order to
> + * update firmware the host have to re-compile the source code.
> + * Second, setting all parameters which will be need at the beginning.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip_num: The total number of IT9135s.
> + * @param saw_band: SAW filter bandwidth in MHz. The possible values
> + *        are 6000, 7000, and 8000 (KHz).
> + * @param streamType: The format of output stream.
> + * @param architecture: the architecture of IT9135.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_dev_init(struct it9135_data *data, unsigned char chip_num,
> +			      unsigned short saw_band, unsigned char streamType,
> +			      unsigned char architecture);
> +
> +/*
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_tps_locked(struct it9135_data *data, unsigned char chip,
> +				int *locked);
> +
> +/*
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_mp2_locked(struct it9135_data *data, unsigned char chip,
> +				int *locked);
> +
> +/*
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param locked: the result of frequency tuning. 1 if there is
> + *        IT9135 can lock signal, 0 otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_freq_locked(struct it9135_data *data, unsigned char chip,
> +				 int *locked);
> +
> +/*
> + * Get channel modulation related information.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param ch_modul: The modulation of channel.
> + * @return ERROR_NO_ERROR: successful, other non-zero error code otherwise.
> + */
> +unsigned long it9135_get_ch_modulation(struct it9135_data *data,
> +				       unsigned char chip,
> +				       struct it9135_ch_modulation *ch_modul);
> +
> +/*
> + * Specify the bandwidth of channel and tune the channel to the specific
> + * frequency. Afterwards, host could use output parameter dvbH to determine
> + * if there is a DVB-H signal.
> + * In DVB-T mode, after calling this function the output parameter dvbH
> + * should return 0 and host could use output parameter "locked" to check
> + * if the channel has correct TS output.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + *        NOTE: When the architecture is set to ARCHITECTURE_DCA
> + *        this parameter is regard as don't care.
> + * @param bandwidth: The channel bandwidth.
> + *        DVB-T: 5000, 6000, 7000, and 8000 (KHz).
> + * @param frequency: the channel frequency in KHz.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_acquire_ch(struct it9135_data *data, unsigned char chip,
> +				unsigned short bandwidth,
> +				unsigned long frequency);
> +
> +/*
> + * Set the output stream type of chip. Because the device could output in
> + * many stream type, therefore host have to choose one type before receive data.
> + *
> + * Note: Please refer to the example of Standard_acquireChannel when host want
> + *       to detect the available channels.
> + * Note: After host know all the available channels, and want to change to
> + *       specific channel, host have to choose output mode before receive
> + *       data. Please refer the example of it9135_set_stream_type.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param streamType: the possible values are
> + *        DVB-T:    STREAM_TYPE_DVBT_DATAGRAM
> + *                  STREAM_TYPE_DVBT_PARALLEL
> + *                  STREAM_TYPE_DVBT_SERIAL
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_set_stream_type(struct it9135_data *data,
> +				     unsigned char streamType);
> +
> +/*
> + * Set the architecture of chip. When two of our device are using, they could
> + * be operated in Diversity Combine Architecture (DCA) or (PIP). Therefore,
> + * host could decide which mode to be operated.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param architecture: the possible values are
> + *        ARCHITECTURE_DCA
> + *        ARCHITECTURE_PIP
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_set_arch(struct it9135_data *data,
> +			      unsigned char architecture);
> +
> +/*
> + * Get the statistic values of IT9135, it includes Pre-Viterbi BER,
> + * Post-Viterbi BER, Abort Count, Signal Presented Flag, Signal Locked Flag,
> + * Signal Quality, Signal Strength, Delta-T for DVB-H time slicing.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param statistic: the structure that store all statistic values.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_statistic(struct it9135_data *data, unsigned char chip,
> +				   struct it9135_statistic *statistic);
> +
> +/*
> + * @param it9135_data: the handle of IT9135.
> + * @param code: the value of IR raw code, the size should be 4 or 6,
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_get_ir_code(struct it9135_data *data, unsigned long *code);
> +
> +/*
> + * Return to boot code
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_dev_reboot(struct it9135_data *data);
> +
> +/*
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param contorl: 1: Power up, 0: Power down;
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_ctrl_pw_saving(struct it9135_data *data,
> +				    unsigned char chip, unsigned char control);
> +
> +/*
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param contorl: 1: Power up, 0: Power down;
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_ctrl_tuner_leakage(struct it9135_data *data,
> +					unsigned char chip,
> +					unsigned char control);
> +
> +/*
> + * @param it9135_data: the handle of IT9135.
> + * @param contorl: 1: Power up, 0: Power down;
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_ctrl_tuner_pw_saving(struct it9135_data *data,
> +					  unsigned char chip,
> +					  unsigned char control);
> +
> +/*
> + * Control PID fileter
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param contorl: 0: Disable, 1: Enable.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_ctrl_pid_filter(struct it9135_data *data,
> +				     unsigned char chip, unsigned char control);
> +
> +/*
> + * Reset PID filter.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_reset_pid_filter(struct it9135_data *data,
> +				      unsigned char chip);
> +
> +/*
> + * Add PID to PID filter.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param pid: the PID that will be add to PID filter.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_add_pid_filter(struct it9135_data *data,
> +				    unsigned char chip, unsigned char index,
> +				    unsigned short pid);
> +
> +/*
> + * get SNR .
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param snr (db).
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_snr(struct it9135_data *data, unsigned char chip,
> +			     unsigned char *snr);
> +
> +/*
> + * get SNR data .
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param snr_value (hex).
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_snr_val(struct it9135_data *IT9135, unsigned char chip,
> +				 unsigned long *snr_value);
> +
> +/*
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param multiplier: ADC frequency multiplier;
> + * @return ERROR_NO_ERROR: successful, other non-zero error code otherwise.
> + * @example <pre>
> + * </pre>
> + */
> +unsigned long it9135_set_multiplier(struct it9135_data *data,
> +				    unsigned char multiplier);
> +
> +/*
> + * Reset PID filter.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_reset_pid(struct it9135_data *data, unsigned char chip);
> +
> +/*
> + * Remove PID from PID filter by index.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param index: the index of PID filter.
> + * @param pid: the PID that will be remove from PID filter.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_remove_pid_at(struct it9135_data *data, unsigned char chip,
> +				   unsigned char index, unsigned short pid);
> +
> +/*
> + * Get the statistic values of IT9135, it includes Pre-Viterbi BER,
> + * Post-Viterbi BER, Abort Count, Signal Presented Flag, Signal Locked Flag,
> + * Signal Quality, Signal Strength, Delta-T for DVB-H time slicing.
> + *
> + * @param struct it9135_data the handle of IT9135.
> + * @param chip The index of IT9135. The possible values are 0~7.
> + * @param statistic the structure that store all statistic values.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_get_ch_statistic(struct it9135_data *data,
> +				      unsigned char chip,
> +				      struct it9135_ch_statistic *ch_statistic);
> +
> +/*
> + * Set control bus and tuner.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param busId: The ID of bus.
> + * @param tuner_id: The ID of tuner.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_set_bus_tuner(struct it9135_data *data,
> +				   unsigned short busId,
> +				   unsigned short tuner_id);
> +
> +/*
> + * Add PID to PID filter.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param pid: the PID that will be add to PID filter.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_add_pid(struct it9135_data *data, unsigned char chip,
> +			     unsigned short pid);
> +
> +/*
> + * Add PID to PID filter by index.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param index: the index of PID filter.
> + * @param pid: the PID that will be add to PID filter.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_add_pid_at(struct it9135_data *data, unsigned char chip,
> +				unsigned char index, unsigned short pid);
> +
> +/*
> + * Remove PID from PID filter.
> + *
> + * @param it9135_data: the handle of IT9135.
> + * @param chip: The index of IT9135. The possible values are 0~7.
> + * @param pid: the PID that will be remove from PID filter.
> + * @return ERROR_NO_ERROR: successful, non-zero error code otherwise.
> + */
> +unsigned long it9135_remove_pid(struct it9135_data *data, unsigned char chip,
> +				unsigned short pid);
> +
> +#endif
> diff --git a/drivers/media/dvb/dvb-usb/it9135.c b/drivers/media/dvb/dvb-usb/it9135.c
> new file mode 100644
> index 0000000..7fa21c7
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/it9135.c
> @@ -0,0 +1,2492 @@
> +/*
> + * DVB USB Linux driver for IT9135 DVB-T USB2.0 receiver
> + *
> + * Copyright (C) 2011 ITE Technologies, INC.
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + */
> +
> +#include "it9135.h"
> +
> +int dvb_usb_it9135_debug;
> +module_param_named(debug, dvb_usb_it9135_debug, int, 0644);
> +MODULE_PARM_DESC(debug,
> +		 "set debugging level.(func=1,info=2,warning=4)"
> +		 DVB_USB_DEBUG_STATUS);
> +DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> +
> +struct dvb_usb_device_properties it9135_properties[];
> +
> +static unsigned long it9135_drv_nim_reset(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	/* Set AF0350 GPIOH1 to 0 to reset AF0351 */
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh1_en,
> +				  reg_top_gpioh1_en_pos, reg_top_gpioh1_en_len,
> +				  1);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh1_on, reg_top_gpioh1_on_pos,
> +				  reg_top_gpioh1_on_len, 1);
> +
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh1_o,
> +				  reg_top_gpioh1_o_pos, reg_top_gpioh1_o_len,
> +				  1);
> +	mdelay(50);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh1_o,
> +				  reg_top_gpioh1_o_pos, reg_top_gpioh1_o_len,
> +				  0);
> +	mdelay(50);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh1_o,
> +				  reg_top_gpioh1_o_pos, reg_top_gpioh1_o_len,
> +				  1);
> +
> +	return error;
> +}
> +
> +/* Write NIMSuspend Register */
> +static unsigned long it9135_drv_init_nim_suspend_regs(struct it9135_dev_ctx
> +						      *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh5_en,
> +				  reg_top_gpioh5_en_pos, reg_top_gpioh5_en_len,
> +				  1);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh5_on, reg_top_gpioh5_on_pos,
> +				  reg_top_gpioh5_on_len, 1);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh5_o, reg_top_gpioh5_o_pos,
> +				  reg_top_gpioh5_o_len, 0);
> +	mdelay(10);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 1, PROCESSOR_LINK,
> +				  p_reg_top_pwrdw, reg_top_pwrdw_pos,
> +				  reg_top_pwrdw_len, 1);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 1, PROCESSOR_LINK,
> +				  p_reg_top_pwrdw_hwen, reg_top_pwrdw_hwen_pos,
> +				  reg_top_pwrdw_hwen_len, 1);
> +
> +	return error;
> +}
> +
> +/* Get OFDM /LINK Firmware version */
> +static unsigned long it9135_drv_get_firmware_version_from_file(struct
> +							       it9135_dev_ctx
> +							       *dev,
> +							       unsigned char
> +							       processor,
> +							       unsigned long
> +							       *version)
> +{
> +	if (processor == PROCESSOR_OFDM) {
> +		*version = dev->ofdm_ver;
> +	} else {		/* LINK */
> +		*version = dev->link_ver;
> +	}
> +
> +	return *version;
> +}
> +
> +static unsigned long it9135_drv_disable_gpio_pins(struct it9135_dev_ctx *dev)
> +{
> +	/* For strapping, gpioh1/gpioh5/ghioh7 have been program, just IT9135; */
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh1_en,
> +				  reg_top_gpioh1_en_pos, reg_top_gpioh1_en_len,
> +				  0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh1_on, reg_top_gpioh1_on_pos,
> +				  reg_top_gpioh1_on_len, 0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh5_en, reg_top_gpioh5_en_pos,
> +				  reg_top_gpioh5_en_len, 0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh5_on, reg_top_gpioh5_on_pos,
> +				  reg_top_gpioh5_on_len, 0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh7_en, reg_top_gpioh7_en_pos,
> +				  reg_top_gpioh7_en_len, 0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh7_on, reg_top_gpioh7_on_pos,
> +				  reg_top_gpioh7_on_len, 0);
> +
> +	if (error)
> +		err("it9135_drv_disable_gpio_pins failed !!!\n");
> +
> +	return error;
> +}
> +
> +/* Device initialize or not */
> +static unsigned long it9135_drv_initialize(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long file_ver, cmd_ver = 0;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	if (dev->data.booted) {
> +		error =
> +		    it9135_drv_get_firmware_version_from_file(dev,
> +							      PROCESSOR_OFDM,
> +							      &file_ver);
> +
> +		/* Use "Command_QUERYINFO" to get fw version */
> +		error = it9135_get_fw_ver(&dev->data, PROCESSOR_OFDM, &cmd_ver);
> +		if (error)
> +			err("it9135_drv_initialize : it9135_get_fw_ver : error = 0x%08lx", (long unsigned int)error);
> +
> +		if (cmd_ver != file_ver) {
> +			deb_info
> +			    ("Reboot: Outside Fw = 0x%lX, Inside Fw = 0x%lX",
> +			     (long unsigned int)file_ver,
> +			     (long unsigned int)cmd_ver);
> +
> +			/* Patch for 2 chips reboot; */
> +			if (dev->data.chip_num == 2)
> +				it9135_drv_disable_gpio_pins(dev);
> +
> +			error = it9135_dev_reboot(&dev->data);
> +			dev->boot_code = 1;
> +			if (error) {
> +				err("it9135_dev_reboot : error = 0x%08lx",
> +				    (long unsigned int)error);
> +				return error;
> +			} else {
> +				return ERROR_NOT_READY;
> +			}
> +		} else {
> +			deb_info("Fw version is the same!\n");
> +			error = ERROR_NO_ERROR;
> +		}
> +	}
> +
> +	error =
> +	    it9135_dev_init(&dev->data, dev->data.chip_num, 8000,
> +			    dev->stream_type, dev->architecture);
> +	if (error)
> +		err("it9135_drv_initialize fail : 0x%08lx",
> +		    (long unsigned int)error);
> +	else
> +		deb_info("it9135_drv_initialize Ok!!");
> +
> +	it9135_get_fw_ver(&dev->data, PROCESSOR_OFDM, &cmd_ver);
> +	deb_info("FwVer OFDM = 0x%lX,", (long unsigned int)cmd_ver);
> +	it9135_get_fw_ver(&dev->data, PROCESSOR_LINK, &cmd_ver);
> +	deb_info("FwVer LINK = 0x%lX\n", (long unsigned int)cmd_ver);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_nim_reset_seq(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char bootbuffer[6];
> +
> +	/* checksum = 0xFEDC */
> +	bootbuffer[0] = 0x05;
> +	bootbuffer[1] = 0x00;
> +	bootbuffer[2] = 0x23;
> +	bootbuffer[3] = 0x01;
> +	bootbuffer[4] = 0xFE;
> +	bootbuffer[5] = 0xDC;
> +
> +	/* GPIOH5 init */
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0,
> +				  PROCESSOR_LINK, p_reg_top_gpioh5_en,
> +				  reg_top_gpioh5_en_pos, reg_top_gpioh5_en_len,
> +				  0);
> +	error =
> +	    it9135_write_reg_bits(&dev->data, 0, PROCESSOR_LINK,
> +				  p_reg_top_gpioh5_on, reg_top_gpioh5_on_pos,
> +				  reg_top_gpioh5_on_len, 0);
> +
> +	error = it9135_drv_nim_reset(dev);
> +	error = it9135_drv_init_nim_suspend_regs(dev);
> +	error =
> +	    it9135_write_gen_regs(&dev->data, 0, 0x01, 0x3a, 0x06, bootbuffer);
> +	error =
> +	    it9135_read_gen_regs(&dev->data, 0, 0x01, 0x3a, 0x05, bootbuffer);
> +
> +	mdelay(50);		/* Delay for Fw boot */
> +
> +	/* Demod & Tuner init */
> +	error = it9135_drv_initialize(dev);
> +
> +	return error;
> +}
> +
> +/************** DRV_ *************/
> +static unsigned long it9135_drv_ir_table_download(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	struct file *filp;
> +	unsigned char buff[512];
> +	int file_sz;
> +	mm_segment_t oldfs;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	oldfs = get_fs();
> +	set_fs(KERNEL_DS);
> +	filp = filp_open("/lib/firmware/af35irtbl.bin", O_RDWR, 0644);


No! Please use the standard request_firmware() call, instead of implementing it
by hand.


> +
> +	if (IS_ERR(filp)) {
> +		deb_warning("LoadIrTable : Can't open file\n");
> +		goto exit;
> +	}
> +
> +	if ((filp->f_op) == NULL) {
> +		deb_warning("LoadIrTable : File Operation Method Error!!\n");
> +		goto exit;
> +	}
> +
> +	filp->f_pos = 0x00;
> +	file_sz = filp->f_op->read(filp, buff, sizeof(buff), &filp->f_pos);
> +
> +	error =
> +	    it9135_load_ir_tab((struct it9135_data *)&dev->data,
> +			       (unsigned short)file_sz, buff);
> +	if (error) {
> +		err("it9135_load_ir_tab fail");
> +		goto exit;
> +	}
> +
> +	filp_close(filp, NULL);
> +	set_fs(oldfs);
> +
> +	return error;
> +
> +exit:
> +	deb_warning("LoadIrTable fail!\n");
> +	return error;
> +}
> +
> +/* Set tuner Frequency and BandWidth */
> +static unsigned long it9135_drv_set_freq_bw(struct it9135_dev_ctx *dev,
> +					    unsigned char chip,
> +					    unsigned long freq,
> +					    unsigned short bw)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long temp_freq = freq;
> +	unsigned short temp_bw = bw;
> +
> +	deb_func("Enter %s Function -\n ", __func__);
> +	deb_info("chip = %d, Freq= %ld, BW=%d\n", chip, (long int)freq, bw);
> +
> +	if (dev->fc[chip].en_pid) {
> +		/* Disable PID filter */
> +		it9135_write_reg_bits(&dev->data, chip, PROCESSOR_OFDM,
> +				      p_mp2if_pid_en, mp2if_pid_en_pos,
> +				      mp2if_pid_en_len, 0);
> +		dev->fc[chip].en_pid = 0;
> +	}
> +
> +	/* Before acquireChannel, it is 1; otherwise, it is 0 */
> +	dev->fc[chip].tuner_info.setting_freq = 1;
> +
> +	if (freq)
> +		dev->fc[chip].desired_freq = freq;
> +	else
> +		freq = dev->fc[chip].desired_freq;
> +
> +	if (bw)
> +		dev->fc[chip].desired_bw = bw * 1000;
> +	else
> +		bw = dev->fc[chip].desired_bw;
> +
> +	deb_info("Real Freq= %ld, BW=%d\n",
> +		 (long int)dev->fc[chip].desired_freq,
> +		 dev->fc[chip].desired_bw);
> +
> +	if (!dev->fc[chip].tuner_info.inited) {
> +		deb_warning("Skip SetFreq - Tuner is still off!\n");
> +		goto exit;
> +	}
> +
> +	dev->fc[chip].tuner_info.set = 0;
> +	if (dev->fc[chip].desired_freq != 0 && dev->fc[chip].desired_bw != 0) {
> +		deb_info("it9135_acquire_ch: Real Freq= %ld, BW=%d\n",
> +			 (long int)dev->fc[chip].desired_freq,
> +			 dev->fc[chip].desired_bw);
> +		error =
> +		    it9135_acquire_ch(&dev->data, chip,
> +				      dev->fc[chip].desired_bw,
> +				      dev->fc[chip].desired_freq);
> +		/* dev->fc[chip].tuner_info.setting_freq = 0; */
> +		if (error) {
> +			err("it9135_acquire_ch fail! 0x%08lx",
> +			    (long unsigned int)error);
> +			goto exit;
> +		} else {	/* when success acquireChannel, record currentFreq/currentBW. */
> +			dev->fc[chip].curr_freq = dev->fc[chip].desired_freq;
> +			dev->fc[chip].curr_bw = dev->fc[chip].desired_bw;
> +		}
> +	}
> +
> +	if (dev->stream_type == STREAM_TYPE_DVBT_DATAGRAM)
> +		dev->fc[chip].ovr_flw_chk = 5;
> +
> +	dev->fc[chip].tuner_info.set = 1;
> +
> +	/* [OMEGA] if only 1 on, set the other to the same freq. */
> +	if (dev->architecture == ARCHITECTURE_PIP) {
> +		if (!dev->fc[0].timer_on && !dev->fc[1].timer_on) {
> +			/* case: when 1st open; */
> +			error =
> +			    it9135_acquire_ch(&dev->data, (!chip),
> +					      dev->fc[chip].curr_bw,
> +					      dev->fc[chip].curr_freq);
> +		} else if ((!dev->fc[0].timer_on || !dev->fc[1].timer_on)
> +			   && !dev->fc[!chip].tuner_info.locked) {
> +			/* case: when only 1 active, and change freq; (the other need to change to same freq too) */
> +			error =
> +			    it9135_acquire_ch(&dev->data, (!chip),
> +					      dev->fc[chip].curr_bw,
> +					      dev->fc[chip].curr_freq);
> +		}
> +	}
> +
> +exit:
> +	dev->fc[chip].tuner_info.setting_freq = 0;
> +
> +	if (dev->chip_ver == 1) {
> +		if (error && (!dev->already_nim_reset_seq)
> +		    && (chip == 1)) {
> +			dev->already_nim_reset_seq = 1;
> +			it9135_nim_reset_seq(dev);
> +			it9135_drv_set_freq_bw(dev, chip, temp_freq, temp_bw);
> +			dev->already_nim_reset_seq = 0;
> +		}
> +	}
> +	return error;
> +}
> +
> +/* Tuner lock signal or not */
> +static unsigned long it9135_drv_is_locked(struct it9135_dev_ctx *dev,
> +					  unsigned char chip, int *locked)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	*locked = 0;
> +
> +	error = it9135_freq_locked(&dev->data, chip, locked);
> +	if (error) {
> +		err("Standard_isLocked is failed!");
> +	} else {
> +		if (!*locked)
> +			deb_info("The chip=%d signal is %s Lock\n", chip,
> +				 *locked ? "" : "not");
> +	}
> +
> +	return error;
> +}
> +
> +unsigned long it9135_drv_get_snr_value(struct it9135_dev_ctx *dev,
> +				       unsigned long *snr_value)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char snr_reg_23_16, snr_reg_15_8, snr_reg_7_0;
> +
> +	deb_func("Enter %s Function\n ", __func__);
> +
> +	error =
> +	    it9135_read_reg(&dev->data, 0, PROCESSOR_OFDM, 0x2e,
> +			    (unsigned char *)&snr_reg_23_16);
> +	if (error)
> +		err("it9135_get_snr snr_reg_23_16 is failed!");
> +
> +	error =
> +	    it9135_read_reg(&dev->data, 0, PROCESSOR_OFDM, 0x2d,
> +			    (unsigned char *)&snr_reg_15_8);
> +	if (error)
> +		err("it9135_get_snr snr_reg_15_8 is failed!");
> +
> +	error =
> +	    it9135_read_reg(&dev->data, 0, PROCESSOR_OFDM, 0x2c,
> +			    (unsigned char *)&snr_reg_7_0);
> +	if (error)
> +		err("it9135_get_snr snr_reg_7_0 is failed!");
> +
> +	*snr_value =
> +	    (snr_reg_23_16 & 0xff) * 256 * 256 + (snr_reg_15_8 & 0xff) * 256 +
> +	    (snr_reg_7_0 & 0xff);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_drv_get_statistic(struct it9135_dev_ctx *dev,
> +				       unsigned char chip,
> +				       struct it9135_statistic *statistic)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	if (dev->fc[chip].tuner_info.set) {
> +		error = it9135_get_statistic(&dev->data, chip, statistic);
> +	} else {
> +		(*statistic).presented = 0;
> +		(*statistic).locked = 0;
> +		(*statistic).quality = 0;
> +		(*statistic).strength = 0;
> +	}
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_drv_init_dev_info(struct it9135_dev_ctx *dev,
> +					      unsigned char chip)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	dev->fc[chip].curr_freq = 0;
> +	dev->fc[chip].curr_bw = 0;
> +	dev->fc[chip].desired_freq = 0;
> +	dev->fc[chip].desired_bw = 6000;
> +
> +	/* For PID Filter Setting */
> +	dev->fc[chip].en_pid = 0;
> +	dev->fc[chip].ap_on = 0;
> +	dev->fc[chip].reset_ts = 0;
> +	dev->fc[chip].tuner_info.set = 0;
> +	dev->fc[chip].tuner_info.setting_freq = 0;
> +
> +	return error;
> +}
> +
> +/* Get EEPROM_IRMODE/ir_tab_load/bRAWIr/architecture config from EEPROM */
> +static unsigned long it9135_drv_get_eeprom_config(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char chip_ver = 0;
> +	unsigned long chip_type;
> +	unsigned char var[2];
> +	/* ir_tab_load option */
> +	unsigned char tmp = 0;
> +	int chip;
> +
> +	deb_func("Enter %s Function", __func__);
> +
> +	/* Patch for read eeprom valid bit */
> +	error =
> +	    it9135_read_reg(&dev->data, 0, PROCESSOR_LINK, chip_version_7_0,
> +			    &chip_ver);
> +	error =
> +	    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +			     chip_version_7_0 + 1, 2, var);
> +
> +	if (error)
> +		err("it9135_drv_get_eeprom_config fail---cannot read chip version");
> +
> +	chip_type = var[1] << 8 | var[0];
> +	if (chip_type == 0x9135 && chip_ver == 2) {	/* Om2 */
> +		dev->chip_ver = 2;
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK, 0x461d, 1,
> +				     &tmp);
> +		deb_info
> +		    ("Chip Version is %d---and Read 461d---valid bit = 0x%02X",
> +		     chip_ver, tmp);
> +	} else {
> +		dev->chip_ver = 1;	/* Om1 */
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK, 0x461b, 1,
> +				     &tmp);
> +		deb_info
> +		    ("Chip Version is %d---and Read 461b---valid bit = 0x%02X",
> +		     chip_ver, tmp);
> +	}
> +	deb_info("*** Chip Version = %d ***", chip_ver);
> +	if (error) {
> +		err("0x461D eeprom valid bit read fail!");
> +		goto exit;
> +	}
> +
> +	if (tmp == 0) {
> +		deb_info("No need read eeprom\n");
> +		dev->ir_tab_load = 0;
> +		dev->proprietary_ir = 0;
> +		dev->dual_ts = 0;
> +		dev->architecture = ARCHITECTURE_DCA;
> +		dev->data.chip_num = 1;
> +		dev->dca_pip = 0;
> +		dev->fc[0].tuner_info.id = 0x38;
> +	} else {
> +		deb_info("Need read eeprom\n");
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +				     EEPROM_IRMODE, 1, &tmp);
> +		if (error)
> +			goto exit;
> +
> +		dev->ir_tab_load = tmp ? 1 : 0;
> +		deb_info("EEPROM_IRMODE = 0x%02X, ", tmp);
> +		deb_info("ir_tab_load %s\n", dev->ir_tab_load ? "ON" : "OFF");
> +
> +		dev->proprietary_ir = (tmp == 0x05) ? 1 : 0;
> +		deb_info("proprietary_ir - %s\n",
> +			 dev->proprietary_ir ? "ON" : "OFF");
> +		if (dev->proprietary_ir)
> +			deb_info("IT9135 propriety (raw) mode\n");
> +		else
> +			deb_info("IT9135 HID (keyboard) mode\n");
> +
> +		/* EE chose NEC RC5 RC6 threshhold table */
> +		if (dev->ir_tab_load) {
> +			error =
> +			    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +					     EEPROM_IRTYPE, 1, &tmp);
> +			if (error)
> +				goto exit;
> +			dev->ir_type = tmp;
> +			deb_info("ir_type %d", dev->ir_type);
> +		}
> +
> +		/* dual_ts option */
> +		dev->dual_ts = 0;
> +		dev->architecture = ARCHITECTURE_DCA;
> +		dev->data.chip_num = 1;
> +		dev->dca_pip = 0;
> +
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +				     EEPROM_TSMODE, 1, &tmp);
> +		if (error)
> +			goto exit;
> +		deb_info("EEPROM_TSMODE = 0x%02X", tmp);
> +
> +		if (tmp == 0) {
> +			deb_info("TSMode = TS1 mode\n");
> +		} else if (tmp == 1) {
> +			deb_info("TSMode = DCA+PIP mode\n");
> +			dev->architecture = ARCHITECTURE_DCA;
> +			dev->data.chip_num = 2;
> +			dev->dual_ts = 1;
> +			dev->dca_pip = 1;
> +		} else if (tmp == 2) {
> +			deb_info("TSMode = DCA mode\n");
> +			dev->data.chip_num = 2;
> +		} else if (tmp == 3) {
> +			deb_info("TSMode = PIP mode\n");
> +			dev->architecture = ARCHITECTURE_PIP;
> +			dev->data.chip_num = 2;
> +			dev->dual_ts = 1;
> +		}
> +
> +		/* tunerID option, Omega, not need to read register, just assign 0x38; */
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +				     EEPROM_TUNERID, 1, &tmp);
> +		if (tmp == 0x51)
> +			dev->fc[0].tuner_info.id = 0x51;
> +		else if (tmp == 0x52)
> +			dev->fc[0].tuner_info.id = 0x52;
> +		else if (tmp == 0x60)
> +			dev->fc[0].tuner_info.id = 0x60;
> +		else if (tmp == 0x61)
> +			dev->fc[0].tuner_info.id = 0x61;
> +		else if (tmp == 0x62)
> +			dev->fc[0].tuner_info.id = 0x62;
> +		else
> +			dev->fc[0].tuner_info.id = 0x38;

What are those "ID" values? tuner type? if so, please put those "magic" numbers
into defines. 

> +
> +		deb_info("dev->fc[0].tuner_info.id = 0x%x",
> +			 dev->fc[0].tuner_info.id);
> +		if (dev->dual_ts) {
> +			dev->fc[1].tuner_info.id = dev->fc[0].tuner_info.id;
> +			deb_info("dev->fc[1].tuner_info.id = 0x%x",
> +				 dev->fc[1].tuner_info.id);
> +		}
> +		error =
> +		    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +				     EEPROM_SUSPEND, 1, &tmp);
> +		deb_info("EEPROM susped mode=%d", tmp);
> +
> +	}
> +
> +	for (chip = 0; chip <= (unsigned char)dev->dual_ts; chip++)
> +		error = it9135_drv_init_dev_info(dev, chip);
> +
> +exit:
> +	return error;
> +}
> +
> +static unsigned long it9135_drv_set_bus_tuner(struct it9135_dev_ctx *dev,
> +					      unsigned short busId,
> +					      unsigned short tuner_id)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long version = 0;
> +
> +	deb_func("Enter %s Function", __func__);
> +	deb_info("busId = 0x%x, tuner_id =0x%x\n", busId, tuner_id);
> +
> +	if ((dev->usb_mode == 0x0110) && (busId == IT9135_BUS_USB20))
> +		busId = IT9135_BUS_USB11;
> +
> +	error = it9135_set_bus_tuner(&dev->data, busId, tuner_id);
> +	if (error) {
> +		err("it9135_set_bus_tuner error");
> +		return error;
> +	}
> +
> +	error = it9135_get_fw_ver(&dev->data, PROCESSOR_LINK, &version);
> +	if (version != 0)
> +		dev->data.booted = 1;
> +	else
> +		dev->data.booted = 0;
> +
> +	if (error)
> +		err("it9135_get_fw_ver error");
> +
> +	return error;
> +}
> +
> +/* suspend 1 --> sleep / suspend not 1 --> resume */
> +static unsigned long it9135_drv_nim_suspend(struct it9135_dev_ctx *dev,
> +					    int suspend)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +	deb_info("suspend = %s\n", suspend ? "ON" : "OFF");
> +
> +	if (dev->data.chip_num == 1)
> +		return ERROR_NO_ERROR;
> +
> +	if (suspend) {		/* Sleep */
> +		error =
> +		    it9135_write_reg_bits(&dev->data,
> +					  0, PROCESSOR_LINK, p_reg_top_gpioh5_o,
> +					  reg_top_gpioh5_o_pos,
> +					  reg_top_gpioh5_o_len, 1);
> +		mdelay(20);
> +	} else {		/* Resume */
> +		error =
> +		    it9135_write_reg_bits(&dev->data,
> +					  0, PROCESSOR_LINK, p_reg_top_gpioh5_o,
> +					  reg_top_gpioh5_o_pos,
> +					  reg_top_gpioh5_o_len, 0);
> +		mdelay(100);
> +	}
> +
> +	return error;
> +}
> +
> +/* Set tuner power saving and control */
> +static unsigned long it9135_drv_ap_ctrl(struct it9135_dev_ctx *dev,
> +					unsigned char chip, int onoff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned long version = 0;
> +	int i;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +	deb_info("chip = %d, onoff = %s\n", chip, onoff ? "ON" : "OFF");
> +
> +	if (onoff) {
> +		dev->fc[chip].tuner_info.inited = 1;
> +		if (dev->architecture == ARCHITECTURE_PIP) {
> +			if (dev->fc[0].timer_on || dev->fc[1].timer_on) {
> +				deb_info("Already all power on !!");
> +				return 0;
> +			}
> +		}
> +	} else {
> +		dev->fc[chip].tuner_info.inited = 0;
> +		dev->fc[chip].tuner_info.locked = 0;
> +
> +		/* [OMEGA] if other one still alive, do not pwr down, just need to set freq; */
> +		if (dev->architecture == ARCHITECTURE_PIP) {
> +			if (dev->fc[0].timer_on || dev->fc[1].timer_on) {
> +				deb_info("CLOSE 1");
> +				it9135_acquire_ch(&dev->data, chip,
> +						  dev->fc[!chip].curr_bw,
> +						  dev->fc[!chip].curr_freq);
> +				return 0;
> +			}
> +		}
> +	}
> +	/*[OMEGA] clock from tuner, so close sequence demod->tuner, and 9133->9137. vice versa.
> +	 * BUT! demod->tuner:57mADC, tuner->demod:37mADC
> +	 */
> +	if (onoff) {		/* pwr on */
> +		if (dev->chip_ver == 1) {
> +			if (chip == 1) {
> +				error = it9135_nim_reset_seq(dev);
> +				if (error)
> +					it9135_nim_reset_seq(dev);
> +			} else {
> +				dev->usb_ctrl_timeOut = 1;
> +				for (i = 0; i < 5; i++) {
> +					deb_info
> +					    ("it9135_drv_ap_ctrl - DummyCmd %d",
> +					     i);
> +					error =
> +					    it9135_get_fw_ver(&dev->data,
> +							      PROCESSOR_LINK,
> +							      &version);
> +					mdelay(1);
> +				}
> +				dev->usb_ctrl_timeOut = 5;
> +
> +				error =
> +				    it9135_ctrl_tuner_pw_saving(&dev->data,
> +								chip, onoff);
> +				if (error)
> +					err("it9135_drv_ap_ctrl::it9135_ctrl_tuner_pw_saving error = %x", (unsigned int)error);
> +
> +				error =
> +				    it9135_ctrl_pw_saving(&dev->data, chip,
> +							  onoff);
> +				if (error)
> +					err("it9135_drv_ap_ctrl::it9135_ctrl_pw_saving error = %x", (unsigned int)error);
> +			}
> +		} else {
> +			if (chip == 1) {
> +				error = it9135_drv_nim_suspend(dev, 0);
> +			} else {
> +				/* DummyCmd */
> +				dev->usb_ctrl_timeOut = 1;
> +				for (i = 0; i < 5; i++) {
> +					deb_info
> +					    ("it9135_drv_ap_ctrl - DummyCmd %d",
> +					     i);
> +					error =
> +					    it9135_get_fw_ver(&dev->data,
> +							      PROCESSOR_LINK,
> +							      &version);
> +					mdelay(1);
> +				}
> +				dev->usb_ctrl_timeOut = 5;
> +			}
> +
> +			error =
> +			    it9135_ctrl_tuner_pw_saving(&dev->data, chip,
> +							onoff);
> +			if (error)
> +				err("it9135_drv_ap_ctrl - it9135_ctrl_tuner_pw_saving error = %x", (unsigned int)error);
> +
> +			error = it9135_ctrl_pw_saving(&dev->data, chip, onoff);
> +			mdelay(50);
> +			if (error)
> +				err("it9135_drv_ap_ctrl - it9135_ctrl_pw_saving error = %x", (unsigned int)error);
> +		}
> +	} else {		/* pwr down:  DCA DUT: 36(all) -> 47-159(no GPIOH5, sequence change) */
> +		if ((chip == 0) && (dev->data.chip_num == 2)) {
> +			error = it9135_ctrl_tuner_leakage(&dev->data, 1, onoff);
> +			if (error)
> +				err("it9135_drv_ap_ctrl::it9135_ctrl_tuner_leakage error = %x", (unsigned int)error);
> +			error = it9135_drv_nim_suspend(dev, 1);
> +		}
> +
> +		error = it9135_ctrl_pw_saving(&dev->data, chip, onoff);
> +		if (error)
> +			err("it9135_drv_ap_ctrl::it9135_ctrl_pw_saving error = %x", (unsigned int)error);
> +
> +		error = it9135_ctrl_tuner_pw_saving(&dev->data, chip, onoff);
> +		if (error)
> +			err("it9135_drv_ap_ctrl::it9135_ctrl_tuner_pw_saving error = %x", (unsigned int)error);
> +	}
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_drv_ap_reset(struct it9135_dev_ctx *dev,
> +					 unsigned char chip, int onoff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	dev->fc[chip].curr_freq = 0;
> +	dev->fc[chip].curr_bw = 6000;	/* For BDAUtil */
> +	dev->fc[chip].ap_on = 0;
> +
> +	if (!onoff) {		/* Only for stop */
> +		dev->fc[chip].en_pid = 0;
> +	}
> +
> +	/* Init Tuner info */
> +	dev->fc[chip].tuner_info.setting_freq = 0;
> +
> +	error = it9135_drv_ap_ctrl(dev, chip, onoff);
> +	if (error)
> +		err("it9135_drv_ap_ctrl Fail!");
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_drv_dummy_cmd(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	int i;
> +
> +	deb_info("it9135_drv_dummy_cmd:: patch for KJS/EEPC\n");
> +	for (i = 0; i < 5; i++) {
> +		error =
> +		    it9135_drv_set_bus_tuner(dev, IT9135_BUS_USB20,
> +					     IT9135_TUNER_ID);
> +		mdelay(1);
> +	}
> +	if (error)
> +		deb_warning("it9135_drv_dummy_cmd failed - %d\n", i);
> +
> +	return error;
> +}
> +
> +/************** DL_ *************/
> +
> +static unsigned long it9135_dl_dummy_cmd(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_dummy_cmd(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_dl_nim_reset(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_nim_reset(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_dl_init_nim_suspend_regs(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_init_nim_suspend_regs(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_dl_initialize(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_initialize(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_dl_set_bus_tuner(struct it9135_dev_ctx *dev,
> +					     unsigned short busId,
> +					     unsigned short tuner_id)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_set_bus_tuner(dev, busId, tuner_id);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +static unsigned long it9135_dl_get_eeprom_config(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_get_eeprom_config(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +/* Load Ir Table */
> +static unsigned long it9135_dl_ir_table_download(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_ir_table_download(dev);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_reset_pid(struct it9135_dev_ctx *dev,
> +				  unsigned char chip)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	/* Reset and Clear pidTable */
> +	error = it9135_reset_pid(&dev->data, chip);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_add_pid(struct it9135_dev_ctx *dev, unsigned char chip,
> +				unsigned char index, unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function - index: %d, pid: %x\n", __func__, index,
> +		 pid);
> +
> +	error = it9135_add_pid_filter(&dev->data, chip, index, pid);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_remove_pid(struct it9135_dev_ctx *dev,
> +				   unsigned char chip, unsigned char index,
> +				   unsigned short pid)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function - index: %d, pid: %x\n", __func__, index,
> +		 pid);
> +
> +	error = it9135_remove_pid_at(&dev->data, chip, index, pid);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_pid_on_off(struct it9135_dev_ctx *dev,
> +				   unsigned char chip, int onoff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char ctrl = 0;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function - onoff: %d\n ", __func__, onoff);
> +
> +	if (onoff)
> +		ctrl = 1;
> +	else
> +		ctrl = 0;
> +
> +	error = it9135_ctrl_pid_filter(&dev->data, chip, 0);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_ap_ctrl(struct it9135_dev_ctx *dev, unsigned char chip,
> +				int onoff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +	deb_info("chip = %d, onoff = %s\n", chip, onoff ? "ON" : "OFF");
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_ap_ctrl(dev, chip, onoff);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_ap_reset(struct it9135_dev_ctx *dev, unsigned char chip,
> +				 int on)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_ap_reset(dev, chip, on);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_tuner_set_freq_bw(struct it9135_dev_ctx *dev,
> +					  unsigned char chip,
> +					  unsigned long freq, unsigned short bw)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	if (dev->fc[chip].desired_freq != freq
> +	    || dev->fc[chip].desired_bw != bw * 1000)
> +		error = it9135_drv_set_freq_bw(dev, chip, freq, bw);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_set_architecture(struct it9135_dev_ctx *dev,
> +					 unsigned char architecture)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +	error = it9135_set_arch(&dev->data, architecture);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_is_locked(struct it9135_dev_ctx *dev,
> +				  unsigned char chip, int *locked)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	error = it9135_drv_is_locked(dev, chip, locked);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_get_signal_strength(struct it9135_dev_ctx *dev,
> +					    unsigned char chip,
> +					    unsigned char *strength)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_get_strength(&dev->data, chip, strength);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_get_signal_strength_Dbm(struct it9135_dev_ctx *dev,
> +						unsigned char chip,
> +						long *strength_dbm)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_get_strength_dbm(&dev->data, chip, strength_dbm);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_get_channel_statistic(struct it9135_dev_ctx *dev,
> +					      unsigned char chip,
> +					      struct it9135_ch_statistic
> +					      *ch_statistic)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_get_ch_statistic(&dev->data, chip, ch_statistic);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_get_channel_modulation(struct it9135_dev_ctx *dev,
> +					       unsigned char chip,
> +					       struct it9135_ch_modulation
> +					       *ch_modulation)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_get_ch_modulation(&dev->data, chip, ch_modulation);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_get_snr(struct it9135_dev_ctx *dev,
> +				unsigned char chip,
> +				unsigned char *constellation,
> +				unsigned char *snr)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_get_snr(&dev->data, chip, snr);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_reboot(struct it9135_dev_ctx *dev)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	error = it9135_dev_reboot(&dev->data);
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +unsigned long it9135_dl_read_raw_ir(struct it9135_dev_ctx *dev,
> +				    unsigned long *read_buff)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	mutex_lock(&dev->it9135_mutex);
> +
> +	if (dev->proprietary_ir)
> +		error = it9135_get_ir_code(&dev->data, read_buff);
> +	else
> +		deb_warning("RAWIr can't be used!!\n");
> +
> +	mutex_unlock(&dev->it9135_mutex);
> +
> +	return error;
> +}
> +
> +/* Set device driver init */
> +unsigned long it9135_device_init(struct usb_device *udev,
> +				 struct it9135_dev_ctx *dev, int boot)
> +{
> +	unsigned long error = ERROR_NO_ERROR;
> +	int err_cnt = 0;
> +	int i;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	dev_set_drvdata(&udev->dev, dev);
> +
> +	info("=========================================");
> +	info("DRIVER_RELEASE_VERSION:    %s", DRIVER_RELEASE_VERSION);
> +	info("FW_RELEASE_VERSION:        %s", dev->fw_ver);
> +	info("API_RELEASE_VERSION:       %X.%X.%X", IT9135_API_VER_NUM,
> +	     IT9135_API_DATE, IT9135_API_BUILD);
> +	info("=========================================");
> +
> +#ifdef DVB_USB_ADAP_NEED_PID_FILTER
> +	deb_info("DVB_USB_ADAP_NEED_PID_FILTERING\n");
> +#else
> +	deb_info("DVB_USB_ADAP_NOT_NEED_PID_FILTERING\n");
> +#endif
> +
> +	/************* Set Device init Info *************/
> +	dev->enter_suspend = 0;
> +	dev->surprise_removal = 0;
> +	dev->dev_not_resp = 0;
> +	dev->selective_suspend = 0;
> +	dev->tuner_pw_off = 0;
> +	dev->already_nim_reset_seq = 0;
> +
> +	if (boot) {
> +		dev->data.chip_num = 1;
> +		dev->architecture = ARCHITECTURE_DCA;
> +		dev->data.frequency[0] = 666000;
> +		dev->data.bandwidth[0] = 8000;
> +		dev->ir_tab_load = 0;
> +		dev->fc[0].tuner_info.id = 0;
> +		dev->fc[1].tuner_info.id = 0;
> +		dev->fc[0].timer_on = 0;
> +		dev->fc[1].timer_on = 0;
> +		dev->dual_ts = 0;
> +		dev->filter_cnt = 0;
> +		dev->filter_index = 0;
> +		dev->stream_type = STREAM_TYPE_DVBT_DATAGRAM;
> +		dev->usb_ctrl_timeOut = 1;
> +		dev->disconnect = 0;
> +		if (udev->speed == USB_SPEED_FULL)
> +			dev->max_packet_sz = 0x0110;
> +		else
> +			dev->max_packet_sz = 0x0200;
> +	} else {
> +		dev->usb_ctrl_timeOut = 5;
> +	}
> +
> +	error = it9135_dl_dummy_cmd(dev);
> +
> +	if (boot) {
> +		/************* Set USB Info *************/
> +		dev->usb_mode = (dev->max_packet_sz == 0x200) ? 0x0200 : 0x0110;
> +		deb_info("USB mode = 0x%x\n", dev->usb_mode);
> +
> +		dev->ts_packet_cnt =
> +		    (dev->usb_mode ==
> +		     0x200) ? IT9135_TS_PACKET_COUNT_HI :
> +		    IT9135_TS_PACKET_COUNT_FU;
> +		dev->ts_frames =
> +		    (dev->usb_mode ==
> +		     0x200) ? IT9135_TS_FRAMES_HI : IT9135_TS_FRAMES_FU;
> +		dev->ts_frame_sz = IT9135_TS_PACKET_SIZE * dev->ts_packet_cnt;
> +		dev->ts_frame_sz_dw = dev->ts_frame_sz / 4;
> +	}
> +	dev->ep12_err = 0;
> +	dev->ep45_err = 0;
> +	dev->active_filter = 0;
> +
> +	if (boot) {
> +		error =
> +		    it9135_dl_set_bus_tuner(dev, IT9135_BUS_USB20,
> +					    IT9135_TUNER_ID);
> +		if (error) {
> +			err("First it9135_dl_set_bus_tuner fail : 0x%08lx",
> +			    (long unsigned int)error);
> +			err_cnt++;
> +			goto Exit;
> +		}
> +
> +		error = it9135_dl_get_eeprom_config(dev);
> +		if (error) {
> +			err("it9135_dl_get_eeprom_config fail : 0x%08lx",
> +			    (long unsigned int)error);
> +			err_cnt++;
> +			goto Exit;
> +		}
> +	}
> +
> +	error =
> +	    it9135_dl_set_bus_tuner(dev, IT9135_BUS_USB20,
> +				    dev->fc[0].tuner_info.id);
> +	if (error) {
> +		err("it9135_dl_set_bus_tuner fail!");
> +		err_cnt++;
> +		goto Exit;
> +	}
> +
> +	if (dev->data.chip_num == 2 && !dev->data.booted) {	/* plug/cold-boot/S4 */
> +		error = it9135_dl_nim_reset(dev);
> +	} else if (dev->data.chip_num == 2 && dev->data.booted) {	/* warm-boot/(S1) */
> +		/* pwr on for init. */
> +		for (i = 0; i < dev->data.chip_num; i++)
> +			error = it9135_dl_ap_ctrl(dev, i, 1);
> +	} else if (dev->data.chip_num == 1 && dev->data.booted) {	/* warm-boot/(S1) */
> +		/* pwr on for init, but seems not necessary. */
> +		error = it9135_dl_ap_ctrl(dev, 0, 1);
> +	}
> +
> +	if (error)
> +		err("it9135_dl_nim_reset or dl_nim_suspend fail!");
> +
> +	error = it9135_dl_initialize(dev);
> +	if (error) {
> +		err("it9135_dl_initialize fail! 0x%08lx",
> +		    (long unsigned int)error);
> +		err_cnt++;
> +		goto Exit;
> +	}
> +
> +	if (dev->ir_tab_load) {
> +		error = it9135_dl_ir_table_download(dev);
> +		if (error) {
> +			err("it9135_dl_ir_table_download fail");
> +			err_cnt++;
> +		}
> +	}
> +
> +	if (dev->data.chip_num == 2) {
> +		error = it9135_dl_init_nim_suspend_regs(dev);
> +		if (error)
> +			err("it9135_dl_init_nim_suspend_regs fail!");
> +	}
> +
> +	for (i = dev->data.chip_num; i > 0; i--) {
> +		error = it9135_dl_ap_ctrl(dev, (i - 1), 0);
> +		if (error)
> +			err("%d: it9135_dl_ap_ctrl Fail!", i);
> +
> +	}
> +
> +	info("%s success!!", __func__);
> +
> +Exit:
> +	if (err_cnt)
> +		err("[Device_init] Error %d\n", err_cnt);
> +	return error;
> +}
> +
> +int dca_to_pip(struct it9135_dev_ctx *dev)
> +{
> +	dev->filter_index = dev->filter_cnt;
> +
> +	deb_info("dca_to_pip - %d\n", dev->filter_cnt);
> +
> +	if (dev->filter_cnt == 1) {
> +		/* Do nothing, stay in DCA. */
> +		it9135_dl_set_architecture(dev, ARCHITECTURE_DCA);
> +		mdelay(50);
> +	} else if (dev->filter_cnt == 2) {
> +		it9135_dl_set_architecture(dev, ARCHITECTURE_PIP);
> +		mdelay(50);
> +	}
> +
> +	return 0;
> +}
> +
> +int pip_to_dca(struct it9135_dev_ctx *dev)
> +{
> +	deb_info("pip_to_dca - %d, %d\n", dev->filter_cnt, dev->filter_index);
> +
> +	if (dev->filter_cnt == 1) {
> +		if (dev->filter_index == 0) {	/*Close filter 0. */
> +			dev->swap_filter = 1;
> +			it9135_dl_set_architecture(dev, ARCHITECTURE_DCA);
> +			it9135_dl_tuner_set_freq_bw(dev, 0,
> +						    dev->fc[1].curr_freq, 0);
> +			dev->swap_filter = 0;
> +		} else {	/* Close filter 1. */
> +
> +			it9135_dl_set_architecture(dev, ARCHITECTURE_DCA);
> +			it9135_dl_tuner_set_freq_bw(dev, 0,
> +						    dev->fc[0].curr_freq, 0);
> +		}
> +
> +		dev->fc[1].timer_on = 0;
> +		dev->fc[0].timer_on = 1;
> +	} else if (dev->filter_cnt == 0) {
> +		dev->fc[1].timer_on = 0;
> +		dev->fc[0].timer_on = 0;
> +	}
> +	return 0;
> +}
> +
> +/* IT9135 device tuner on init */
> +static int it9135_init(struct dvb_frontend *demod)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)demod->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	int i;
> +
> +	deb_func("Enter %s Function - chip=%d\n", __func__, demod->dvb->num);
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	dev->filter_cnt++;
> +
> +	if (dev->dca_pip) {
> +		for (i = 0; i < dev->data.chip_num; i++)
> +			error = it9135_dl_ap_ctrl(dev, i, 1);
> +
> +		error = dca_to_pip(dev);
> +	}
> +
> +	if (error)
> +		return -EREMOTEIO;
> +
> +	if ((dev->architecture == ARCHITECTURE_PIP) && (dev->filter_cnt == 2)) {
> +		/* Do nothging, MODE = DCA+PIP, because 2 tuners have turn on from DCA. */
> +	} else if (dev->architecture == ARCHITECTURE_DCA) {	/* Single or DCA */
> +		for (i = 0; i < dev->data.chip_num; i++)
> +			error = it9135_dl_ap_ctrl(dev, i, 1);
> +	} else {
> +		/* PIP */
> +		/* pwr on 2 chips directly; */
> +		for (i = 0; i < dev->data.chip_num; i++)
> +			error = it9135_dl_ap_ctrl(dev, i, 1);
> +	}
> +
> +	if (error)
> +		return -EREMOTEIO;
> +
> +	dev->fc[demod->dvb->num].timer_on = 1;
> +
> +	return 0;
> +}
> +
> +/* IT9135 device tuner off sleep */
> +static int it9135_sleep(struct dvb_frontend *demod)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)demod->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	int i;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	dev->filter_cnt--;
> +	dev->fc[demod->dvb->num].timer_on = 0;
> +
> +	if (dev->dca_pip)
> +		error = pip_to_dca(dev);
> +
> +	if (dev->filter_cnt == 1) {
> +		/* Do nothing, Mode = DCA+PIP, because from PIP to DCA */
> +		deb_info("ARCHITECTURE_DCA - %d\n", dev->filter_cnt);
> +	} else {		/* Single or DCA */
> +		deb_info("ARCHITECTURE_DCA2 - %d\n", dev->filter_cnt);
> +
> +		for (i = dev->data.chip_num; i > 0; i--)
> +			error = it9135_dl_ap_reset(dev, i - 1, 0);
> +
> +	}
> +
> +	if (error)
> +		return -EREMOTEIO;
> +
> +	return 0;
> +}
> +
> +static int it9135_get_frontend(struct dvb_frontend *fe,
> +			       struct dvb_frontend_parameters *fep)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +
> +	if (dev->data.chip_num != 2)
> +		deb_func("Enter %s Function\n", __func__);
> +	else
> +		deb_func("Enter %s Function - chip=%d\n", __func__,
> +			 fe->dvb->num);
> +
> +	fep->inversion = INVERSION_AUTO;
> +	return 0;
> +}
> +
> +/* Set OFDM bandwidth and tuner frequency */
> +static int it9135_set_frontend(struct dvb_frontend *fe,
> +			       struct dvb_frontend_parameters *fep)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +	struct it9135_ofdm_channel ch;
> +	unsigned long error = ERROR_NO_ERROR;
> +
> +	ch.rf_khz = 0;
> +	ch.bw = 0;
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	if (dev->data.chip_num != 2)
> +		deb_func("Enter %s Function\n", __func__);
> +	else
> +		deb_func("Enter %s Function - chip=%d RF=%d, BW=%d\n", __func__,
> +			 fe->dvb->num, ch.rf_khz, ch.bw);
> +
> +	if (fep->u.ofdm.bandwidth == 0)
> +		fep->u.ofdm.bandwidth = 8;
> +	if (fep->u.ofdm.bandwidth == 1)
> +		fep->u.ofdm.bandwidth = 7;
> +	if (fep->u.ofdm.bandwidth == 2)
> +		fep->u.ofdm.bandwidth = 6;
> +
> +	ch.rf_khz = fep->frequency / 1000;
> +	ch.bw = fep->u.ofdm.bandwidth;
> +
> +	if (ch.rf_khz < 177000 || ch.rf_khz > 8585000)
> +		ch.rf_khz = 950000;
> +
> +	if (dev->data.chip_num != 2)
> +		error = it9135_dl_tuner_set_freq_bw(dev, 0, ch.rf_khz, ch.bw);
> +	else
> +		error =
> +		    it9135_dl_tuner_set_freq_bw(dev, fe->dvb->num, ch.rf_khz,
> +						ch.bw);
> +
> +	if (error)
> +		err("it9135_set_frontend return error");
> +
> +	return 0;
> +}
> +
> +/* Tuner signal lock frequency */
> +static int it9135_read_status(struct dvb_frontend *fe, fe_status_t * stat)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	int locked;
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	*stat = 0;
> +
> +	if (dev->data.chip_num != 2)
> +		error = it9135_dl_is_locked(dev, 0, &locked);
> +	else
> +		error = it9135_dl_is_locked(dev, fe->dvb->num, &locked);
> +
> +	if (error)
> +		return 0;
> +
> +	if (locked) {
> +		/* It's seems ok that always return lock to AP */
> +		*stat |= FE_HAS_SIGNAL;
> +		*stat |= FE_HAS_CARRIER;
> +		*stat |= FE_HAS_LOCK;
> +		*stat |= FE_HAS_VITERBI;
> +		*stat |= FE_HAS_SYNC;
> +	} else
> +		*stat |= FE_TIMEDOUT;
> +
> +	return 0;
> +}
> +
> +/* Get it9135_ch_statistic and calculate ber value */
> +static int it9135_read_ber(struct dvb_frontend *fe, u32 * ber)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	struct it9135_ch_statistic ch_statistic;
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	if (dev->data.chip_num != 2)
> +		error = it9135_dl_get_channel_statistic(dev, 0, &ch_statistic);
> +	else
> +		error =
> +		    it9135_dl_get_channel_statistic(dev, fe->dvb->num,
> +						    &ch_statistic);
> +	if (error)
> +		return error;
> +
> +	deb_info
> +	    ("it9135_read_ber post_vit_err_cnt: %ld, post_vitbit_cnt: %ld\n",
> +	     (long int)ch_statistic.post_vit_err_cnt,
> +	     (long int)ch_statistic.post_vitbit_cnt);
> +
> +	*ber =
> +	    ch_statistic.post_vit_err_cnt * (0xFFFFFFFF /
> +					     ch_statistic.post_vitbit_cnt);
> +
> +	return 0;
> +}
> +
> +/* Calculate SNR value */
> +static int it9135_read_snr(struct dvb_frontend *fe, u16 * snr)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char constellation;
> +	unsigned char SignalSnr = 0;
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	if (dev->data.chip_num != 2)
> +		error = it9135_dl_get_snr(dev, 0, &constellation, &SignalSnr);
> +	else
> +		error =
> +		    it9135_dl_get_snr(dev, fe->dvb->num, &constellation,
> +				      &SignalSnr);
> +	if (error)
> +		return error;
> +
> +	deb_info("it9135_read_snr constellation: %d, SignalSnr: %d\n",
> +		 constellation, SignalSnr);
> +
> +	if (constellation == 0) {
> +		*snr = (u16)SignalSnr * (0xFFFF / 23);
> +	} else if (constellation == 1) {
> +		*snr = (u16)SignalSnr * (0xFFFF / 26);
> +	} else if (constellation == 2) {
> +		*snr = (u16)SignalSnr * (0xFFFF / 29);
> +	} else {
> +		deb_warning("Get constellation is failed!\n");
> +	}
> +
> +	return 0;
> +}
> +
> +static int it9135_read_unc_blocks(struct dvb_frontend *fe, u32 * unc)
> +{
> +	*unc = 0;
> +	return 0;
> +}
> +
> +/* Read signal strength and calculate strength value */
> +static int it9135_read_signal_strength(struct dvb_frontend *fe, u16 * strength)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)fe->demodulator_priv;
> +	unsigned long error = ERROR_NO_ERROR;
> +	unsigned char st = 0;
> +
> +	if (dev->disconnect)
> +		return 0;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	if (dev->data.chip_num != 2)
> +		error = it9135_dl_get_signal_strength(dev, 0, &st);
> +	else
> +		error = it9135_dl_get_signal_strength(dev, fe->dvb->num, &st);
> +	if (error)
> +		return error;
> +
> +	deb_info("%s is %d\n", __func__, st);
> +	*strength = (u16)st * (0xFFFF / 100);
> +
> +	return 0;
> +}
> +
> +static void it9135_release(struct dvb_frontend *fe)
> +{
> +	deb_func("%s:\n", __func__);
> +	kfree(fe);
> +}
> +
> +static struct dvb_frontend_ops it9135_ops;
> +struct dvb_frontend *it9135_attach(struct dvb_usb_adapter *adap)
> +{
> +	struct dvb_frontend *frontend;
> +	struct it9135_dev_ctx *dev = dev_get_drvdata(&adap->dev->udev->dev);
> +
> +	frontend = kzalloc(sizeof(*frontend), GFP_KERNEL);
> +	if (frontend == NULL)
> +		goto error;
> +
> +	frontend->demodulator_priv = dev;
> +	memcpy(&frontend->ops, &it9135_ops, sizeof(it9135_ops));
> +
> +	return frontend;
> +
> +error:
> +	kfree(frontend);
> +	return NULL;
> +}
> +
> +static struct dvb_frontend_ops it9135_ops = {
> +	.info = {
> +		 .name = "IT9135 USB DVB-T",
> +		 .type = FE_OFDM,
> +		 .frequency_min = 44250000,
> +		 .frequency_max = 867250000,
> +		 .frequency_stepsize = 62500,
> +		 .caps = FE_CAN_INVERSION_AUTO |
> +		 FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> +		 FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +		 FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
> +		 FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO |
> +		 FE_CAN_RECOVER | FE_CAN_HIERARCHY_AUTO,
> +		 },
> +
> +	.release = it9135_release,
> +
> +	.init = it9135_init,
> +	.sleep = it9135_sleep,
> +
> +	.set_frontend = it9135_set_frontend,
> +	.get_frontend = it9135_get_frontend,
> +
> +	.read_status = it9135_read_status,
> +	.read_ber = it9135_read_ber,
> +	.read_signal_strength = it9135_read_signal_strength,
> +	.read_snr = it9135_read_snr,
> +	.read_ucblocks = it9135_read_unc_blocks,
> +};
> +
> +/* -------------------------------------------------------------------------- */
> +
> +/*
> + * init it9135 properties
> + */
> +
> +static int it9135_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)adap->fe->demodulator_priv;
> +	int ret = 0;
> +
> +	deb_info("%s: onoff:%d\n", __func__, onoff);
> +
> +	if (!onoff) {
> +		deb_info("Reset PID Table\n");
> +
> +		if (dev->data.chip_num != 2)
> +			it9135_dl_reset_pid(dev, 0);
> +		else
> +			it9135_dl_reset_pid(dev, (unsigned char)adap->id);
> +	}
> +
> +	dev->fc[adap->id].en_pid = onoff;
> +
> +	if (dev->data.chip_num != 2)
> +		ret = it9135_dl_pid_on_off(dev, 0, dev->fc[adap->id].en_pid);
> +	else
> +		ret =
> +		    it9135_dl_pid_on_off(dev, (unsigned char)adap->id,
> +					 dev->fc[adap->id].en_pid);
> +
> +	deb_info("Set pid onoff ok\n");
> +
> +	return ret;
> +}
> +
> +static int it9135_pid_filter(struct dvb_usb_adapter *adap, int index,
> +			     u16 pidnum, int onoff)
> +{
> +	struct it9135_dev_ctx *dev =
> +	    (struct it9135_dev_ctx *)adap->fe->demodulator_priv;
> +	unsigned short pid;
> +	int ret = 0;
> +
> +	deb_info
> +	    ("%s: set pid filter, feedcount %d, index %d, pid %x, onoff %d.\n",
> +	     __func__, adap->feedcount, index, pidnum, onoff);
> +
> +	if (onoff) {
> +		/* Cannot use it as pid_filter_ctrl since it has to be done before setting the first pid */
> +		if (adap->feedcount == 1) {
> +			deb_info("first pid set, enable pid table\n");
> +			ret = it9135_pid_filter_ctrl(adap, onoff);
> +			if (ret)
> +				return ret;
> +		}
> +
> +		pid = (unsigned short)pidnum;
> +		if (dev->data.chip_num != 2)
> +			ret = it9135_dl_add_pid(dev, 0, index, pid);
> +		else
> +			ret =
> +			    it9135_dl_add_pid(dev, (unsigned char)adap->id,
> +					      index, pid);
> +		if (ret)
> +			return ret;
> +	} else {
> +		pid = (unsigned short)pidnum;
> +		if (dev->data.chip_num != 2)
> +			ret = it9135_dl_remove_pid(dev, 0, index, pid);
> +		else
> +			ret =
> +			    it9135_dl_remove_pid(dev, (unsigned char)adap->id,
> +						 index, pid);
> +		if (ret)
> +			return ret;
> +
> +		if (adap->feedcount == 0) {
> +			deb_info("last pid unset, disable pid table\n");
> +			ret = it9135_pid_filter_ctrl(adap, onoff);
> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +struct it9135_val_set *script_parser(const struct firmware *fw,
> +				     int *fw_file_pos, u16 * script_sets)
> +{
> +	int pos = *fw_file_pos;
> +	struct it9135_val_set *scripts_temp = NULL;
> +	int j = 0;
> +	int i = 0;
> +
> +	/* fw_file_pos+0 ~ +3 == VERSION1 VERSION2 VERSION3 VERSION4 */
> +	pos += 4;
> +
> +	/* OMEGA_ADDRESS */
> +	pos += 1;
> +
> +	/* OMEGA_SCRIPTSETLENGTH */
> +	if (fw->data[pos] != 1) {
> +		err("OMEGA_SCRIPTSETLENGTH != 1 !!");
> +		return NULL;
> +	}
> +	pos += 4;
> +
> +	/* scriptSets */
> +	*script_sets = fw->data[pos] + (fw->data[pos + 1] << 8);
> +	pos += 2;
> +
> +	/* OMEGA_LNA_Config_2_scripts */
> +	scripts_temp =
> +	    kzalloc((*script_sets) * sizeof(*scripts_temp), GFP_KERNEL);
> +	for (i = 0; i < (*script_sets); i++) {
> +		scripts_temp[i].address = fw->data[pos + j] +
> +		    (fw->data[pos + j + 1] << 8) +
> +		    (fw->data[pos + j + 2] << 16) +
> +		    (fw->data[pos + j + 3] << 24);
> +
> +		scripts_temp[i].value = fw->data[pos + j + 4];
> +		j += 5;
> +	}
> +
> +	pos += j;
> +	*fw_file_pos = pos;
> +
> +	return scripts_temp;
> +}
> +
> +static int it9135_download_firmware(struct usb_device *udev,
> +				    const struct firmware *fw)
> +{
> +	int retval = -ENOMEM;
> +	struct it9135_dev_ctx *dev = NULL;
> +	struct it9135_segment *segs = NULL;
> +	u8 *fw_codes;
> +	u16 *script_sets;
> +	struct it9135_val_set *scripts = NULL;
> +	int fw_file_pos = 0;
> +	unsigned int fw_code_len = 0;
> +	unsigned char var[2];
> +	u32 fw_script_len_v1 = 0;
> +	u32 fw_script_len_v2 = 0;
> +	u32 partition_len_v1 = 0;
> +	u32 partition_len_v2 = 0;
> +	int chip_v2 = 0;
> +	int i = 0;
> +	int j = 0;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (dev == NULL) {
> +		err("Alloc dev out of memory");
> +		return -ENOTTY;
> +	}
> +
> +	/* init mutex */
> +	mutex_init(&dev->it9135_mutex);
> +	dev->data.it9135_fw = fw;
> +
> +	dev->data.driver = (void *)udev;
> +
> +	/* check device chip version */
> +	retval =
> +	    it9135_read_reg(&dev->data, 0, PROCESSOR_LINK, chip_version_7_0,
> +			    &dev->data.chip_ver);
> +	retval =
> +	    it9135_read_regs(&dev->data, 0, PROCESSOR_LINK,
> +			     chip_version_7_0 + 1, 2, var);
> +	if (retval)
> +		info("Cannot read chip version");
> +
> +	dev->data.chip_type = var[1] << 8 | var[0];
> +
> +	if ((dev->data.chip_type == 0x9135) && (dev->data.chip_ver == 2)) {
> +		chip_v2 = 1;
> +		info("This is IT9135 chip v2");
> +	} else {
> +		info("This is IT9135 chip v1");
> +	}
> +
> +	/* byte 0~7 = OMEGA1 */
> +	if ((fw->data[0] != 'I') || (fw->data[1] != 'T') || (fw->data[2] != '9')
> +	    || (fw->data[3] != '1') || (fw->data[4] != '3')
> +	    || (fw->data[5] != '5') || (fw->data[6] != 'A')
> +	    || (fw->data[7] != 'X')) {
> +		err("IT9135 chip v1 FW format Error");
> +		return -ENOENT;
> +	}
> +	fw_file_pos += 8;
> +
> +	/* byte 8~11 = OMEGA1 fw & script length */
> +	fw_script_len_v1 =
> +	    (fw->data[fw_file_pos]) + (fw->data[fw_file_pos + 1] << 8) +
> +	    (fw->data[fw_file_pos + 2] << 16) +
> +	    (fw->data[fw_file_pos + 3] << 24);
> +	fw_file_pos += 4;
> +	partition_len_v1 = 8 + 4 + fw_script_len_v1;
> +
> +	if (chip_v2) {
> +		fw_file_pos += fw_script_len_v1;
> +		if ((fw->data[fw_file_pos] != 'I')
> +		    || (fw->data[fw_file_pos + 1] != 'T')
> +		    || (fw->data[fw_file_pos + 2] != '9')
> +		    || (fw->data[fw_file_pos + 3] != '1')
> +		    || (fw->data[fw_file_pos + 4] != '3')
> +		    || (fw->data[fw_file_pos + 5] != '5')
> +		    || (fw->data[fw_file_pos + 6] != 'B')
> +		    || (fw->data[fw_file_pos + 7] != 'X')) {
> +			err("IT9135 chip v2 FW format Error");
> +			return -ENOENT;
> +		}
> +		fw_file_pos += 8;
> +
> +		fw_script_len_v2 =
> +		    (fw->data[fw_file_pos]) + (fw->data[fw_file_pos + 1] << 8) +
> +		    (fw->data[fw_file_pos + 2] << 16) +
> +		    (fw->data[fw_file_pos + 3] << 24);
> +		fw_file_pos += 4;
> +
> +		partition_len_v2 = 8 + 4 + fw_script_len_v2;
> +
> +		if (fw->size != (partition_len_v1 + partition_len_v2)) {
> +			err("FW file size error!!");
> +			return -ENOENT;
> +		}
> +	}
> +
> +	/* 32 byte Fw version */
> +	for (i = 0; i < 32; i++)
> +		dev->fw_ver[i] = fw->data[fw_file_pos + i];
> +
> +	dev->fw_ver[31] = '\0';
> +	fw_file_pos += 32;
> +
> +	/*------------------------ Parsing Firmware ------------------------*/
> +
> +	/* byte fw_file_pos+0 ~ +7 = OFDM & LINK version */
> +	dev->link_ver =
> +	    (fw->data[fw_file_pos] << 24) + (fw->data[fw_file_pos + 1] << 16) +
> +	    (fw->data[fw_file_pos + 2] << 8) + (fw->data[fw_file_pos + 3]);
> +	fw_file_pos += 4;
> +
> +	dev->ofdm_ver =
> +	    (fw->data[fw_file_pos] << 24) + (fw->data[fw_file_pos + 1] << 16) +
> +	    (fw->data[fw_file_pos + 2] << 8) + (fw->data[fw_file_pos + 3]);
> +	fw_file_pos += 4;
> +
> +	deb_info("@@@@@@@@@@@@@ Omega 1or2_OFDM ver = 0x%x, LINK ver = 0x%x",
> +		 (unsigned int)dev->link_ver, (unsigned int)dev->ofdm_ver);
> +
> +	/* byte fw_file_pos+0 ~ +3 = FirmwareV2_CODELENGTH */
> +	fw_code_len = fw->data[fw_file_pos] + (fw->data[fw_file_pos + 1] << 8) +
> +	    (fw->data[fw_file_pos + 2] << 16) +
> +	    (fw->data[fw_file_pos + 3] << 24);
> +
> +	fw_file_pos += 4;
> +	/* byte fw_file_pos+0 ~ +3 = FirmwareV2_SEGMENTLENGTH, only first one byte has value */
> +	dev->data.fw_parts = fw->data[fw_file_pos];
> +	fw_file_pos += 4;
> +
> +	/* byte fw_file_pos+0 ~ +3 = FirmwareV2_PARTITIONLENGTH */
> +	if (fw->data[fw_file_pos] != 1) {
> +		err("FirmwareV2_PARTITIONLENGTH != 1 !!");
> +		return -EPERM;
> +	}
> +	fw_file_pos += 4;
> +
> +	/* byte fw_file_pos+0 ~ +(fw_code_len-1) == Fw code */
> +	fw_codes = kzalloc(fw_code_len * sizeof(*fw_codes), GFP_KERNEL);
> +	for (i = 0; i < fw_code_len; i++) {
> +		fw_codes[i] = (unsigned char)fw->data[fw_file_pos + i];
> +	}	
> +	dev->data.fw_codes = fw_codes;
> +
> +	fw_file_pos += fw_code_len;
> +
> +	/* FirmwareV2_segments */
> +	segs = kzalloc(dev->data.fw_parts * sizeof(*segs), GFP_KERNEL);
> +	for (i = 0; i < dev->data.fw_parts; i++) {
> +		segs[i].type = fw->data[fw_file_pos + j];
> +		segs[i].length =
> +		    fw->data[fw_file_pos + j + 1] +
> +		    (fw->data[fw_file_pos + j + 2] << 8) +
> +		    (fw->data[fw_file_pos + j + 3] << 16) +
> +		    (fw->data[fw_file_pos + j + 4] << 24);
> +		j += 5;
> +	}
> +	dev->data.fw_segs = segs;
> +
> +	fw_file_pos += j;
> +
> +	/* FirmwareV2_partitions */
> +	if (dev->data.fw_parts != fw->data[fw_file_pos]) {
> +		err("FirmwareV2_SEGMENTLENGTH != FirmwareV2_partitions[0], parsing error!!!");
> +		return -EPERM;
> +	}
> +
> +	fw_file_pos += 1;
> +
> +	/* FirmwareV2_SCRIPTSETLENGTH == 1 */
> +	if (fw->data[fw_file_pos] != 1) {
> +		err("FirmwareV2_SCRIPTSETLENGTH != 1 !!");
> +		return -EPERM;
> +	}
> +
> +	fw_file_pos += 4;
> +
> +	/* Word FirmwareV2_scriptSets */
> +	script_sets = kzalloc(sizeof(u16), GFP_KERNEL);
> +	*script_sets = fw->data[fw_file_pos] + (fw->data[fw_file_pos + 1] << 8);
> +	dev->data.script_sets = script_sets;
> +
> +	fw_file_pos += 2;
> +
> +	/* FirmwareV2_scripts */
> +	j = 0;
> +	scripts = kzalloc(*script_sets * sizeof(*scripts), GFP_KERNEL);
> +	for (i = 0; i < *script_sets; i++) {
> +		scripts[i].address = fw->data[fw_file_pos + j] +
> +		    (fw->data[fw_file_pos + j + 1] << 8) +
> +		    (fw->data[fw_file_pos + j + 2] << 16) +
> +		    (fw->data[fw_file_pos + j + 3] << 24);
> +
> +		scripts[i].value = fw->data[fw_file_pos + j + 4];
> +		j += 5;
> +	}
> +
> +	dev->data.scripts = scripts;
> +	fw_file_pos += j;
> +
> +	if (chip_v2 && (fw_file_pos == fw->size)) {
> +		info("FW file only include IT9135 v2 firmware");
> +		goto end_of_fw;
> +	} else if (!chip_v2 && (fw_file_pos == partition_len_v1)) {
> +		info("FW file only include IT9135 v1 firmware!");
> +		goto end_of_fw;
> +	}
> +
> +	/*--- Parsing Firmware_Afa_Omega_Script ---*/
> +
> +	dev->data.tuner_script_normal = script_parser(fw, &fw_file_pos,
> +						      &(dev->data.
> +							tuner_script_sets_normal));
> +
> +	if (dev->data.tuner_script_normal == NULL)
> +		return -EPERM;
> +
> +	if (chip_v2 && (fw_file_pos == fw->size)) {
> +		info("~~~ .Fw file only include Omega2 firmware&Omega_Script!!");
> +		goto end_of_fw;
> +	} else if (!chip_v2 && (fw_file_pos == partition_len_v1)) {
> +		info("~~~ .Fw file only include Omega1 firmware&Omega_Script!!");
> +		goto end_of_fw;
> +	}
> +
> +	/*--- Parsing Firmware_Afa_Omega_LNA_Config_1_Script ---*/
> +
> +	dev->data.tuner_script_lna1 =
> +	    script_parser(fw, &fw_file_pos,
> +			  &(dev->data.tuner_script_sets_lna1));
> +
> +	if (dev->data.tuner_script_lna1 == NULL)
> +		return -EPERM;
> +	if (chip_v2 && (fw_file_pos == fw->size)) {
> +		info("~~~ .Fw file only include Omega2 firmware Script1!!");
> +		goto end_of_fw;
> +	} else if (!chip_v2 && (fw_file_pos == partition_len_v1)) {
> +		info("~~~ .Fw file only include Omega1 firmware, Script1!!");
> +		goto end_of_fw;
> +	}
> +
> +	/*--- Parsing Firmware_Afa_Omega_LNA_Config_2_Script_V2 ---*/
> +	dev->data.tuner_script_lna2 =
> +	    script_parser(fw, &fw_file_pos,
> +			  &(dev->data.tuner_script_sets_lna2));
> +
> +	if (dev->data.tuner_script_lna2 == NULL)
> +		return -EPERM;
> +
> +	if (chip_v2 && (fw_file_pos == fw->size)) {
> +		info("~~~ .Fw file only include Omega2 firmware, Scripts1&2!!");
> +		goto end_of_fw;
> +	} else if (!chip_v2 && (fw_file_pos == partition_len_v1)) {
> +		info("~~~ .Fw file only include Omega1 firmware, Scripts1&2!!");
> +		goto end_of_fw;
> +	}
> +
> +end_of_fw:
> +
> +	/**** Init Device first ****/
> +	retval = it9135_device_init(udev, dev, true);
> +	if (retval) {
> +		if (retval)
> +			err("device_init Fail: 0x%08x\n", retval);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < it9135_device_count; i++) {
> +		if (dev->architecture == ARCHITECTURE_PIP) {
> +			deb_info("@@@@@@@ adapter == 2");


What does that "@@@@@@" mean?

> +			it9135_properties[i].num_adapters = 2;
> +			it9135_properties[i].caps = DVB_USB_IS_AN_I2C_ADAPTER;
> +		} else {
> +			deb_info("@@@@@@@ adapter == 1");
> +			it9135_properties[i].caps = 0;
> +			it9135_properties[i].num_adapters = 1;
> +		}
> +
> +		/* USB1.1 set smaller buffersize and disable 2nd adapter */
> +		if (udev->speed == USB_SPEED_FULL) {
> +			it9135_properties[i].adapter[0].stream.u.bulk.buffersize
> +			    = (188 * 21);
> +		} else {
> +			it9135_properties[i].adapter[0].stream.u.bulk.buffersize
> +			    = (188 * 348);
> +		}
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static int it9135_power_ctrl(struct dvb_usb_device *d, int onoff)
> +{
> +	return 0;
> +}
> +
> +static int it9135_identify_state(struct usb_device *udev,
> +				 struct dvb_usb_device_properties *props,
> +				 struct dvb_usb_device_description **desc,
> +				 int *cold)
> +{
> +	/* *cold = 0; */
> +	return 0;
> +}
> +
> +static int it9135_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
> +			   int num)
> +{
> +	return 0;
> +}
> +
> +static u32 it9135_i2c_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static struct i2c_algorithm it9135_i2c_algo = {
> +	.master_xfer = it9135_i2c_xfer,
> +	.functionality = it9135_i2c_func,
> +};
> +
> +/* Called to attach the possible frontends */
> +static int it9135_frontend_attach(struct dvb_usb_adapter *adap)
> +{
> +	deb_func("Enter %s Function - chip=%d\n", __func__, adap->id);
> +
> +	adap->fe = it9135_attach(adap);
> +
> +	return adap->fe == NULL ? -ENODEV : 0;
> +}
> +
> +static int it9135_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
> +{
> +	deb_func("Enter %s Function - (%s) streaming state for chip=%d\n",
> +		 __func__, onoff ? "ON" : "OFF", adap->id);
> +
> +	return 0;
> +}
> +
> +/* -------------------------------------------------------------------------- */
> +
> +/* ******* IT9135 DVB USB DEVICE ******* */
> +
> +/* Table of devices that work with this driver */
> +struct usb_device_id it9135_usb_id_table[] = {
> +	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135)},
> +	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005)},
> +	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006)},
> +	{0},			/* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, it9135_usb_id_table);
> +
> +struct dvb_usb_device_properties it9135_properties[] = {
> +	{
> +	 .caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	 .download_firmware = it9135_download_firmware,
> +	 .firmware = "dvb-usb-it9135.fw",
> +
> +	 .size_of_priv = sizeof(struct it9135_state),
> +	 .i2c_algo = &it9135_i2c_algo,
> +
> +	 .usb_ctrl = DEVICE_SPECIFIC,
> +
> +	 .no_reconnect = 1,
> +	 .power_ctrl = it9135_power_ctrl,
> +	 .identify_state = it9135_identify_state,
> +	 .num_adapters = 2,
> +	 .adapter = {
> +		     {
> +		      .caps =
> +		      DVB_USB_ADAP_HAS_PID_FILTER |
> +		      DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
> +
> +		      .pid_filter_count = 32,
> +		      .pid_filter = it9135_pid_filter,
> +		      .pid_filter_ctrl = it9135_pid_filter_ctrl,
> +		      .frontend_attach = it9135_frontend_attach,
> +		      .streaming_ctrl = it9135_streaming_ctrl,
> +		      .stream = {
> +				 .type = USB_BULK,
> +				 .count = 4,
> +				 .endpoint = 0x84,
> +				 .u = {
> +				       .bulk = {
> +						.buffersize = (188 * 348),
> +						}
> +				       }
> +				 }
> +		      },
> +		     {
> +		      .caps =
> +		      DVB_USB_ADAP_HAS_PID_FILTER |
> +		      DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
> +
> +		      .pid_filter_count = 32,
> +		      .pid_filter = it9135_pid_filter,
> +		      .pid_filter_ctrl = it9135_pid_filter_ctrl,
> +		      .frontend_attach = it9135_frontend_attach,
> +		      .streaming_ctrl = it9135_streaming_ctrl,
> +		      .stream = {
> +				 .type = USB_BULK,
> +				 .count = 4,
> +				 .endpoint = 0x85,
> +				 .u = {
> +				       .bulk = {
> +						.buffersize = (188 * 348),
> +						}
> +				       }
> +				 }
> +		      },
> +		     },

Hmm... from the above code, it seems that remote controller is supported. However, I'm not seeing
it referenced here.

> +	 .num_device_descs = 1,
> +	 .devices = {
> +		     {"ITEtech USB2.0 DVB-T Recevier",
> +		      {&it9135_usb_id_table[0], &it9135_usb_id_table[1],
> +		       &it9135_usb_id_table[2], NULL},
> +		      {NULL},
> +		      },
> +		     {NULL},
> +
> +		     }
> +	 }
> +};
> +
> +int it9135_device_count = ARRAY_SIZE(it9135_properties);
> +
> +/* Register a DVB_USB device and a USB device node end */
> +static int it9135_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	int retval = -ENOMEM;
> +	int i;
> +	struct dvb_usb_device *d = NULL;
> +
> +	if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {
> +
> +		if (it9135_device_count > 2)
> +			it9135_device_count = 2;
> +
> +		for (i = 0; i < it9135_device_count; i++) {
> +			retval =
> +			    dvb_usb_device_init(intf, &it9135_properties[i],
> +						THIS_MODULE, &d, adapter_nr);
> +
> +			if (!retval) {
> +				deb_info("dvb_usb_device_init success!!\n");
> +				break;
> +			}
> +			if (retval != -ENODEV)
> +				return retval;
> +		}
> +		if (retval)
> +			return retval;
> +	}
> +
> +	return retval;
> +}
> +
> +static int it9135_suspend(struct usb_interface *intf, pm_message_t state)
> +{
> +	deb_func("Enter %s Function\n", __func__);
> +	return 0;
> +}
> +
> +static int it9135_resume(struct usb_interface *intf)
> +{
> +	deb_func("Enter %s Function\n", __func__);
> +	return 0;
> +}
> +
> +static int it9135_reset_resume(struct usb_interface *intf)
> +{
> +	int retval = -ENOMEM;
> +	int i;
> +	struct it9135_dev_ctx *dev = NULL;
> +	struct usb_device *udev;
> +
> +	deb_func("Enter %s Function\n", __func__);
> +
> +	udev = interface_to_usbdev(intf);
> +	dev = dev_get_drvdata(&udev->dev);
> +
> +	retval = it9135_device_init(udev, dev, 1);
> +	if (retval) {
> +		if (retval)
> +			err("device_init Fail: 0x%08x", retval);
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < dev->data.chip_num; i++)
> +		it9135_dl_ap_ctrl(dev, i, 1);
> +
> +	return 0;
> +}
> +
> +static void it9135_i2c_exit(struct dvb_usb_device *d)
> +{
> +	struct it9135_state *state = d->priv;
> +
> +	deb_func("%s:\n", __func__);
> +
> +	/* remove 2nd I2C adapter */
> +	if (d->state & DVB_USB_STATE_I2C) {
> +		try_module_get(THIS_MODULE);
> +		i2c_del_adapter(&state->i2c_adap);
> +	}
> +}
> +
> +static void it9135_disconnect(struct usb_interface *intf)
> +{
> +	struct it9135_dev_ctx *dev;
> +	struct usb_device *udev;
> +	int minor = intf->minor;
> +	struct dvb_usb_device *d = usb_get_intfdata(intf);
> +
> +	deb_func("%s:\n", __func__);
> +
> +	udev = interface_to_usbdev(intf);
> +	dev = dev_get_drvdata(&udev->dev);
> +	dev->disconnect = 1;
> +
> +	kfree(dev->data.script_sets);
> +	kfree(dev->data.scripts);
> +	kfree(dev->data.fw_codes);
> +	kfree(dev->data.fw_segs);
> +	kfree(dev->data.tuner_script_normal);
> +	kfree(dev->data.tuner_script_lna1);
> +	kfree(dev->data.tuner_script_lna2);
> +	kfree(dev);
> +
> +	/* remove 2nd I2C adapter */
> +	if (d != NULL && d->desc != NULL)
> +		it9135_i2c_exit(d);
> +
> +	try_module_get(THIS_MODULE);
> +	dvb_usb_device_exit(intf);
> +
> +	deb_info("ITEtech USB #%d now disconnected", minor);
> +}
> +
> +static struct usb_driver it9135_driver = {
> +	.name = "dvb_usb_it9135",
> +	.probe = it9135_probe,
> +	.disconnect = it9135_disconnect,
> +	.id_table = it9135_usb_id_table,
> +	.suspend = it9135_suspend,
> +	.resume = it9135_resume,
> +	.reset_resume = it9135_reset_resume,
> +};
> +
> +/* Insert it9135 module and prepare to register it9135 driver */
> +static int __init it9135_module_init(void)
> +{
> +	int ret;
> +
> +	deb_info("dvb_usb_it9135 Module is loaded\n");
> +
> +	ret = usb_register(&it9135_driver);
> +
> +	if (ret) {
> +		err("usb_register failed. Error number %d", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Deregister this driver with the USB subsystem */
> +static void __exit it9135_module_exit(void)
> +{
> +	deb_info("dvb_usb_it9135 Module is unloaded!\n");
> +	usb_deregister(&it9135_driver);
> +}
> +
> +module_init(it9135_module_init);
> +module_exit(it9135_module_exit);
> +
> +MODULE_AUTHOR("Jason Dong <jason.dong@ite.com.tw>");
> +MODULE_DESCRIPTION("Driver for devices based on ITEtech IT9135");
> +MODULE_VERSION(DRIVER_RELEASE_VERSION);
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/dvb-usb/it9135.h b/drivers/media/dvb/dvb-usb/it9135.h
> new file mode 100644
> index 0000000..d1cf54c
> --- /dev/null
> +++ b/drivers/media/dvb/dvb-usb/it9135.h
> @@ -0,0 +1,155 @@
> +/*
> + * DVB USB Linux driver for IT9135 DVB-T USB2.0 receiver
> + *
> + * Copyright (C) 2011 ITE Technologies, INC.
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + */
> +
> +#ifndef _IT9135_H_
> +#define _IT9135_H_
> +
> +#define DVB_USB_LOG_PREFIX "IT9135"
> +
> +#include <linux/version.h>
> +
> +#include "dvb-usb.h"
> +#include "it9135-fe.h"
> +
> +#define DRIVER_RELEASE_VERSION	"v11.08.02.1"
> +/* **************** customization **************** */
> +extern int dvb_usb_it9135_debug;
> +
> +#ifdef CONFIG_DVB_USB_IT9135_DEBUG
> +#define deb_func(args...)	printk(KERN_INFO args)
> +#define deb_info(args...)	printk(KERN_INFO args)
> +#define deb_warning(args...)	printk(KERN_INFO args)
> +#define dmg(format, arg...)	printk(KERN_ERR DVB_USB_LOG_PREFIX "::" "%s: " format "\n" , __func__, ## arg)
> +#else
> +#define deb_func(args...)	dprintk(dvb_usb_it9135_debug, 0x01, args)
> +#define deb_info(args...)	dprintk(dvb_usb_it9135_debug, 0x02, args)
> +#define deb_warning(args...)	dprintk(dvb_usb_it9135_debug, 0x04, args)
> +#define dmg(format, arg...)	printk(KERN_ERR DVB_USB_LOG_PREFIX "::" "%s: " format "\n" , __func__, ## arg)
> +#endif
> +/* **************** from device.h **************** */
> +#define IT9135_TS_PACKET_SIZE		188
> +#define IT9135_TS_PACKET_COUNT_HI	348
> +#define IT9135_TS_PACKET_COUNT_FU	21
> +
> +/* **************** from driver.h **************** */
> +#define IT9135_TS_FRAMES_HI		128
> +#define IT9135_TS_FRAMES_FU		128
> +#define IT9135_MAX_USB20_IRP_NUM	5
> +#define IT9135_MAX_USB11_IRP_NUM	2
> +
> +/* **************** from afdrv.h **************** */
> +#define EEPROM_FLB_OFS		8
> +
> +#define EEPROM_IRMODE       (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x10)	/* 00:disabled, 01:HID */
> +#define EEPROM_SELSUSPEND   (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28)	/* Selective Suspend Mode */
> +#define EEPROM_TSMODE       (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+1)	/* 0:one ts, 1:dual ts */
> +#define EEPROM_2WIREADDR    (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+2)	/* MPEG2 2WireAddr */
> +#define EEPROM_SUSPEND      (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+3)	/* Suspend Mode */
> +#define EEPROM_IRTYPE       (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+4)	/* 0:NEC, 1:RC6 */
> +#define EEPROM_SAWBW1       (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+5)
> +#define EEPROM_XTAL1        (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+6)	/* 0:28800, 1:20480 */
> +#define EEPROM_SPECINV1     (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x28+7)
> +#define EEPROM_TUNERID      (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x30+4)
> +#define EEPROM_IFFREQL      (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x30)
> +#define EEPROM_IFFREQH      (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x30+1)
> +#define EEPROM_IF1L         (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x30+2)
> +#define EEPROM_IF1H         (OVA_EEPROM_CFG+EEPROM_FLB_OFS+0x30+3)
> +#define EEPROM_SHIFT        (0x10)	/* EEPROM Addr Shift for slave front end */
> +
> +/* **************** from device.h **************** */
> +struct it9135_state {
> +	struct i2c_adapter i2c_adap;	/* I2C adapter for 2nd FE */
> +	u8 rc_repeat;
> +	u32 rc_keycode;
> +};
> +
> +struct it9135_tuner_info {
> +	int inited;
> +	int setting_freq;
> +	unsigned short id;
> +	int set;
> +	int locked;
> +};
> +
> +struct it9135_filter_ctx_hw {
> +	struct it9135_tuner_info tuner_info;
> +	unsigned long curr_freq;
> +	unsigned short curr_bw;
> +	unsigned long desired_freq;
> +	unsigned short desired_bw;
> +	int timer_on;
> +	int en_pid;
> +	int ap_on;
> +	int reset_ts;
> +	unsigned char ovr_flw_chk;
> +};
> +
> +/* IT9135 device context */
> +struct it9135_dev_ctx {
> +	struct it9135_filter_ctx_hw fc[2];
> +	struct mutex it9135_mutex;
> +	int boot_code;
> +	int ep12_err;
> +	int ep45_err;
> +	int dual_ts;
> +	int ir_tab_load;
> +	int proprietary_ir;
> +	u8 ir_type;		/* EE chose NEC RC5 RC6 table */
> +	int surprise_removal;
> +	int dev_not_resp;
> +	int enter_suspend;
> +	u16 usb_mode;
> +	u16 max_packet_sz;
> +	u32 ts_frames;
> +	u32 ts_frame_sz;
> +	u32 ts_frame_sz_dw;
> +	u32 ts_packet_cnt;
> +	int selective_suspend;
> +	u32 active_filter;
> +	unsigned char architecture;
> +	unsigned char stream_type;
> +	int dca_pip;
> +	int swap_filter;
> +	u8 filter_cnt;
> +	u8 filter_index;
> +	int tuner_pw_off;
> +	u8 usb_ctrl_timeOut;
> +	struct it9135_data data;
> +	int disconnect;
> +	/* patch for Om1 Om2 EE */
> +	unsigned char chip_ver;
> +	int already_nim_reset_seq;
> +	/* Fw versiion */
> +	u32 ofdm_ver;
> +	u32 link_ver;
> +	u8 fw_ver[32];
> +
> +};
> +
> +struct it9135_ofdm_channel {
> +	u32 rf_khz;
> +	u8 bw;
> +	s16 nfft;
> +	s16 guard;
> +	s16 nqam;
> +	s16 vit_hrch;
> +	s16 vit_select_hp;
> +	s16 vit_alpha;
> +	s16 vit_code_rate_hp;
> +	s16 vit_code_rate_lp;
> +	u8 intlv_native;
> +};
> +
> +/**********************************************/
> +
> +extern int it9135_device_count;
> +
> +#endif

