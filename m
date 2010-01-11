Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0BBBS9x000976
	for <video4linux-list@redhat.com>; Mon, 11 Jan 2010 06:11:28 -0500
Received: from mail-px0-f185.google.com (mail-px0-f185.google.com
	[209.85.216.185])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0BBBCIe013599
	for <video4linux-list@redhat.com>; Mon, 11 Jan 2010 06:11:12 -0500
Received: by pxi15 with SMTP id 15so15900982pxi.23
	for <video4linux-list@redhat.com>; Mon, 11 Jan 2010 03:11:11 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 11 Jan 2010 12:11:11 +0100
Message-ID: <fe6fd5f61001110311o132e8370jc6811a9fdd9559a0@mail.gmail.com>
Subject: Unable to open /dev/vid
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi!,
I am working in a driver for video with soc-camera, but  I have a problem
when I open /dev/video0 in the aplication. I think that the register of
driver is good, but when I run the aplication in my system I have a problem
to open the driver, the aplication is correct but the function
soc_camera_open don't run. I don't know where look at, and I am lost, can
anybody help me? where can I look at for solver this problem? in the
directory /dev is "video0".


thanks.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
