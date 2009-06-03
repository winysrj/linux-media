Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:40326 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752764AbZFCLhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 07:37:54 -0400
Message-ID: <20090603133631.159278y5l7uv8x0k@www.stud.uni-hannover.de>
Date: Wed, 03 Jun 2009 13:36:31 +0200
From: Soeren.Moch@stud.uni-hannover.de
To: patrick.boettcher@desy.de
Cc: linux-media@vger.kernel.org
Subject: Re: dib0700 Nova-TD-Stick problem
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_7761a0cu3sco"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is in MIME format.

--=_7761a0cu3sco
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Soeren.Moch wrote:
> For a few weeks I use a Nova-TD-Stick and was annoyed with dvb stream
> errors, although the demod bit-error-rate (BER/UNC) was zero.
>
> I could track down this problem to dib0700_streaming_ctrl:
> When one channel is streaming and the other channel is switched on, the
> stream of the already running channel gets broken.
>
> I think this is a firmware bug and should be fixed there, but I attach a
> driver patch, which solved the problem for me. (Kernel 2.6.29.1, FW
> 1.20, Nova-T-Stick + Nova-TD-Stick used together). Since I had to reduce
> the urb count to 1, I consider this patch as quick hack, not a real
> solution.
>
> Probably the same problem exists with other dib0700 diversity/dual
> devices, without a firmware fix a similar driver patch may be helpful.
>
> Regards,
> Soeren
>

Hi Patrick,

do you see any chance that somebody will fix the firmware? If not, can  
you take
into consideration to remove the dib0700_streaming_ctrl callback as in the
(again) attached patch so solve the switch-on problem?
The patch runs flawlessly on my vdr system for weeks now. There are no  
negative
side effects from reducing the urb count to 1.

If you prefer a patch that removes the callback for all dib0700 devices or
only for all dual devices, I can prepare that. But I can test it only with
Nova-T-Stick and Nova-TD-Stick.

Regards,
Soeren



--=_7761a0cu3sco
Content-Type: text/x-patch;
 charset=UTF-8;
 name="nova-td.patch"
Content-Disposition: attachment;
 filename="nova-td.patch"
Content-Transfer-Encoding: 7bit

--- drivers/media/dvb/dvb-usb/dib0700_devices.c.orig	2009-04-18 16:45:12.000000000 +0200
+++ drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-04-18 18:58:54.000000000 +0200
@@ -290,6 +290,9 @@ static int stk7700d_frontend_attach(stru
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
 				&stk7700d_dib7000p_mt2266_config[adap->id]);
 
+        adap->props.streaming_ctrl = NULL;
+        dib0700_streaming_ctrl(adap, 1);
+
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
@@ -1414,7 +1417,7 @@ MODULE_DEVICE_TABLE(usb, dib0700_usb_id_
 	.streaming_ctrl   = dib0700_streaming_ctrl, \
 	.stream = { \
 		.type = USB_BULK, \
-		.count = 4, \
+		.count = 1, \
 		.endpoint = ep, \
 		.u = { \
 			.bulk = { \

--=_7761a0cu3sco--

