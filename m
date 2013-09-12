Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:17277 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab3ILDq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 23:46:29 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MSZ004EBUHGZK70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Sep 2013 23:46:28 -0400 (EDT)
Date: Thu, 12 Sep 2013 00:46:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Christoph Pegel <christoph@cpegel.de>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV MiniStick (siano) firmware not loading
Message-id: <20130912004623.54e2ae71@samsung.com>
In-reply-to: <5230529A.70604@cpegel.de>
References: <5230529A.70604@cpegel.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Sep 2013 13:23:06 +0200
Christoph Pegel <christoph@cpegel.de> escreveu:

> Hello Mauro,
> 
> I already sent this mail to your address at redhat, I guess it didn't
> reach you.

I'm not answering there anymore. Not sure why emails sent to it are not
returning back.

The better is to always copy the linux-media ML on such emails, as people
there can also help with it.

> Two month ago I noticed the firmware of my Hauppauge WinTV MiniStick
> wasn't loading anymore:

Probably, it is recognizing its firmware version wrong.

There's a logic at drivers/media/common/siano/smscoreapi.c that it is meant
to identify it:

                if (coredev->fw_version >= 0x800) {
                       	rc = smscore_init_device(coredev, mode);
                        if (rc < 0)
                               	sms_err("device init failed, rc %d.", rc);

Basically, this function should be called only for newer firmwares found
on sms2270. If this is called on old devices, this causes it to fail.

> 
> usb 1-1.5.1: new high-speed USB device number 9 using ehci-pci
> smscore_load_firmware_family2: line: 986: sending
> MSG_SMS_DATA_VALIDITY_REQ expecting 0xcfed1755
> smscore_onresponse: line: 1565: MSG_SMS_DATA_VALIDITY_RES, checksum =
> 0xcfed1755

The messages changed, but that doesn't mean that an error happened. The
above messages are actually OK: it just reports that a checksum is expected.

As the checksum is identical, the firmware uploaded matches.

> If I ignore that and try to tune in some channel, the kernel panics.

Well, we need the Kernel panic messages, in order to be able to identify
what happened.

> 
> This problem has already been reported in multiple places:
>     * https://bugzilla.kernel.org/show_bug.cgi?id=60645

Unfortunately, reported as a drivers/video error. It should, instead, be
reported as a v4l-dvb driver issue:

	https://bugzilla.kernel.org/describecomponents.cgi?product=v4l-dvb

>     *
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/68070
>     * http://markmail.org/message/3oczpksvbosavg54
>     * https://bbs.archlinux.org/viewtopic.php?pid=1309369

None of the above reports went to the proper channel (the linux-media
ML), and the kernel.org one went to the wrong people.

> 
> Since nobody seems to notice these reports, I checked the commits in the
> kernel tree and found that you did some major changes on the driver in
> 2013-03 which have been merged by Linus on 2013-04-30.
> 
> I'd appreciate any help in getting this problem fixed.

Please comment that lines at smscoreapi that call smscore_init_device()
if the firmware version is equal or upper to 0x800, and see what happens.

Unfortunately, I'm about to travel to 3 consecutive international trips 
starting this weekend. So, it is very doubtful that I would have any time
soon to dirt my hands on it before November.

I can try to guide you on how to fix it trough.

Regards,
Mauro
