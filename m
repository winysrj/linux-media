Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OMshiV006510
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:54:43 -0400
Received: from web65409.mail.ac4.yahoo.com (web65409.mail.ac4.yahoo.com
	[76.13.9.29])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n2OMsOgY017094
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 18:54:24 -0400
Message-ID: <751977.60511.qm@web65409.mail.ac4.yahoo.com>
Date: Tue, 24 Mar 2009 15:54:23 -0700 (PDT)
From: Tom Watson <sdc695@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: But all I want to do is view my webcam...
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


So I tried 'xawtv'.  It gave "No space left on device", which sounds weird to me.  Some information:
[~]$ /sbin/lsusb
Bus 001 Device 009: ID 0c45:6029 Microdia Triplex i-mini PC Camera
...[there were other USB devices]...
[tsw@xytar7a ~]$ xawtv -hwscan
This is xawtv-3.95, running on Linux/i686 (2.6.26.8-57.fc8)
looking for available devices
port 68-68
    type : Xvideo, image scaler
    name : XV_SWOV

/dev/video0: No space left on device
[~]$ xawtv
This is xawtv-3.95, running on Linux/i686 (2.6.26.8-57.fc8)
xinerama 0: 1600x1200+0+0
can't open /dev/video0: No space left on device
v4l2: open /dev/video0: No space left on device
v4l2: open /dev/video0: No space left on device
v4l: open /dev/video0: No space left on device
no video grabber device available
[~]$  
[~]$ ls -l /dev/vid*
lrwxrwxrwx 1 root root     6 Mar 24 15:40 /dev/video -> video0
crw-rw-rw- 1 root root 81, 0 Mar 24 15:40 /dev/video0

The 'dev' entries were created by plugging in the USB WebCam.  I just want to see my picture.  I thought it would be "easy".  It probably is, but then I'm the difficult one.  Any advice?

Thanks.
-- 
Tom Watson


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
