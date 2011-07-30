Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:45841 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1G3InZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 04:43:25 -0400
Message-ID: <4E33C426.50000@mailbox.hu>
Date: Sat, 30 Jul 2011 10:43:18 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com>
In-Reply-To: <4E32EE71.4030908@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/29/2011 07:31 PM, Mauro Carvalho Chehab wrote:

> istvan_v@mailbox.hu (11):
>        [media] xc4000: code cleanup
>        [media] dvb-usb/Kconfig: auto-select XC4000 tuner for dib0700
>        [media] xc4000: check firmware version
>        [media] xc4000: removed card_type

I assume a firmware file for XC4000 is still needed ? I did create a
firmware package some time ago and sent it to Devin Heitmueller so that
he can check if it is OK for being submitted, and also asked if the
Xceive sources that the firmware building utility depends on can be
redistributed, but I did not get a reply yet.
In addition to the utility that creates the firmware from the official
Xceive sources, I have written one that can extract the firmware
(version 1.2 or 1.4) from Windows drivers; both utilities produce
identical output files.

Another XC4000 issue that may need to be resolved is I2C problems on
dib0700 based devices like the PCTV 340e. I cannot test these, since
I have only a cx88 based card with XC4000, and it does not have any
I2C reliability issues. If PCTV 340e users report I2C related problems,
perhaps some code may need to be added to retry failed operations before
reporting an error. I think there is also a hack still in the driver
that ignores I2C errors during various operations.

>        [media] cx88: implemented luma notch filter control

In cx88-core.c, there is a change that may be unneeded:

@@ -636,6 +636,9 @@
         cx_write(MO_PCI_INTSTAT,   0xFFFFFFFF); // Clear PCI int
         cx_write(MO_INT1_STAT,     0xFFFFFFFF); // Clear RISC int

+       /* set default notch filter */
+       cx_andor(MO_HTOTAL, 0x1800, (HLNotchFilter4xFsc << 11));
+
         /* Reset on-board parts */
         cx_write(MO_SRST_IO, 0);
         msleep(10);

In fact, I have re-submitted the patch with this change removed, but
it is the first version that was incorporated. Having some look at the
cx88 sources, it seems cx88_reset() is not supposed to set/initialize
controls, because it is done elsewhere ?
