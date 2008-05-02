Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m420JUUG012745
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 20:19:30 -0400
Received: from web55009.mail.re4.yahoo.com (web55009.mail.re4.yahoo.com
	[206.190.58.143])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m420JHqn018844
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 20:19:17 -0400
Date: Thu, 1 May 2008 17:19:11 -0700 (PDT)
From: G Maus <mausmang@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <470634.2977.qm@web55009.mail.re4.yahoo.com>
Subject: cx18 HVR-1800
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

I noticed that http://linuxtv.org/hg/~gliakhovetski/v4l-dvb was merged into v4l-dvb a couple of days ago.  I assume this means that this project is no longer in development and is now in the 'regular' sources?
 
Since the project was merged, I am no longer able to setup my HVR-1800.  After compiling the drivers I 'modprobe cx18' which creates video0, video24 and video34. I have no adapters under /dev/dvb. dmesg tells me that "DVB & VBI are not yet supported".  I also have no audio in the mpeg stream on Video0.
 
Have the installation instructions changed with this move to v4l-dvb?  Should I be looking elsewhere for the driver? I've Googled and come up empty.
  
Thank you,
Greg


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
