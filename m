Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns207790.ip-94-23-215.eu ([94.23.215.26]:43545 "EHLO
	ns207790.ip-94-23-215.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKDUlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 15:41:47 -0500
From: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Tue, 04 Nov 2014 22:41:44 +0200
Message-ID: <36286542.DzZr56uF9K@basile.remlab.net>
In-Reply-To: <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <20141104115839.GN3136@valkosipuli.retiisi.org.uk> <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 04 novembre 2014, 15:42:37 Rémi Denis-Courmont a écrit :
> Le 2014-11-04 14:58, Sakari Ailus a écrit :
> >> > Have you tried with a different application to see if the problem
> >> 
> >> persists?
> >> 
> >> Tried mplayer and cheese now, and it seems they are not affected, so
> >> it's an issue with vlc. I wonder why it doesn't like newer flags..
> >> 
> >> Ohwell, sorry for the noise.
> > 
> > I guess the newer VLC could indeed pay attention to the monotonic
> > timestamp
> > flag. Remi, any idea?
> 
> VLC takes the kernel timestamp, if monotonic, since version 2.1.
> Otherwise, it generates its own inaccurate timestamp. So either that
> code is wrong, or the kernel timestamps are.

>From a quick check with C920, the timestamps from the kernel are quite 
jittery, and but seem to follow a pattern. When requesting a 10 Hz frame rate, 
I actually get a frame interval of about 8/9 (i.e. 89ms) jumping to 1/3 every 
approximately 2 seconds.

>From my user-space point of view, this is a kernel issue. The problem probably 
just manifests when both VLC and Linux versions support monotonic timestamps.

Whether the root cause is in the kernel, the device driver or the firmware, I 
can´t say.

-- 
Rémi Denis-Courmont
http://www.remlab.net/

