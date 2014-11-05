Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52888 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755148AbaKEQLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 11:11:51 -0500
Date: Wed, 5 Nov 2014 18:11:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Paulo Assis <pj.assis@gmail.com>
Cc: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Message-ID: <20141105161147.GW3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <20141102225704.GM3136@valkosipuli.retiisi.org.uk>
 <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
 <20141104115839.GN3136@valkosipuli.retiisi.org.uk>
 <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
 <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com>
 <20141104153650.GO3136@valkosipuli.retiisi.org.uk>
 <54596226.8040403@iki.fi>
 <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paolo,

On Wed, Nov 05, 2014 at 10:13:45AM +0000, Paulo Assis wrote:
> Hi,
> 
> 2014-11-04 23:32 GMT+00:00 Sakari Ailus <sakari.ailus@iki.fi>:
> > Sakari Ailus wrote:
> >> yavta does, for example, print both the monotonic timestamp from the buffer
> >> and the time when the buffer has been dequeued:
> >>
> >> <URL:http://git.ideasonboard.org/yavta.git>
> >>
> >>       $ yavta -c /dev/video0
> >>
> >> should do it. The first timestamp is the buffer timestamp, and the latter is
> >> the one is taken when the buffer is dequeued (by yavta).
> 
> I've done exaclty this with guvcview, and uvcvideo timestamps are
> completly unreliable, in some devices they may have just a bit of
> jitter, but in others, values go back and forth in time, making them
> totally unusable.
> Honestly I wouldn't trust device firmware to provide correct
> timestamps, or at least I would have the driver perform a couple of
> tests to make sure these are at least reasonable: within an expected
> interval (maybe comparing it to a reference monotonic clock) or at the
> very least making sure the current frame timestamp is not lower than
> the previous one.

Using the hardware timestamps provides much better accuracy than the
software ones --- the real time capabilities of the USB aren't exactly the
same as on some other busses.

Freel free to try the follow-up patches; I've only compile tested them so
far.

It might be possible to add some heuristics to detect bad implementations
but perhaps we could simply flag them for now. If heuristics would be used,
then one would likely have a few bad timestamps every time the device is
accessed the first time anyway. Besides, the timestamp type changes as a
result.

I wonder what Laurent thinks. :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
