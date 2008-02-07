Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17NY9WC007819
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:34:09 -0500
Received: from mail11b.verio-web.com (mail11b.verio-web.com [204.202.242.87])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m17NXY37023212
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 18:33:34 -0500
Received: from mx62.stngva01.us.mxservers.net (204.202.242.132)
	by mail11b.verio-web.com (RS ver 1.0.95vs) with SMTP id 3-0526837213
	for <video4linux-list@redhat.com>; Thu,  7 Feb 2008 18:33:33 -0500 (EST)
From: "Charlie Liu" <charlie@sensoray.com>
To: "Yan Seiner" <yan@seiner.com>,
	"Linux and Kernel Video" <video4linux-list@redhat.com>
Date: Thu, 7 Feb 2008 15:33:56 -0800
Message-ID: <OMEBIANONJKPPNMIBDLHIEAHGLAA.charlie@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <47AB0FB0.5070503@seiner.com>
Cc: 
Subject: RE: hardware requirements for webcams?
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

iEi World PM-LX-800 is a good AMD-LX800 based PC/104-form-factor CPU board:
500MHz, around ~$200.00 cost + PC2700 So-DIMM. Check out at:
http://www.ieiworld.com/en/product_IPC.asp?model=PM-LX

If you need industrial grade video/frame grabbers, check:
http://sensoray.com/products/frame_grabber.htm


Charlie X. Liu
@ http://www.sensoray.com


-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com]On Behalf Of Yan Seiner
Sent: Thursday, February 07, 2008 6:03 AM
To: Linux and Kernel Video
Subject: hardware requirements for webcams?


Hi everyone:

I need to build an embedded platform that can handle 2 webcams,
preferably at 640x480.  I've tested several typical embedded boards,
with 200 MHz arm or mips CPUs, and they can handle 1 webcam at 480x320.

Googling on webcams indicates that each webcam would have to have its
own USB controller as well as enough CPU horsepower to do the job (maybe
something in the 800 MHz range?)

Is anyone aware of an inexpensive fanless board that could do this?  Or
could provide some pointers on where I can look?

Thanks,

--Yan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
