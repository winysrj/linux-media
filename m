Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:59224 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZCKBF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 21:05:59 -0400
Date: Tue, 10 Mar 2009 20:18:37 -0500 (CDT)
From: kilgota@banach.math.auburn.edu
To: Jean-Francois Moine <moinejf@free.fr>
cc: linux-media@vger.kernel.org
Subject: A question about documentation. 
In-Reply-To: <49B0DAF4.50408@redhat.com>
Message-ID: <alpine.LNX.2.00.0903101952230.13483@banach.math.auburn.edu>
References: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu> <200903052258.48365.elyk03@gmail.com> <alpine.LNX.2.00.0903052317070.28734@banach.math.auburn.edu> <49B0DAF4.50408@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Recently, I submitted a driver for the SQ905C cameras, for which I (partly 
due to being new to kernel video support) did not provide any update to 
Documentation/video4linux/gspca.txt.

I have not heard what has happened to the driver. I assume that what is 
going on is there is a race condition about getting things into 2.6.29, 
and there is not time to do a proper evaluation. While I am curious about 
the actual problem, though, that is not my question here.

Someone pointed out to me that I probably should have updated the 
aforementioned doc file. So I do have a question about that.

Here is the way that gspca.txt looks now (excerpt follows):

List of the webcams known by gspca.

The modules are:
         gspca_main      main driver
         gspca_xxxx      subdriver module with xxxx as follows

xxxx            vend:prod
----
spca501         0000:0000       MystFromOri Unknow Camera
m5602           0402:5602       ALi Video Camera Controller
spca501         040a:0002       Kodak DVC-325
spca500         040a:0300       Kodak EZ200

(and so on)

Well, now comes the question. I notice that each line in the file 
corresponds to a USB Vendor:Product ID, and each line corresponds to one 
camera, by brand name and model. Apparently, there is some blessed 
universe in which I have not been living the last few years, in which 
there is such a one-to-one correspondence.

Below, I give the list of supported cameras. extracted from 
libgphoto2/camlibs/digigr8. which as far as I am able to know is 
supporting precisely the same set of cameras as does the module sq905c.c

My question is obvious: Which of them do I list? All of them? A sampling 
of them? Or what?

Theodore Kilgore

(list follows)

----------------------------------------------------

static const struct {
         char *name;
         CameraDriverStatus status;
         unsigned short idVendor;
         unsigned short idProduct;
} models[] = {
         {"Digigr8", 				0x2770, 0x905c},
         {"Che-Ez Snap SNAP-U", 			0x2770, 0x905c},
         {"DC-N130t", 				0x2770, 0x905C},
         {"Soundstar TDC-35", 			0x2770, 0x905c},
         {"Nexxtech Mini Digital Camera", 	0x2770, 0x905c},
 	{"Vivitar Vivicam35", 			0x2770, 0x905c},
         {"Praktica Slimpix", 			0x2770, 0x905c},
         {"ZINA Mini Digital Keychain Camera", 	0x2770, 0x905c},
         {"Pixie Princess Jelly-Soft", 		0x2770, 0x905c},
         {"Sakar Micro Digital 2428x", 		0x2770, 0x905c},
         {"Jazz JDC9", 				0x2770, 0x905c},
         {"Disney pix micro", 			0x2770, 0x9050},
         {"Suprema Digital Keychain Camera",	0x2770, 0x913d},
 	{"Sakar 28290 and 28292  Digital Concepts Styleshot",
                         			0x2770, 0x913d},
 	{"Sakar 23070  Crayola Digital Camera", 0x2770, 0x913d},
 	{"Sakar 92045  Spiderman", 		0x2770, 0x913d},
 	{NULL,0,0,0}
};

As I said, which one(s) of these to list?
