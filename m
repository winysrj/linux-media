Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8JLPiLX005200
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:25:44 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8JLPVTt026070
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 17:25:31 -0400
Received: by gxk8 with SMTP id 8so1186793gxk.3
	for <video4linux-list@redhat.com>; Fri, 19 Sep 2008 14:25:31 -0700 (PDT)
Message-ID: <9d87242f0809191425p1adb1e59p417753a4c403a872@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:25:31 -0700
From: "Scott Bronson" <bronson@rinspin.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Unreliable tuning with HVR-950q
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

I set up a Hauppauge HVR-950q on Ubuntu Intrepid, kernel 2.6.27-2.  It
works out of the box except that it can only achieve a lock maybe 50%
of the time.  Once it gets the lock, it's perfect.  Never loses it, no
signal issues whatsoever.  I live so close to the tower, though, that
I don't see why it wouldn't tune 100% of the time.

Is there any way to debug this?  Is the transmitter overpowering my
card?  I tried both the crappy antenna that came with the 950q and a
6.5 dB indoor picture frame antenna, no difference.

Thanks!


Log from the last 3 days:

CHAN  TIME            DISTANCE according to antennaweb.org

11_1    03:00   fail    12 miles
11_1    03:00   fail
11_1    03:00   ok

2_1     00:00   fail     1 mile
2_1     00:00   ok
2_1     00:00   ok

44_1    00:30   fail    1 mile
44_1    00:30   ok
44_1    00:30   ok
44_1    18:30   fail
44_1    19:00   fail
44_1    21:00   ok
44_1    22:30   fail
44_1    22:30   ok

54_3    10:00   ok    maybe 35 miles?
54_3    10:00   ok

65_3    11:30   fail    5 miles maybe?
65_3    11:30   ok
65_3    11:30   ok
65_3    12:00   fail
65_3    12:00   fail
65_3    12:00   fail
65_3    14:00   fail
65_3    14:00   ok
65_3    23:00   fail
65_3    23:00   fail

9_2     05:00   fail    1 mile
9_2     20:00   ok
9_2     21:00   fail
9_3     09:00   fail

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
