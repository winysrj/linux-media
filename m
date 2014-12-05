Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36029 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLELpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 06:45:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Fri, 05 Dec 2014 13:46:21 +0200
Message-ID: <10129477.C7LMJl3dKC@avalon>
In-Reply-To: <CANOLnOMrdk9Gq+9Cv_e5cboXtbtxHoKVQdNgBvb_NcJfFT7bHQ@mail.gmail.com>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <7185728.KDKlKP9htJ@avalon> <CANOLnOMrdk9Gq+9Cv_e5cboXtbtxHoKVQdNgBvb_NcJfFT7bHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grazvydas,

On Thursday 06 November 2014 00:29:53 Grazvydas Ignotas wrote:
> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart wrote:
> > On Tuesday 04 November 2014 22:41:44 Rémi Denis-Courmont wrote:
> >> Le mardi 04 novembre 2014, 15:42:37 Rémi Denis-Courmont a écrit :
> >> > Le 2014-11-04 14:58, Sakari Ailus a écrit :
> >> > >> > Have you tried with a different application to see if the problem
> >> > >> > persists?
> >> > >> 
> >> > >> Tried mplayer and cheese now, and it seems they are not affected, so
> >> > >> it's an issue with vlc. I wonder why it doesn't like newer flags..
> >> > >> 
> >> > >> Ohwell, sorry for the noise.
> >> > > 
> >> > > I guess the newer VLC could indeed pay attention to the monotonic
> >> > > timestamp flag. Remi, any idea?
> >> > 
> >> > VLC takes the kernel timestamp, if monotonic, since version 2.1.
> >> > Otherwise, it generates its own inaccurate timestamp. So either that
> >> > code is wrong, or the kernel timestamps are.
> >> 
> >> From a quick check with C920, the timestamps from the kernel are quite
> >> jittery, and but seem to follow a pattern. When requesting a 10 Hz frame
> >> rate, I actually get a frame interval of about 8/9 (i.e. 89ms) jumping to
> >> 1/3 every approximately 2 seconds.
> >> 
> >> From my user-space point of view, this is a kernel issue. The problem
> >> probably just manifests when both VLC and Linux versions support
> >> monotonic timestamps.
> >> 
> >> Whether the root cause is in the kernel, the device driver or the
> >> firmware,
> >> I can´t say.
> > 
> > Would you be able to capture images from the C920 using yavta, with the
> > uvcvideo trace parameter set to 4096, and send me both the yavta log and
> > the kernel log ? Let's start with a capture sequence of 50 to 100 images.
>
> I've done 2 captures, if that helps:
> http://notaz.gp2x.de/tmp/c920_yavta/
> 
> The second one was done using low exposure setting, which allows
> camera to achieve higher frame rate.

Thank you for the log, they were very helpful. They revealed that the USB SOF 
(Start Of Frame) counter values on the device and host side are not in sync. 
The counters get incremented are very different rates. What USB controller are 
you using ?

-- 
Regards,

Laurent Pinchart

