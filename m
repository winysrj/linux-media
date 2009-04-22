Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3MCTYqh023739
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 08:29:34 -0400
Received: from mout3.freenet.de (mout3.freenet.de [195.4.92.93])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3MCTIjj031125
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 08:29:19 -0400
Received: from [195.4.92.24] (helo=14.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID exim) (port 25) (Exim 4.69 #88)
	id 1LwbZm-0001OJ-8z
	for video4linux-list@redhat.com; Wed, 22 Apr 2009 14:29:18 +0200
Received: from www3.emo.freenet-rz.de ([194.97.107.200]:16584)
	by 14.mx.freenet.de with esmtpa (ID exim) (port 25) (Exim 4.69 #79)
	id 1LwbZm-0003fU-8G
	for video4linux-list@redhat.com; Wed, 22 Apr 2009 14:29:18 +0200
Received: from www-data by www3.emo.freenet-rz.de with local (Exim 4.67 1
	(Panther_1)) id 1LwbZl-00027n-E5
	for <video4linux-list@redhat.com>; Wed, 22 Apr 2009 14:29:17 +0200
To: video4linux-list@redhat.com
From: judith.baumgarten@freenet.de
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Message-Id: <E1LwbZl-00027n-E5@www3.emo.freenet-rz.de>
Date: Wed, 22 Apr 2009 14:29:17 +0200
Content-Transfer-Encoding: 8bit
Subject: setting values to CICR2 register in PXA320 Quick Capture Interface
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

I want to set various parameters in the Quick Capture Interface for a PXA320 processor. I think, I found a way to do this, for resolution and pixel clock parameters, but there is no way to set the parameters of CICR2 using the actual pxa_camera driver. It seems the driver  just implements the master mode, and I wondered why. Is it not usefull to run a pxa_camera in slave mode?

Nevertheless. CICR2 contains also the BLW (Beginning-of-Line Pixel Clock Wait Count) parameter, which is used in master and slave mode. So I wondered, why there isn't a way to set it (Or have I just missed it?).
Here some extra information: I use V4L2 in combination with soc_camera interface and a PXA320 host. The soc_camera interface and pxa_camera driver are out of the 2.6.29 kernel.

Thanks
Judith







#adBox3 {display:none;}



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
