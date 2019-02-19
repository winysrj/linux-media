Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CA5C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 22:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA2B82147A
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 22:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfBSWv1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 17:51:27 -0500
Received: from relayout03-q01.e.movistar.es ([86.109.101.161]:27885 "EHLO
        relayout03-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728001AbfBSWv1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 17:51:27 -0500
Received: from relayout03-redir.e.movistar.es (relayout03-redir.e.movistar.es [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 443wvZ6rdpzQk76;
        Tue, 19 Feb 2019 23:51:22 +0100 (CET)
Received: from [192.168.0.161] (static-146-187-224-77.ipcom.comunitel.net [77.224.187.146])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPA id 443wvY2NPFzMlSW;
        Tue, 19 Feb 2019 23:51:21 +0100 (CET)
Date:   Tue, 19 Feb 2019 23:51:25 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20190219215731.ktm7zpcnyv7y46ok@gofer.mess.org>
References: <cba5b0fd-d626-4736-a017-5a1edf35283e.maildroid@localhost> <20190219215731.ktm7zpcnyv7y46ok@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] Add suport for Avermedia TD310
To:     Sean Young <sean@mess.org>,
        Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
CC:     linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <FF598AFC-D10A-46B6-B8D7-7D71BB65355A@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 77.224.187.146 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout03
X-TnetOut-MsgID: 443wvY2NPFzMlSW.A86AF
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1551221482.82599@kyUyFWXh2Mw4EmhKb29xCg
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

El 19 de febrero de 2019 22:57:31 CET, Sean Young <sean@mess.org> escribió:
>On Mon, Feb 11, 2019 at 11:13:25PM +0100, Jose Alberto Reguero wrote:
>> This patch add support for Avermedia TD310 usb stik.
>> This patch must be aplied after this one:
>> https://patchwork.linuxtv.org/patch/40087/
>
>That patch is marked Changes Requested. Please fix that patch first,
>and then re-submit.
>
>Thanks,
>Sean
>

The patch that that need changes is the other one of the serie, the one for the si2157. This one can be applyed like this.

Thanks.

Jose Alberto

>> 
>> Signed-off-by: Jose Alberto Reguero <jose.alberto.reguero@gmail.com>
>> 
>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
>linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
>> --- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-11
>14:48:58.133751038 +0100
>> +++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2019-02-11
>15:02:10.646718610 +0100
>> @@ -1215,6 +1215,7 @@ static int it930x_frontend_attach(struct
>>  	int ret;
>>  	struct si2168_config si2168_config;
>>  	struct i2c_adapter *adapter;
>> +	u8 i2c_addr;
>>  
>>  	dev_dbg(&intf->dev, "%s  adap->id=%d\n", __func__, adap->id);
>>  
>> @@ -1266,7 +1267,11 @@ static int it930x_frontend_attach(struct
>>  
>>  	state->af9033_config[adap->id].fe = &adap->fe[0];
>>  	state->af9033_config[adap->id].ops = &state->ops;
>> -	ret = af9035_add_i2c_dev(d, "si2168", 0x67, &si2168_config,
>> +	i2c_addr = 0x67;
>> +	if ((le16_to_cpu(d->udev->descriptor.idVendor) ==
>USB_VID_AVERMEDIA) &&
>> +			(le16_to_cpu(d->udev->descriptor.idProduct) ==
>USB_PID_AVERMEDIA_TD310))
>> +		i2c_addr = 0x64;
>> +	ret = af9035_add_i2c_dev(d, "si2168", i2c_addr, &si2168_config,
>>  				&d->i2c_adap);
>>  	if (ret)
>>  		goto err;
>> @@ -1613,6 +1618,7 @@ static int it930x_tuner_attach(struct dv
>>  	struct usb_interface *intf = d->intf;
>>  	int ret;
>>  	struct si2157_config si2157_config;
>> +	u8 i2c_addr;
>>  
>>  	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
>>  
>> @@ -1661,7 +1667,13 @@ static int it930x_tuner_attach(struct dv
>>  	memset(&si2157_config, 0, sizeof(si2157_config));
>>  	si2157_config.fe = adap->fe[0];
>>  	si2157_config.if_port = 1;
>> -	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
>> +	i2c_addr = 0x63;
>> +	if ((le16_to_cpu(d->udev->descriptor.idVendor) ==
>USB_VID_AVERMEDIA) &&
>> +			(le16_to_cpu(d->udev->descriptor.idProduct) ==
>USB_PID_AVERMEDIA_TD310)) {
>> +		i2c_addr = 0x60;
>> +		si2157_config.if_port = 0;
>> +	}
>> +	ret = af9035_add_i2c_dev(d, "si2157", i2c_addr,
>>  			&si2157_config, state->i2c_adapter_demod);
>>  
>>  	if (ret)
>> @@ -2169,6 +2181,8 @@ static const struct usb_device_id af9035
>>  	/* IT930x devices */
>>  	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
>>  		&it930x_props, "ITE 9303 Generic", NULL) },
>> +	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD310,
>> +		&it930x_props, "AVerMedia TD310 DVB-T2", NULL) },
>>  	{ }
>>  };
>>  MODULE_DEVICE_TABLE(usb, af9035_id_table);
>> diff -upr linux/include/media/dvb-usb-ids.h
>linux.new/include/media/dvb-usb-ids.h
>> --- linux/include/media/dvb-usb-ids.h	2018-05-05 07:40:18.000000000
>+0200
>> +++ linux.new/include/media/dvb-usb-ids.h	2019-02-08
>22:00:24.765541474 +0100
>> @@ -258,6 +258,7 @@
>>  #define USB_PID_AVERMEDIA_A867				0xa867
>>  #define USB_PID_AVERMEDIA_H335				0x0335
>>  #define USB_PID_AVERMEDIA_TD110				0xa110
>> +#define USB_PID_AVERMEDIA_TD310				0x1871
>>  #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
>>  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>>  #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
>> 
>> 
>> 
>> Sent from MailDroid


-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
