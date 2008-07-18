Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I2ec76032337
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 22:40:38 -0400
Received: from exprod8og103.obsmtp.com (exprod8og103.obsmtp.com [64.18.3.86])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6I2eNIw000842
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 22:40:23 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Thu, 17 Jul 2008 19:38:55 -0700
Message-ID: <1822849CB0478545ADCFB217EF4A3405F9E246@sedah.startrac.com>
From: "Dan Taylor" <dtaylor@startrac.com>
To: <video4linux-list@redhat.com>
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Subject: AVerMedia A16D / DVB-T tuning problem
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

I have an AVerMedia A16D, running linux kernel 2.6.26 patched with v4l
from yesterday (2008-07-16).

=20

I can tune US cable, US broadcast, and European and Australian PAL
analog broadcasts, but cannot get it to tune DVB-T (Berlin's set, for
test purposes).  Mplayer reports "Not able to lock to the signal on the
given frequency, timeout: 30".  I have checked the frequency from our
signal generator with a frequency/signal strength meter and it is there,
and have tried other frequencies including a known good frequency from
the digital part of our local cable system (not that the A16D can decode
the ATSC).

=20

When I tried to use 50 MHz (default on our generator), the driver kernel
message reported the tuner as capable of (174000000..862000000), so the
560000000 we tried is supposed to be in the correct range.

=20

We are using tuner "firmware" (with md5sum):

=20

293dc5e915d9a0f74a368f8a2ce3cc10
/lib/firmware/2.6.26-MX945GME/xc3028-v27.fw

=20

A: does anyone have DVB-T running with the A16D?

=20

B: do we have the correct firmware, and, if not, what should we have and
where can we get it?

=20

Any other suggestions?

=20

Thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
