Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:56164 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab2ITVIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 17:08:30 -0400
Received: from leon.localnet (cs27125097.pp.htv.fi [89.27.125.97])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id 47C9A20251
	for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 23:08:28 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] Timestamps and V4L2
Date: Fri, 21 Sep 2012 00:08:26 +0300
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120920202122.GA12025@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209210008.26892@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 20 septembre 2012 23:21:22, Sakari Ailus a écrit :
> The problem
> ===========
> 
> The V4L2 has long used realtime timestamps (such as
> clock_gettime(CLOCK_REALTIME, ...)) to stamp the video buffers before
> handing them over to the user. This has been found problematic in
> associating the video buffers with data from other sources: realtime clock
> may jump around due to daylight saving time, for example, and ALSA
> (audio-video synchronisation is a common use case) user space API does not
> provide the user with realtime timestamps, but instead uses monotonic time
> (i.e. clock_gettime(CLOCK_MONOTONIC, ...)).
> 
> This is especially an issue in embedded systems where video recording is a
> common use case. Drivers typically used in such systems have silently
> switched to use monotonic timestamps. While against the spec, this is
> necessary for those systems to operate properly.
> 
> In general, realtime timestamps are seen of little use in other than
> debugging purposes, but monotonic timestamps are fine for that as well.
> It's still possible that an application I'm not aware of uses them in a
> peculiar way that would be adversely affected by changing to monotonic
> timestamps. Nevertheless, we're not supposed to break the API (or ABI).

You cannot break something that never worked. Aside from debugging, the main 
use of timestamp is to synchronize the video signal with something else and/or 
to detect drift (which is more or less the same thing anyway).

The current timestamp infos are _not_ usable. gstreamer has some fuzzy logic 
to try to figure out what it really means. VLC just ignores it and generates 
its own imprecise timestamp.

> It'd be also very important for the application to know what kind of
> timestamps are provided by the device.

I would rather expect the HAL to convert the timestamp to something standard 
than have the application deal with an ever expanding list of types of 
timestamp that need to be supported.

In other words, either V4L2 converts the timestamp to a type set by the 
application, or there is only one type of timestamp at all (CLOCK_MONOTONIC).
Anything else *will* fail.

> Requirements, wishes and constraints
> ====================================
> 
> Now that it seems to be about the time to fix these issues, it's worth
> looking a little bit to the future to anticipate the coming changes to be
> able to accommodate them better later on.
> 
> - The new default should be monotonic. As the monotonic timestamps are seen
> to be the most useful, they should be made the default.

> - timeval vs. timespec.
> (...)

> - Users should know what kind of timestamps the device produces. This
> includes existing and future kernels. What should be considered are
> uninformed porting drivers back and forth across kernel versions and
> out-of-date kernel header files.
> 
> - Device-dependent timestamps. Some devices such as the uvcvideo ones
> produce device-dependent timestamps for synchronising video and audio, both
> produced by the same physical hardware device. For uvcvideo these
> timestamps are unsigned 32-bit integers.
> 
> - There's also another clock, Linux-specific raw monotonic clock (as in
> clock_gettime(CLOCK_RAW_MONOTONIC, ...)) that could be better in some use
> cases than the regular monotonic clock. The difference is that the raw
> monotonic clock is free from the NTP adjustments. It would be nice for the
> user to be able to choose the clock used for timestamps. This is especially
> important for device-dependent timestamps: not all applications can be
> expected to be able to use them.

Then you need to create a new VIODIC_S_CLOCK control. If the control fails, 
then the application knows that it cannot trust the timestamp. So there is no 
need for a version number neither a flag.

This does seem overkill though. You'll need to keep a clockid_t for each open 
V4L2 file handle.

> - The field adjacent to timestamp, timecode, is 128 bits wide, and not used
> by a single driver. This field could be re-used.
> 
> 
> Possible solutions
> ==================
> 
> Not all of the solutions below that have been proposed are mutually
> exclusive. That's also what's making the choice difficult: the ultimate
> solution to the issue of timestamping may involve several of these --- or
> possibly something better that's not on the list.
> 
> 
> Use of timespec
> ---------------
> 
> If we can conclude timespec will always fit into the size of timeval (or
> timecode) we could use timespec instead. The solution should still make
> the use of timespec explicit to the user space. This seems to conflict with
> the idea of making monotonic timestamps the default: the default can't be
> anything incompatible with timeval, and at the same time it's the most
> important that the monotonic timestamps are timespec.

That is totally irrelevant. If the application knows what type of timestamp is 
used, it knows whether to use timespec or timeval, presumably timespec. If the 
default is changed to CLOCK_MONOTONIC, compatibility is broken, even if 
timeval is retained.

That being said, I think microsecond precision will be enough for longer than 
the foreseeable future. We are not even measuring frame rates in kHz yet. Even 
audio sampling rate is not reaching the MHz.

So I don't really care. Also, many applications will anyway convert the field 
to some internal timestamp representation.

> Kernel version as indicator of timestamp
> ----------------------------------------
> 
> Conversion of drivers to use monotonic timestamp is trivial, so the
> conversion could be done once and for all drivers. The kernel version could
> be used to indicate the type of the timestamp.

Was there never a V4L driver exposing a version number higher than 3 << 16? If 
there was, the version number cannot be used for comparison and this is moot.

> If this approach is taken care must be taken when new drivers are
> integrated: developers sometimes use old kernels for development and might
> also use an old driver for guidance on timestamps, thus using real-time
> timestamps when monotonic timestamps should be used.

The quality insurance problem will exist no matter what solution you pick. In 
particular, the same problem exists with the capability flag, if it ends up 
being set by the core blindly for all drivers. Also, with control solution, 
the driver could ignore the file handle value and blindly set the timestamp.

> Capability flag for monotonic timestamps
> ----------------------------------------
> 
> A capability flag can be used to tell whether the timestamp is monotonic.
> However, it's not extensible cleanly to provide selectable timestamps.
> These are not features that are needed right now, though.

> Control for timestamp type
> --------------------------
> 
> Using a control to tell the type of the timestamp is extensible but not as
> easy to implement than the capability flag: each and every device would get
> an additional control. The value should likely be also file handle
> specific, and we do not have file handle specific controls yet.
> 
> In the meantime the control could be read-only, and later made read-write
> when the timestamp type can be made selectable. Much of he work of
> timestamping can be done by the framework: drivers can use a single helper
> function and need to create one extra standard control.
> 
> Should the control also have an effect on the types of the timestamps in
> V4L2 events? Likely yes.
> 
> 
> Device-dependent timestamp
> --------------------------
> 
> Should we agree on selectable timestamps, the existing timestamp field (or
> a union with another field of different type) could be used for the
> device-dependent timestamps. Alternatively we can choose to re-use the
> existing timecode field.
> 
> At the moment there's no known use case for passing device-dependent
> timestamps at the same time with monotonic timestamps.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
