Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0LJmANr017029
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 14:48:10 -0500
Received: from promwad.com (promwad.com [83.149.69.23])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0LJlmC4001118
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 14:47:49 -0500
Received: from [195.222.85.229] (helo=intranet.promwad.com)
	by promwad.com with esmtps (TLSv1:AES256-SHA:256) (Exim 4.63)
	(envelope-from <vladimir.davydov@promwad.com>) id 1LPj3C-0003TD-VY
	for video4linux-list@redhat.com; Wed, 21 Jan 2009 21:47:47 +0200
Received: from [93.84.68.10] (helo=[192.168.11.2])
	by intranet.promwad.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.69)
	(envelope-from <vladimir.davydov@promwad.com>) id 1LPj35-0007DG-AE
	for video4linux-list@redhat.com; Wed, 21 Jan 2009 21:47:41 +0200
From: Vladimir Davydov <vladimir.davydov@promwad.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Wed, 21 Jan 2009 21:46:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200901212146.39153.vladimir.davydov@promwad.com>
Content-Transfer-Encoding: 8bit
Subject: Request for new pixel format (JPEG2000)
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
Is it possible to add new pixel format to videodev2.h file?

#define V4L2_PIX_FMT_MJ2C   v4l2_fourcc('M','J','2','C') /* Morgan JPEG 2000*/

I have developed a V4L2 driver for the board with hardware JPEG2000 codec 
(ADV202 chip). This driver uses that pixel format.
I think JPEG 2000 is very perspective codec and it will be good if V4L2 will 
support it.

Short description of the device is here:
http://www.promwad.com/markets/linux-video-jpeg2000-blackfin.html

Thanks,
Vladimir.


-- 
Vladimir Davydov
Senior Developer
Promwad Innovation Company
Web: www.promwad.com
22, Olshevskogo St.,
220073, Minsk,
BELARUS
Phone/Fax: +375 (17) 312–1246
E-mail: vladimir.davydov@promwad.com
Skype: v_davydov

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
