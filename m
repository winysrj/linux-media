Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:36277 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753253AbZKTX7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 18:59:03 -0500
Message-ID: <4B072D3F.8060807@stud.uni-hannover.de>
Date: Sat, 21 Nov 2009 00:58:55 +0100
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: magnus@alefors.se
CC: linux-media@vger.kernel.org
Subject: Re: SV: [linux-dvb] NOVA-TD exeriences?
References: <4AEF5FE5.2000607@stud.uni-hannover.de> <4AF162BC.4010700@stud.uni-hannover.de> <4B0694F7.7070604@stud.uni-hannover.de> <4B06A22D.4090404@stud.uni-hannover.de>
In-Reply-To: <4B06A22D.4090404@stud.uni-hannover.de>
Content-Type: multipart/mixed;
 boundary="------------010306020301050409040507"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010306020301050409040507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Soeren Moch schrieb:
>  > >  > Hi again. Just got my two new NOVA-TD's and at a first glance they
>  > > seemed to
>  > >  > perform well. Closer inspections however revealed that I see 
> exactly
>  > > the same
>  > >  > issues as Soeren. Watching live TV with VDR on one adaptor while
>  > > constantly
>  > >  > retuning the other one using:
>  > >  > while true;do tzap -x svt1;done
>  > >  > gives a short glitch in the VDR stream on almost every tzap. 
> Another
>  > > 100EUR down
>  > >  > the drain. I'll probably buy four NOVA-T's instead just like I
>  > > planned to at
>  > >  > first.
>  > >  >
>  > >  > /Magnus H
>  > >
>  > > Slowly, slowly. Magnus, you want to support dibcom with another 
> 100EUR for
>  > > there poor performance in fixing the firmware?
>  > > Please test my patches, the nova-td is running fine with these 
> patches,
>  > > at least for me.
>  > >
>  > > Patrick, any progress here? Will dibcom fix the firmware, or will you
>  > > integrate the
>  > > patches? Or what can I do to go on?
>  > >
>  > > Regards,
>  > > Soeren
>  > >
>  > >
>  >
>  > Thanks Soeren, maybe I jumped to the wrong conclusions here. I actually
>  > thought this came down to bad hardware design instead of a 
> driver/firmware
>  > issue. Unfortunately your patches made no difference here but I won't 
> give
>  > up that easily. If they made your problems disapperar there should be 
> hope
>  > for me too and I'll be glad to help in the development. I can live 
> with the
>  > glitches in the mean time if there's hope for improvement since I mostly
>  > watch DVB-S these days. I'm running the stock Ubuntu Karmic 2.6.31 
> kernel
>  > and standard linuxtv drivers from hg. I also have four TT S2-1600 
> cards in
>  > there.
>  > /Magnus
> 
> Magnus, can you send the USB-IDs of your nova-td-sticks, please?
> Since I activated the workaround only for stk7700d_dib7000p_mt2266,
> there might be another funtion to fix your sticks.
> 
> Soeren
> 
> 

OK, my nova-td device id is 2040:9580, for 2040:5200 the attached extended
patch version may help. (I have no access to such device.)
Please test.

Soeren


--------------010306020301050409040507
Content-Type: text/x-patch;
 name="nova-td2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nova-td2.patch"

--- linux.orig/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-11-20 23:39:51.000000000 +0100
+++ linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-11-21 00:47:09.000000000 +0100
@@ -303,6 +303,9 @@ static int stk7700d_frontend_attach(stru
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
 				&stk7700d_dib7000p_mt2266_config[adap->id]);
 
+        adap->props.streaming_ctrl = NULL;
+        dib0700_streaming_ctrl(adap, 1);
+
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
@@ -1710,12 +1713,20 @@ static int stk7070pd_frontend_attach0(st
 	}
 
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
+
+        adap->props.streaming_ctrl = NULL;
+        dib0700_streaming_ctrl(adap, 1);
+
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
 static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 {
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
+
+        adap->props.streaming_ctrl = NULL;
+        dib0700_streaming_ctrl(adap, 1);
+
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
@@ -1968,7 +1979,7 @@ MODULE_DEVICE_TABLE(usb, dib0700_usb_id_
 	.streaming_ctrl   = dib0700_streaming_ctrl, \
 	.stream = { \
 		.type = USB_BULK, \
-		.count = 4, \
+		.count = 1, \
 		.endpoint = ep, \
 		.u = { \
 			.bulk = { \

--------------010306020301050409040507--
