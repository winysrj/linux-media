Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1RMGFLC014253
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 17:16:15 -0500
Received: from sperry-03.control.lth.se (sperry-03.control.lth.se
	[130.235.83.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1RMFt08012393
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 17:15:56 -0500
Received: from nieman.control.lth.se (nieman.control.lth.se [130.235.83.196])
	(authenticated bits=0)
	by sperry-03.control.lth.se (8.14.2/8.14.2) with ESMTP id
	n1RMFshO005631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 23:15:54 +0100
Message-ID: <49A8661A.4090907@control.lth.se>
Date: Fri, 27 Feb 2009 23:15:54 +0100
From: Anders Blomdell <anders.blomdell@control.lth.se>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Topro 6800 driver
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

I'm trying to write a driver for a webcam based on Topro TP6801/CX0342
(06a2:0003). My first attempt (needs gspca) can be found on:

http://www.control.lth.se/user/andersb/tp6800.c

Unfortunately the JPEG images (one example dump is in
http://www.control.lth.se/user/andersb/topro_img_dump.txt), seems to be bogus,
they start with (data is very similar to windows data):

00000000: 0xff,0xd8,0xff,0xfe,0x28,0x3c,0x01,0xe8,...
...
0000c340: ...,0xf4,0xc0,0xff,0xd9

Anybody who has a good idea of how to find a DQT/Huffman table that works with
this image data?

Best regards

Anders Blomdell

-- 
Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 4625
P.O. Box 118                     Fax:      +46 46 138118
SE-221 00 Lund, Sweden

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
