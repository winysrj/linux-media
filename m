Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36216 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaLEO6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 09:58:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Paulo Assis <pj.assis@gmail.com>,
	=?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Fri, 05 Dec 2014 16:58:50 +0200
Message-ID: <4697151.yGpSQ7NaTv@avalon>
In-Reply-To: <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com> <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 05 November 2014 18:11:47 Sakari Ailus wrote:
> On Wed, Nov 05, 2014 at 10:13:45AM +0000, Paulo Assis wrote:
> > 2014-11-04 23:32 GMT+00:00 Sakari Ailus <sakari.ailus@iki.fi>:
> >> Sakari Ailus wrote:
> >>> yavta does, for example, print both the monotonic timestamp from the
> >>> buffer and the time when the buffer has been dequeued:
> >>> 
> >>> <URL:http://git.ideasonboard.org/yavta.git>
> >>> 
> >>>       $ yavta -c /dev/video0
> >>> 
> >>> should do it. The first timestamp is the buffer timestamp, and the
> >>> latter is the one is taken when the buffer is dequeued (by yavta).
> > 
> > I've done exaclty this with guvcview, and uvcvideo timestamps are
> > completly unreliable, in some devices they may have just a bit of
> > jitter, but in others, values go back and forth in time, making them
> > totally unusable.
> > Honestly I wouldn't trust device firmware to provide correct
> > timestamps, or at least I would have the driver perform a couple of
> > tests to make sure these are at least reasonable: within an expected
> > interval (maybe comparing it to a reference monotonic clock) or at the
> > very least making sure the current frame timestamp is not lower than
> > the previous one.
> 
> Using the hardware timestamps provides much better accuracy than the
> software ones --- the real time capabilities of the USB aren't exactly the
> same as on some other busses.
> 
> Freel free to try the follow-up patches; I've only compile tested them so
> far.
> 
> It might be possible to add some heuristics to detect bad implementations
> but perhaps we could simply flag them for now. If heuristics would be used,
> then one would likely have a few bad timestamps every time the device is
> accessed the first time anyway. Besides, the timestamp type changes as a
> result.
> 
> I wonder what Laurent thinks. :-)

I've been toying with the idea of a heuristic, but decided to delay the 
implementation until needed. I'd like to find the root cause of the issue 
first before deciding how to fix it.

-- 
Regards,

Laurent Pinchart

