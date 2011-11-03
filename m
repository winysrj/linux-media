Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55095 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966Ab1KCQWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 12:22:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: bug-track@fisher-privat.net
Subject: Re: [RFC PATCH]  uvc debugfs interface, initial patch
Date: Thu,  3 Nov 2011 17:22:01 +0100
Message-Id: <1320337323-26929-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <4E7983BA.7010103@fisher-privat.net>
References: <4E7983BA.7010103@fisher-privat.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On Wednesday 21 September 2011 08:27:06 Alexey Fisher wrote:
> 
> this is initial patch for debugfs interface. I didn't implemented all
> requests, i think the size of this patch is any way too big now.

I've finally found time to go through your patch :-) I'm sorry for the way too
long delay.

> Here is how it's working. After driver is loaded it create
> debugfs/usb/uvcvideo directory. If some device is attached it create
> device dir like this: 001.007_046d.0991 (first part is usb bus, second
> is usb id). In this directory it create file called stats. Here is the
> content of this file:
> 
> usb id: 046d:0991, usb bus: 001:007
> packet size: 944(6)
> state: idle  <-- show the state of device. capture or idle
> start time: 1316585466 <- unix epoch time in seconds.
> capture time: 106   <- capture time in seconds.
> format: YUV 4:2:2 (YUYV)
> resolution: 320x240 @ 30
> decode_start: 846880  <- this show how many payloads we started to
> decoding. bad_header: 0 <-- haw many payloads was dropped, because of bad
> header uvc_empty: 604160  <-- correct uvc payloads without video data
> uvc_stream_err: 0  <-- count of payloads with err bit set
> sequence: 955  <-- count of fid switches
> out_of_sync: 0  <-- out of sync calls

I like the patch but have lots of small comments. Instead of playing ping-pong
with you to get everything fixed, I've reworked your patch. The result can be
found as replies to this e-mail.

First of all I've split the patch in two. The first patch adds debugfs support
to the driver, and the second patch exports video stream statistics. This makes
review easier.

Then, I've modified statistics gathering to store per-stream stats instead of
per-device as a UVC device can expose several streams.

Finally I've removed the state information from the statistics, as they're not
really statistics. It should be easi to add them back in a "state" or "info"
debugfs file once we agree on these patches.

Both patches are currently authored by me. I'll will use your name and e-mail
address if you send me your SoB line.

Laurent Pinchart (2):
  uvcvideo: Add debugfs support
  uvcvideo: Extract video stream statistics

 drivers/media/video/uvc/Makefile      |    2 +-
 drivers/media/video/uvc/uvc_debugfs.c |  136 +++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvc_driver.c  |   21 ++++-
 drivers/media/video/uvc/uvc_video.c   |  111 ++++++++++++++++++++++++++-
 drivers/media/video/uvc/uvcvideo.h    |   39 ++++++++++
 5 files changed, 302 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_debugfs.c

-- 
Regards,

Laurent Pinchart

