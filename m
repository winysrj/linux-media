Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m577hAxX029779
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 03:43:10 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m577ggjr018065
	for <video4linux-list@redhat.com>; Sat, 7 Jun 2008 03:42:43 -0400
Message-ID: <484A2DDB.6090705@hhs.nl>
Date: Sat, 07 Jun 2008 08:42:35 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: engage <engage@n0sq.us>
References: <200806061812.30755.engage@n0sq.us>
In-Reply-To: <200806061812.30755.engage@n0sq.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: webcams
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

engage wrote:
> I don't know if I'm OT but I believe that v4l is used with usb webcams. I just 
> bought an HP webcam but can't get it to work in Mandriva 2008.1 with amsn or 
> camorama on any PC. lsusb says it's a Pixart Imaging device.
> 
> lsusb output:
> 
> Bus 003 Device 002: ID 093a:2621 Pixart Imaging, Inc.
> 

That looks like an pixart 731x id to me, unfortunately adding extra usb id's to 
gspca is harder then it should be, so I've added the above id for you, here is 
a version with this ID included for you to build and try (follow the included 
instructions):
http://people.atrpms.net/~hdegoede/gspcav1-20071224-extra-usb-id.tar.gz

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
