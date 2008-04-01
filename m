Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31Kt9R7013718
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:55:09 -0400
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.177])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31Kswp9006465
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 16:54:58 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2834492waf.7
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 13:54:58 -0700 (PDT)
Message-ID: <34d8b2fe0804011354s1f38ea9bx153daeefd26ae583@mail.gmail.com>
Date: Tue, 1 Apr 2008 22:54:58 +0200
From: Pirlouwi <pirlouwi@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: HVR-1300 analog tuner not working on Blackbird device /dev/video1
Reply-To: pirlouwi@gmail.com
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

Hi,

I installed last v4l mercurial (0776e4801991.tar.bz2) onto my 2.6.23 kernel
(on Ubuntu 7.04), and got troubles to tune a frequency on /dev/video1
blackbird device (for Hauppauge HVR-1300).

I found following errors in dmesg (I put inline the commands that I launched
that produced the errors) :
v4l2-ctl -d /dev/video1 -f 196.25
[ 5605.909575] tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
[ 5605.910654] tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
[ 5605.911749] tuner-simple 1-0061: i2c i/o error: rc == -121 (should be 4)
[ 5605.915117] cx22702_readreg: readreg error (ret == -121)
[ 5605.916246] cx22702_writereg: writereg error (reg == 0x0d, val == 0x01,
ret == -121)

v4l2-ctl -d /dev/video1 -s PAL
[ 5813.682668] cx22702_readreg: readreg error (ret == -121)
[ 5813.683832] cx22702_writereg: writereg error (reg == 0x0d, val == 0x00,
ret == -121)
[ 5813.684966] tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
[ 5813.686079] tda9887 1-0043: i2c i/o error: rc == -121 (should be 4)
[ 5813.687150] tuner-simple 1-0061: i2c i/o error: rc == -121 (should be 4)
[ 5813.688239] cx22702_readreg: readreg error (ret == -121)
[ 5813.689660] cx22702_writereg: writereg error (reg == 0x0d, val == 0x01,
ret == -121)

As you can see, both errors are related to the Philips tuner of the HVR
board.

Just before installing this v4l mercurial, I was using a ~rmcc/blackbird
branch, and had no problems tuning an analog frequency.
But I decided to upgrade to resolve some issues on analog audio routing when
recording.

Any idea that could help me?

--Pirlouwi
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
