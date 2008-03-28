Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SLj2aC019062
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:45:02 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SLiokK031915
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 17:44:51 -0400
Message-ID: <47ED66AF.8030100@hhs.nl>
Date: Fri, 28 Mar 2008 22:44:15 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: spca50x-devs@lists.sourceforge.net, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: fedora-kernel-list@redhat.com
Subject: Self Introduction: Hans de Goede
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

Hi All,

I'm a Linux enthusiast / developer. Lately I'm mainly active doing development 
for Fedora and writing kernel drivers (and as my day job I'm a lecturer in 
Computer Science).

Fedora has a policy of not shipping a heavily patched kernel, but instead tries 
to work with upstream to get any needed patches integrated. This policy extends 
to not shipping any addon drivers, but rather working to get drivers integrated 
upstream.

As such I've decided to start spending my spare time on getting more and better 
usb webcam support integrated upstream (for non usb video class devices). I 
wanted to have something to show, so I've gone to the store, bought a couple of 
webcams and started hacking and learning.

2 days ago I have finished my first pretty clean, standalone v4l2 webcam driver 
for Pixart pac207 webcams.

In the beginning I modelled this driver after the zc301 and sn9c102 driver 
which are currently already in the mainline kernel, using the memory management 
and other structure from these drivers and filling in the hardware dependent 
parts with the pac207 code from the out of tree gpsca driver.

During the development I kept the buffer management from the zc301 driver, but 
modelled the rest of the driver more and more after gspca. For example don't 
start the iso stream on device open and throw away iso packets received before 
the stream-on ioctl, but instead start and stop the stream as needed.

This has resulted in what I consider a nice and clean pac207 driver. But when I 
finished it I noticed that a lot of code in their was generic code for any 
simple usb webcam.

Since I plan to write standalone v4l2 drivers for mainline inclusion for other 
simple usb webcams I spend the last 2 days splitting the code of my pac207 
driver into a generic usbvideo2 core (the kernel already has usbvideo, which 
has a number of v4l1 drivers) and a camera specific pac207 driver which builds 
on top of the usbvideo2 core.

So I've ended up with a model very much like gspca, but then not one large 
monolithic kernel module, but a more modular design with an core kernel module 
with (hopefully) generic code for simple usb webcam's, and a per usb controller 
chip type specific module (currently only one for pac207 controllers), and 
ofcourse very important this is code for v4l2 drivers, whereas the current 
gspca is v4l1.

I just recently (today) learned that there is work underway to make a v4l2 
version of gspca by Jean-François Moine: http://moinejf.free.fr/ ), I hope that 
we can work together somehow on getting support for all the webcam's supported 
in gscpa integrated into the mainline kernel with a v4l2 interface.

I'll be sending 2 seperate mails one with my standalone pac207 driver, and one 
with the usbvideo2 core and a pac207 driver using this core, I'll include 
Makefiles for out of tree building with both of them so that interested people 
can test them.

I'm currently posting these as .c files for easy reading and compilation / 
testing, but I still hope to get a lot of feedback / a thorough review, esp of 
the core <-> pac207 split version as I hope to submit that as a patch for 
mainline inclusion soon.

Thanks & Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
