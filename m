Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50546 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1BFLSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 06:18:14 -0500
Date: Sun, 6 Feb 2011 12:18:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Deti Fliegl <deti@fliegl.de>
Subject: Re: [GIT PATCHES FOR 2.6.39] Remove se401, usbvideo, dabusb,
 firedtv-1394 and VIDIOC_OLD
Message-ID: <20110206121811.3f05c3b1@stein>
In-Reply-To: <201102051417.22874.hverkuil@xs4all.nl>
References: <201102051417.22874.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 05 Hans Verkuil wrote:
> The following changes since commit ffd14aab03dbb8bb1bac5284603835f94d833bd6:
>   Devin Heitmueller (1):
>         [media] au0828: fix VBI handling when in V4L2 streaming mode
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/media_tree.git v4l1
> 
> Hans Verkuil (4):
>       se401/usbvideo: remove last V4L1 drivers
>       dabusb: remove obsolete driver
>       firedtv: remove dependency on the deleted ieee1394 stack.
>       v4l: removal of old, obsolete ioctls.

On commit f02c316436eef3baf349c489545edc7ade419ff6 "firedtv: remove
dependency on the deleted ieee1394 stack.":

The diff is correct and runtime-tested it.  But, as discussed, the
changelog is wrong and the shortlog somewhat misleading.  I suggest
something along the lines of:

----8<----

firedtv: remove obsolete ieee1394 backend code

drivers/ieee1394/ has been removed in Linux 2.6.37.  The corresponding
backend code in firedtv is no longer built in now and can be deleted.
Firedtv continues to work with drivers/firewire/.

Also, fix a Kconfig menu comment:  Removal of CONFIG_IEEE1394 made the
"Supported FireWire (IEEE 1394) Adapters" comment disappear; bring it back
with corrected dependency.

---->8----

A minor note:  firedtv-dvb.c::fdtv_init() can now be shortened further,
and firedtv-fw.c::fdtv_fw_exit() can receive an __exit annotation.
However, these changes can wait for (or will be superseded by) a subsequent
simplification of firedtv which throws out the fdtv->backend abstraction.
I tend to think that the three parts of firedtv-fw.c (asynchronous I/O,
isochronous I/O, device probe/update/removal) can be moved into
firedtv-avc.c, -fe.c, and -dvb.c.  I will post something.

If you rewrite the changelog, you can add
Reviewed-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
if you like.
-- 
Stefan Richter
-=====-==-== --=- --==-
http://arcgraph.de/sr/
