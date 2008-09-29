Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8T62CIB012873
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 02:02:13 -0400
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8T620U1010273
	for <video4linux-list@redhat.com>; Mon, 29 Sep 2008 02:02:01 -0400
Received: by wx-out-0506.google.com with SMTP id i31so402240wxd.6
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 23:02:00 -0700 (PDT)
Date: Mon, 29 Sep 2008 01:01:51 -0500
From: Vanessa Ezekowitz <vanessaezekowitz@gmail.com>
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
Message-ID: <20080929010151.111f31a2@rainbird>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: cx88-alsa audio quality?
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

I forget if I've already mentioned this yet...

I recently started playing around with analog NTSC television again on my system, while trying to help someone solve a problem on their system.  In the process I ran into a problem getting cx88-alsa to build with the rest of the v4l-dvb repository.  As it turned out, mine was one of the stock Ubuntu kernels that have some odd issue with the I2C configuration.   I had to build a vanilla kernel (2.6.26.5), making all the I2C stuff into modules as opposed to built-in.  So, that's fixed - cx88-alsa builds and loads OK now.

However, I have a new problem:

Something has broken the output that cx88-alsa creates.  In the case of my Kworld ATSC 120, radio output on all frequencies has a sort of growling "industrial" noise on top of the actual audio, kinda like the background noise of a manufacturing facility.

Analog TV on all channels gives clean but very tinny audio, as though the sample rate were really low (~8kHz).

Since other audio sources are working fine, I can't tell if this is a bug in the kernel, or cx88-alsa, or something else entirely.  I've only noticed the problem for a matter of a week or less, so I'm not sure when it started.  The problem persists as of today's pull of the v4l-dvb repository.

-- 
"Life is full of positive and negative events.  Spend
your time considering the former, not the latter."
Vanessa Ezekowitz <vanessaezekowitz@gmail.com>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
