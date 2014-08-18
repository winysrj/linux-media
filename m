Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:30262 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaHRPKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 11:10:12 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAI00LXDCSWU380@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Aug 2014 11:10:08 -0400 (EDT)
Date: Mon, 18 Aug 2014 10:10:05 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Bimow Chen <Bimow.Chen@ite.com.tw>
Cc: linux-firmware@kernel.org, linux-media@vger.kernel.org
Subject: Re: linux-firmware: Add firmware v3.25.0.0 for ITEtech IT9135 DVB-T
 USB driver
Message-id: <20140818101005.553f7765.m.chehab@samsung.com>
In-reply-to: <1408340171.7346.4.camel@ite-desktop>
References: <1408340171.7346.4.camel@ite-desktop>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Chen,

Em Mon, 18 Aug 2014 13:36:11 +0800
Bimow Chen <Bimow.Chen@ite.com.tw> escreveu:

> From 7f12471b97ff0a81a97d9133e10a5ebe4e7c0c11 Mon Sep 17 00:00:00 2001
> From: Bimow Chen <Bimow.Chen@ite.com.tw>
> Date: Fri, 15 Aug 2014 13:44:19 +0800
> Subject: [PATCH] it9135: add firmware v3.25.0.0 for ITEtech IT9135 DVB-T USB driver
> 
> Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
> ---
>  WHENCE               |   10 ++++++++++
>  dvb-usb-it9135-01.fw |  Bin 0 -> 8128 bytes
>  dvb-usb-it9135-02.fw |  Bin 0 -> 5834 bytes
>  3 files changed, 10 insertions(+), 0 deletions(-)
>  create mode 100644 dvb-usb-it9135-01.fw
>  create mode 100644 dvb-usb-it9135-02.fw
> 
> diff --git a/WHENCE b/WHENCE
> index bd65d8c..9c0ca10 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2503,3 +2503,13 @@ File: intel/fw_sst_0f28.bin-48kHz_i2s_master
>  License: Redistributable. See LICENCE.fw_sst_0f28 for details
>  
>  --------------------------------------------------------------------------
> +
> +Driver: it9135 -- ITEtech IT913x DVB-T USB driver
> +
> +File: dvb-usb-it9135-01.fw
> +File: dvb-usb-it9135-02.fw
> +Version: 3.25.0.0
> +
> +Licence: GPLv2 or later

Hmm... Licence GPLv2 actually means that you would be releasing the
source code for the firmware, but you're actually granting license
for using your binary firmwares. So, you need to correct the licensing
terms here. There are several models that you can follow at the
WHENCE file and at the LICENCE.* files for binary only firmwares.

Just to help you to decide, there are 3 models of licence commonly
used by media drivers:

Model 1:

 Permission to use, copy, modify, and/or distribute this software, only
 for use with ITE ICs, for any purpose with or without fee is hereby
 granted, provided that the above copyright notice and this permission
 notice appear in all source code copies.

Model 2:

 Permission is hereby granted for the distribution of this firmware
 as part of Linux or other Open Source operating system kernel
 provided this copyright notice is accompanying it.

Model 3:

 ITE grants permission to use and redistribute these firmware
 files for use with IT devices, but not as a part of the Linux
 kernel or in any other form which would require these files themselves
 to be covered by the terms of the GNU General Public License.
 These firmware files are distributed in the hope that they will be
 useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Regards,
Mauro
