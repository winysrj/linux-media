Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3TCSteD004731
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 08:28:55 -0400
Received: from cp-out3.libero.it (cp-out3.libero.it [212.52.84.103])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3TCSWXF029310
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 08:28:33 -0400
Received: from libero.it (192.168.16.58) by cp-out3.libero.it (8.0.013.5)
	id 4815F0A20019BCF6 for video4linux-list@redhat.com;
	Tue, 29 Apr 2008 14:28:27 +0200
Date: Tue, 29 Apr 2008 14:28:27 +0200
Message-Id: <K036NF$717D11728C2136F821BA75BAE0833FBC@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
From: "t0cin0" <t0cin0@libero.it>
To: "video4linux-list" <video4linux-list@redhat.com>
Content-Transfer-Encoding: 8bit
Subject: grabbing from two input channels on the same video device
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

Hi all,

I'm developing a video frame grabber with v4l2 api. I have a video device which is connected with two video cameras. Everything works fine with my bttv module, but I have some problems because I must switch input channel at run-time, grabbing frames repeatedly. I know that the VIDIOC_S_INPUT ioctl is insufficient as specified in the v4l2 API, in fact when I run the program some frames appear to be corrupted. How can I solve my problem? is there a proper solution which grabs a good quantity of frames per second? Thank you for the response and sorry for my english,
Massimiliano  


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
