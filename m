Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32736 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZANSOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 13:14:48 -0500
Message-ID: <496E2B96.8060404@iki.fi>
Date: Wed, 14 Jan 2009 20:14:46 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2] Add Freescale MC44S803 tuner driver
References: <496E2912.8030604@scram.de>
In-Reply-To: <496E2912.8030604@scram.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Jochen,
Jochen Friedrich wrote:
> Changes since v1:
> - rebase against official linux tree. v1 was based against a local tree and didn't apply cleanly.

Now it applies cleanly, but didn't compile. Some header file is missing.

Antti

   CC [M]  /home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mxl5007t.o
   CC [M]  /home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.o
/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c: In function 
'mc44s803_attach':
/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c:339: error: 
'KERN_ERROR' undeclared (first use in this function)
/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c:339: error: 
(Each undeclared identifier is reported only once
/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c:339: error: 
for each function it appears in.)
/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.c:339: error: 
expected ')' before string constant
make[3]: *** [/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l/mc44s803.o] 
Error 1
make[2]: *** [_module_/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l] 
Error 2
make[2]: Leaving directory `/usr/src/kernels/2.6.27.9-159.fc10.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/crope/linuxtv/code/af9015/81/v4l-dvb/v4l'
make: *** [all] Error 2
[crope@localhost v4l-dvb]$


-- 
http://palosaari.fi/
