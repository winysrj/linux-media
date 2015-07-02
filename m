Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35111 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbbGBXCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2015 19:02:18 -0400
Received: by wgjx7 with SMTP id x7so74572818wgj.2
        for <linux-media@vger.kernel.org>; Thu, 02 Jul 2015 16:02:17 -0700 (PDT)
From: poma <pomidorabelisima@gmail.com>
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >= 4.1.x
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
References: <554C8E04.5090007@gmail.com> <554C9704.2040503@gmail.com>
 <554F352F.10301@gmail.com> <554FDAE7.4010906@gmail.com>
 <5550F842.3050604@gmail.com> <55520A08.1010605@iki.fi>
 <5552CB67.8070106@gmail.com> <5557CDBE.2030806@iki.fi>
 <555A3A48.2010002@gmail.com> <555E4CEF.4000901@gmail.com>
 <556465E1.8000009@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <5595C2F5.3090508@gmail.com>
Date: Fri, 3 Jul 2015 01:02:13 +0200
MIME-Version: 1.0
In-Reply-To: <556465E1.8000009@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.05.2015 14:24, poma wrote:
> 
> If it is not taken into account the already known problem of unreliable operation of the first tuner of the two,
> the device works reliably within kernel 4.0.4 with mxl5007t.ko reverted to
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/tuners/mxl5007t.c?id=ccae7af
> that is in the same state as is in the longterm kernel - 3.18.14,
> which is in correspondence with the aforementioned results.
> 
> 

http://git.linuxtv.org/cgit.cgi/media_tree.git/log/drivers/media/tuners/mxl5007t.c


5. 2014-11-11   [media] [PATH,2/2] mxl5007 move loop_thru to attach
   02f9cf9      Jose Alberto Reguero
   
4. 2014-11-11   [media] [PATH,1/2] mxl5007 move reset to attach
   fe4860a      Jose Alberto Reguero

3. 2013-02-08   Revert "[media] [PATH,1/2] mxl5007 move reset to attach"
   db5c05b      Mauro Carvalho Chehab

2. 2013-02-08   [media] [PATH,1/2] mxl5007 move reset to attach
   0a32377      Jose Alberto Reguero

1. 2012-08-14   [media] common: move media/common/tuners to media/tuners
   ccae7af      Mauro Carvalho Chehab


This is the conclusion after extensive testing,
commitas 5. 4. and 2. produce:

mxl5007t_soft_reset: 521: failed!
mxl5007t_attach: error -121 on line 907

causing the device completely unusable - AF9015 DVB-T USB2.0 stick


Do you need a patch to revert to commita 3. or 1. - again for the third time,
or you have a better solution?


