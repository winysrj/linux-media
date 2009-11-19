Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAJMQvph004070
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 17:26:57 -0500
Received: from mail-fx0-f224.google.com (mail-fx0-f224.google.com
	[209.85.220.224])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAJMQkro004893
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 17:26:47 -0500
Received: by fxm24 with SMTP id 24so1197027fxm.11
	for <video4linux-list@redhat.com>; Thu, 19 Nov 2009 14:26:46 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 16:26:46 -0600
Message-ID: <6bd2c7ce0911191426i356a6dabm628d25c59c7c6a79@mail.gmail.com>
From: Dan Vacura <danvacura@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: buffer timestamps issue with do_gettimeofday
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello all,

I'm curious as to why the following recommendation, found here
http://v4l2spec.bytesex.org/spec/x15446.htm, has changed to use
do_gettimeofday(...):


"The struct v4l2_buffer timestamp was changed to a 64 bit integer,
containing the sampling or output time of the frame in nanoseconds.
Additionally timestamps will be in absolute system time, not starting
from zero at the beginning of a stream. The data type name for
timestamps is stamp_t, defined as a signed 64-bit integer. Output
devices should not send a buffer out until the time in the timestamp
field has arrived. I would like to follow SGI's lead, and adopt a
multimedia timestamping system like their UST (Unadjusted System
Time). See http://reality.sgi.com/cpirazzi_engr/lg/time/intro.html.
[This link is no longer valid.] UST uses timestamps that are 64-bit
signed integers (not struct timeval's) and given in nanosecond units.
The UST clock starts at zero when the system is booted and runs
continuously and uniformly. It takes a little over 292 years for UST
to overflow. There is no way to set the UST clock. The regular Linux
time-of-day clock can be changed periodically, which would cause
errors if it were being used for timestamping a multimedia stream. A
real UST style clock will require some support in the kernel that is
not there yet."

I am trying to develop a solution that uses the timestamps for video
encode and when NTP updates occur that go in the past, it's difficult
to establish a positive time delta between subsequent buffers.  Also,
the last comment about getting a real UST clock does exist in the
kernel now: ktime_get_ts(...).

Thanks,

Dan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
