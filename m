Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:35086 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab2HMQJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 12:09:34 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] RFC: V4L2 API ambiguities
Date: Mon, 13 Aug 2012 19:09:31 +0300
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201208131427.56961.hverkuil@xs4all.nl>
In-Reply-To: <201208131427.56961.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208131909.31834.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 13 août 2012 15:27:56 Hans Verkuil, vous avez écrit :
> 1) What is the right/best way to set the timestamp? The spec says
> gettimeofday, but is it my understanding that ktime_get_ts is much more
> efficient.
> 
>    Some drivers are already using ktime_get_ts.
> 
>    Options:
> 
>    a) all drivers must comply to the spec and use gettimeofday

gettimeofday() is wrong for use other than getting the wall clock time.
In particular, it breaks if the real-time clock gets adjusted while streaming.

Practically all modern multimedia applications on Linux use the monotonic 
POSIX clock in a way or another.

>    b) we change the spec and all drivers must use the more efficient
> ktime_get_ts

Unfortunately, that would not be enough to be immediately useful. Userspace 
needs a way to know that it can (finally!) trust the timestamps. Currently, 
since different drivers use different clocks, the only reasonable option for 
user space consists of ignoring the V4L2 timestamp. Thus userspace has to fall 
back to the current clock time after ioctl(DQBUF) returns, as an 
approximation.

> c) we add a buffer flag V4L2_BUF_FLAG_MONOTONIC to tell
> userspace that a monotonic clock like ktime_get_ts is used and all drivers
> that use ktime_get_ts should set that flag.

Yes, either a buffer or a capability flag ought to work.

>    If we go for c, then we should add a recommendation to use one or the
> other as the preferred timestamp for new drivers.

IMHO, all drivers should be adapted to the new specification as far as 
possible.


Of course, that will break any user space application that would have trusted 
V4L2 to return valid CLOCK_REALTIME timestamps so far. I'd argue such an 
application was already broken in practice even if it conformed to the letter 
of the V4L2 specification.

-- 
Rémi Denis-Courmont
C/C++ software engineer looking for a job
http://www.linkedin.com/in/remidenis
