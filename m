Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n375e7oJ016559
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 01:40:07 -0400
Received: from mail-gx0-f171.google.com (mail-gx0-f171.google.com
	[209.85.217.171])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n375dimw012989
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 01:39:45 -0400
Received: by gxk19 with SMTP id 19so5413426gxk.3
	for <video4linux-list@redhat.com>; Mon, 06 Apr 2009 22:39:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 22:39:44 -0700
Message-ID: <bfa9a8f30904062239l2d096accj47c1fb8d50eafcf7@mail.gmail.com>
From: Christopher Pascoe <linuxdvb@itee.uq.edu.au>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: No scan with DViCo FusionHDTV DVB-T Dual Express
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

(Hopefully this email will join the thread - I just joined the list briefly
so I could post.)

I had a few minutes while stuck on a bus and had a look at the code in
v4l-dvb tip.  It appears that the driver there has at least two problems -
it resets the wrong (or no) tuner in the callback and it potentially locks
up the I2C bus through tinkering with the zl10353's gate_control logic.  The
first alone would cause an "incorrect readback of firmware version" message
after the first tune.  The second would explain the device subids
disappearing and your having to use card=11 for the board to be found.

Try the patch at
http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/dual-digital-express-dvb-t-fix-20090407-1.patch.
 It probably addresses these two issues (it's not even compile tested,
so
if it doesn't build I'm sure you get the idea) and see if it makes any
difference.

Regards,
Chris
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
