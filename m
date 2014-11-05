Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:49019 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaKEW3y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 17:29:54 -0500
Received: by mail-oi0-f53.google.com with SMTP id a141so95219oig.12
        for <linux-media@vger.kernel.org>; Wed, 05 Nov 2014 14:29:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7185728.KDKlKP9htJ@avalon>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
	<fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
	<36286542.DzZr56uF9K@basile.remlab.net>
	<7185728.KDKlKP9htJ@avalon>
Date: Thu, 6 Nov 2014 00:29:53 +0200
Message-ID: <CANOLnOMrdk9Gq+9Cv_e5cboXtbtxHoKVQdNgBvb_NcJfFT7bHQ@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
From: Grazvydas Ignotas <notasas@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Rémi,
>
> On Tuesday 04 November 2014 22:41:44 Rémi Denis-Courmont wrote:
>> Le mardi 04 novembre 2014, 15:42:37 Rémi Denis-Courmont a écrit :
>> > Le 2014-11-04 14:58, Sakari Ailus a écrit :
>> > >> > Have you tried with a different application to see if the problem
>> > >> > persists?
>> > >>
>> > >> Tried mplayer and cheese now, and it seems they are not affected, so
>> > >> it's an issue with vlc. I wonder why it doesn't like newer flags..
>> > >>
>> > >> Ohwell, sorry for the noise.
>> > >
>> > > I guess the newer VLC could indeed pay attention to the monotonic
>> > > timestamp flag. Remi, any idea?
>> >
>> > VLC takes the kernel timestamp, if monotonic, since version 2.1.
>> > Otherwise, it generates its own inaccurate timestamp. So either that
>> > code is wrong, or the kernel timestamps are.
>>
>> From a quick check with C920, the timestamps from the kernel are quite
>> jittery, and but seem to follow a pattern. When requesting a 10 Hz frame
>> rate, I actually get a frame interval of about 8/9 (i.e. 89ms) jumping to
>> 1/3 every approximately 2 seconds.
>>
>> From my user-space point of view, this is a kernel issue. The problem
>> probably just manifests when both VLC and Linux versions support monotonic
>> timestamps.
>>
>> Whether the root cause is in the kernel, the device driver or the firmware,
>> I can´t say.
>
> Would you be able to capture images from the C920 using yavta, with the
> uvcvideo trace parameter set to 4096, and send me both the yavta log and the
> kernel log ? Let's start with a capture sequence of 50 to 100 images.

I've done 2 captures, if that helps:
http://notaz.gp2x.de/tmp/c920_yavta/

The second one was done using low exposure setting, which allows
camera to achieve higher frame rate.

-- 
Gražvydas
