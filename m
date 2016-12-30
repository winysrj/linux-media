Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38779 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753958AbcL3NFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 08:05:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niels =?ISO-8859-1?Q?M=F6ller?= <nisse@google.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with uvcvideo timestamps
Date: Fri, 30 Dec 2016 15:06:13 +0200
Message-ID: <3748875.JxjCFGm7HQ@avalon>
In-Reply-To: <CANKQH8jiPypkgJ30KAjedjJvfDASZ6V9sZXKHN54xpv1=i9XbA@mail.gmail.com>
References: <CANKQH8jiPypkgJ30KAjedjJvfDASZ6V9sZXKHN54xpv1=i9XbA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niels,

On Monday 31 Oct 2016 14:42:54 Niels M=F6ller wrote:
> Hi,
>=20
> I'm tracking down a problem in Chrome, where video streams captured
> from a Logitech c930e camera get bogus timestamps. Chrome started
> using camera timestamps on linux a few months ago. I've noted commit
>=20
> =20
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3D
> 5d0fd3c806b9e932010931ae67dbb482020e0882
>=20
>   "[media] uvcvideo: Disable hardware timestamps by default"
>=20
> but I'm running with a kernel which doesn't have that change.
>=20
> First, let me say that for our purposes, the hairy syncing to the
> "SOF" clock done by uvc_video_clock_update is not that useful.
> Ideally, I would prefer if the v4l2_buffer of a captured frame
> included both
>=20
>   * untranslated pts timestamp from the camera device (if I've
>     understood this correctly, and there is a pts sent over the wire)=
,

There's a PTS sent over the wire, yes.

>     and
>=20
>   * the value of system monotonic clock at the point when the frame
>     was received by the kernel.
>=20
> Is there any reasonable way to get this information out from the
> driver?

The system monotonic clock timestamp is what the driver provides (with =
the=20
above patch at least). We however have no field in the v4l2_buffer stru=
cture=20
at the moment to provide the PTS.

> We could then do estimation of the camera's epoch and clock drift in =
the
> application.

Unless I'm mistaken, you can only do that if you get the SCR/PTS values=
 in=20
your application, and they're currently not provided. How do you plan t=
o solve=20
that ?

> The raw pts is the most important piece of information.

What do you want to use it for by the way ?

> Second, I'd like to try to provide some logs to help track down the
> bug. To reproduce, I'm using the example program at
> https://gist.github.com/maxlapshin/1253534, modified to print out
> camera timestamp and gettimeofday for each frame. Log attached as
> time-2.log.

Thank you. I have a device I can use to reproduce the problem, but have=
n't had=20
time to fix it yet :-/ Performing the timestamp translation in userspac=
e would=20
allow for more precise calculation, so I'm not advocating for a kernel-=
only=20
solution. However, I don't want every application to implement timestam=
p=20
translation. A common implementation in libv4l2 could be a good solutio=
n.

> I also enabled tracing of the clock translation logic using
>=20
>   echo 4096 > /sys/module/uvcvideo/parameters/trace
>=20
> The corresponding kernel log messages are attached as trace-2.log.
>=20
> In time-2.log (i.e., the application log), I see that camera
> timestamps move backwards in time,
>=20
>   TIMESTAMP_MONOTONIC
>      cam: 2321521.085372
>      sys: 1477913910.983620
>   TIMESTAMP_MONOTONIC
>      cam: 2321520.879272
>      sys: 1477913911.051628
>=20
> In trace-2.log (i.e., kernel log messages) I see
>=20
>   uvcvideo: Logitech Webcam C930e: PTS 219483992 y 4084.798004 SOF
> 4084.798004 (x1 2064310082 x2 2148397132 y1 218759168 y2 268238848 SO=
F
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 4084.798004 y 3105900702 ts
> 2321520.879272 buf ts 2321521.153372 (x1 218759168/1546/1290 x2
> 274071552/1878/2045 y1 1000000000 y2 3380001263)
>   uvcvideo: Logitech Webcam C930e: PTS 221480532 y 4156.709564 SOF
> 4156.709564 (x1 2079524156 x2 2148397450 y1 256376832 y2 272629760 SO=
F
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 4156.709564 y 2453257742 ts
> 2321520.378627 buf ts 2321521.217373 (x1 262275072/1698/1864 x2
> 278265856/1942/64 y1 1000000000 y2 3292003672)
>   uvcvideo: Logitech Webcam C930e: PTS 223477044 y 4223.428085 SOF
> 4223.428085 (x1 2081269216 x2 2148397122 y1 264568832 y2 276955136 SO=
F
> offset 170)
>   uvcvideo: Logitech Webcam C930e: SOF 2175.428085 y 2158773894 ts
> 2321520.208143 buf ts 2321521.285373 (x1 136183808/1822/1989 x2
> 148504576/2010/130 y1 1000000000 y2 3236003012)
>=20
> I don't know the details of the usb protocol, but it looks like the
> "SOF" value is usually increasing. But close to the bogus output
> timestamp of 2321520.879272, it goes through some kind of wraparound,=

> with the sequence of values
>=20
>   4156.709564
>   4223.428085
>   2175.428085    # 2048 less than previous value
>   2243.169921
>=20
> I hope the attached logs provide enough information to analyze where
> uvc_video_clock_update gets this wrong.

--=20
Regards,

Laurent Pinchart

