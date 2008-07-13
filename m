Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6D8fQpD032104
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 04:41:26 -0400
Received: from vsmtp1.tin.it (vsmtp1.tin.it [212.216.176.141])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6D8fCnT014800
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 04:41:13 -0400
Message-ID: <4879BF3B.3020005@tiscali.it>
Date: Sun, 13 Jul 2008 09:39:23 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>, video4linux-list@redhat.com
References: <487908CA.8000304@tiscali.it> <48790D29.1010404@hhs.nl>
In-Reply-To: <48790D29.1010404@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: prototype of a USB v4l2 driver?
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

Hans de Goede wrote:
>> This is a good overview of a driver
>> http://lwn.net/Articles/203924/
>>
>> I think vivi.c is an other good one.
>>
>> Does anybody have any other good reference to look at?
>>
> 
> What kind of device, I think that for webcams you;re best using gspca, 
> (now merged in mecurial), that handles all the usb specific stuff, 
> buffer management, etc. In general it makes it easy to write a webcam 
> driver allowing you to focus on the interaction with the cam, rather 
> then having to worry about looking, usb specifics, buffer management etc.
> 

Yes, it is a USB webcam: Logitech QuickCam 4000 Pro USB

I will look into gspca and see how it works.

Thanks

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
