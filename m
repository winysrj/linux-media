Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56481 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKER74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 12:59:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Paulo Assis <pj.assis@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	=?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Wed, 05 Nov 2014 16:05:12 +0200
Message-ID: <1786601.8VQNyC75Ox@avalon>
In-Reply-To: <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <54596226.8040403@iki.fi> <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

On Wednesday 05 November 2014 10:13:45 Paulo Assis wrote:
> 2014-11-04 23:32 GMT+00:00 Sakari Ailus <sakari.ailus@iki.fi>:
> > Sakari Ailus wrote:
> >> yavta does, for example, print both the monotonic timestamp from the
> >> buffer and the time when the buffer has been dequeued:
> >> 
> >> <URL:http://git.ideasonboard.org/yavta.git>
> >> 
> >>       $ yavta -c /dev/video0
> >> 
> >> should do it. The first timestamp is the buffer timestamp, and the latter
> >> is the one is taken when the buffer is dequeued (by yavta).
> 
> I've done exaclty this with guvcview, and uvcvideo timestamps are completly
> unreliable, in some devices they may have just a bit of jitter, but in
> others, values go back and forth in time, making them totally unusable.
>
> Honestly I wouldn't trust device firmware to provide correct timestamps, or
> at least I would have the driver perform a couple of tests to make sure
> these are at least reasonable: within an expected interval (maybe comparing
> it to a reference monotonic clock) or at the very least making sure the
> current frame timestamp is not lower than the previous one.

I can add that to the uvcvideo driver, but I'd first like to find out whether 
the device timestamps are really unreliable, or if the problem comes from a 
bug in the driver's timestamp conversion code. Could you capture images using 
yavta with an unreliable device, with the uvcvideo trace parameter set to 
4096, and send me both the yavta log and the kernel log ? Let's start with a 
capture sequence of 50 to 100 images.

> > Removing the uvcvideo module and loading it again with trace=4096 before
> > capturing, and then kernel log would provide more useful information.

-- 
Regards,

Laurent Pinchart
