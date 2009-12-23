Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34238 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZLWPxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 10:53:21 -0500
Received: by bwz27 with SMTP id 27so4827117bwz.21
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 07:53:20 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: =?utf-8?q?Alja=C5=BE_Prusnik?= <prusnik@gmail.com>
Subject: Re: Which modules for the VP-2033? Where is the module "mantis.ko"?
Date: Wed, 23 Dec 2009 17:53:28 +0200
Cc: linux-media@vger.kernel.org
References: <4B1D6194.4090308@freenet.de> <1261578615.8948.4.camel@slash.doma>
In-Reply-To: <1261578615.8948.4.camel@slash.doma>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912231753.28988.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 декабря 2009 16:30:16 Aljaž Prusnik wrote:
> In the same vein, I'm interested in this one, namely:
>
> I have tried the http://jusst.de/hg/v4l-dvb, since recently the
> liplianin mantis driver is not working (unknown symbols...).
>
> However, the problems I have as opposed to the previously working driver
> are:
> - the module does not install in a way it gets autoloaded on startup - I
> have to manually add it (modprobe) or put it into /etc/modules (debian)
> - while the card itself works, I don't have IR functionality anymore.
>
> >From what I gather from the kernel log, the input line
>
> input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4
>
> just doesn't exist anymore. Further more the whole bunch is missing:
>
> mantis_ca_init (0): Registering EN50221 device
> mantis_ca_init (0): Registered EN50221 device
> mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
> input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input4
> Creating IR device irrcv0
>
>
> I tried 2.6.32 kernel which worked before, now I'm using 2.6.33-rc1
> where I had to comment out #include <linux/autoconf.h> the from the
> v4l-dvb/v4l/config-compat.h.
>
>
> Any ideas how to get the comfort back? ;)
>
> Regards,
> Aljaz
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Since module ir-common.ko moved to IR directory just remove old one.

	rm /lib/modules/$(uname -r)/kernel/drivers/media/common/ir-common.ko

Also it would be good to do

	make remove

Then again build and install drivers.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
