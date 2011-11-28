Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1K1OlW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 09:41:22 -0500
Message-ID: <4ED39D88.507@redhat.com>
Date: Mon, 28 Nov 2011 15:41:12 +0100
From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Mauro Chehab <mchehab@redhat.com>,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: HVR-900H dvb-t regression(s)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

short summary is that dvb-t on $subject doesn´t work with head of the
tree (for_3.3 branch) and scan or mplayer stop working.

Here is the breakdown of what I found with all logs. Please let me know
if you need any extra info. Can easily test patches and gather more logs
if necessary.

Also please note that I am no media guru of any kind. I had to work on
some assumptions from time to time.

Based on git bisect:

The last known good commit is e872bb9a7ddfc025ed727cc922b0aa32a7582004

The first known bad commit is f010dca2e52d8dcc0445d695192df19241afacdb

commit f010dca2e52d8dcc0445d695192df19241afacdb
Author: Stefan Ringel <stefan.ringel@arcor.de>
Date:   Mon May 9 16:53:58 2011 -0300

    [media] tm6000: move from tm6000_set_reg to tm6000_set_reg_mask

    move from tm6000_set_reg to tm6000_set_reg_mask

    Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

While this commit appears rather innocent, it changes the way some
registries are set.

the original code did:

read_reg...
change value
write_reg.. (unconditionally)

the new code path:

read_reg...
calculate new value
check if it is same
if not, write_reg...

So I did the simplest test as possible by removing the conditional in
tm6000_set_reg_mask and dvb-t started working again.

something along those lines:

diff --git a/drivers/media/video/tm6000/tm6000-core.c
b/drivers/media/video/tm6000/tm6000-core.c
index 9783616..818f542 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -132,8 +132,8 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8
req, u16 value,

        new_index = (buf[0] & ~mask) | (index & mask);

-       if (new_index == index)
-               return 0;
+//     if (new_index == index)
+//             return 0;

        return tm6000_read_write_usb(dev, USB_DIR_OUT | USB_TYPE_VENDOR,
                                      req, value, new_index, NULL, 0);

but moving this change to the HEAD of for_v3.3 doesn´t solve the
problem, possibly hinting to multiple regressions in the driver but at
this point I am slightly lost because i can´t figure out what else is
wrong. Some semi-random git bisect didn´t bring me anywhere useful at
this point.

In an poor attempt to be a good boy, I collected all the data here:
http://fabbione.fedorapeople.org/dvblogs.tar.xz
(NOTE: 76MB file, 101MB unpacked)

The file contains 5 dirs:

last-known-good-e872bb9a7ddfc025ed727cc922b0aa32a7582004
first-known-bad-f010dca2e52d8dcc0445d695192df19241afacdb
test1-change-set-reg-mask-f010dca2e52d8dcc0445d695192df19241afacdb+
head-known-bad-7e5219d18e93dd23e834a53b1ea73ead19cfeeb1
test2-change-set-reg-mask-7e5219d18e93dd23e834a53b1ea73ead19cfeeb1+

and each directory has:

dmesg
scan_results
tcpdump (tcpdump -i usbmod1 -w tcpdump)
usbmon0u (cat /sys.... > usbmod0u)

captures are started before modprobe tm6000-dvb and stop after a "scan
-a 0 dk"

The testX are marked "+" as they contain the workaround mentioned above
(test1 also adds a build workaround fixed a few commits later in the
tree to unexport a symbol).

Thanks
Fabio
