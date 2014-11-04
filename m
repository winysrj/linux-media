Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43156 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751841AbaKDPh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 10:37:27 -0500
Date: Tue, 4 Nov 2014 17:36:51 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Paulo Assis <pj.assis@gmail.com>
Cc: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Message-ID: <20141104153650.GO3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <20141102225704.GM3136@valkosipuli.retiisi.org.uk>
 <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
 <20141104115839.GN3136@valkosipuli.retiisi.org.uk>
 <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
 <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Nov 04, 2014 at 03:02:58PM +0000, Paulo Assis wrote:
> I've add to change guvcview so that it now generates it's own
> monotonic timestamps, kernel timestamps (uvcvideo at least), caused a
> similar problem, e.g:
> I would get a couple of frames with correct timestamps, then I would
> get at least one with a value lower than the rest, this caused
> playback to stutter.
> I didn't had time to check the cause, but it has been like this for
> quite some time now.

Have you looked what kind of timestamps the device gives you? The uvc
devices provide their own hardware timestamps which the UVC driver uses. If
the device provides bad timestamps to the driver, the buffer timestamps
could end up being very wrong. I don't know if the driver tries to cope with
that. One thing to try would be to capture images with a program which
prints the buffer timestamps.

yavta does, for example, print both the monotonic timestamp from the buffer
and the time when the buffer has been dequeued:

<URL:http://git.ideasonboard.org/yavta.git>

	$ yavta -c /dev/video0

should do it. The first timestamp is the buffer timestamp, and the latter is
the one is taken when the buffer is dequeued (by yavta).

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
