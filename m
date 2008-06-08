Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m58M17iu030104
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 18:01:07 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m58M0qND006091
	for <video4linux-list@redhat.com>; Sun, 8 Jun 2008 18:00:53 -0400
Message-ID: <484C568C.1060703@hhs.nl>
Date: Mon, 09 Jun 2008 00:00:44 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
References: <484934FD.1080401@hhs.nl>
	<200806070054.51210.laurent.pinchart@skynet.be>
	<484A2B45.1090200@hhs.nl>
	<200806082323.41607.laurent.pinchart@skynet.be>
In-Reply-To: <200806082323.41607.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: uvc open/close race (Was Re: v4l1 compat wrapper version 0.3)
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

Laurent Pinchart wrote:
>> I'm using a Logitech sphere usb id: 046d:08cc
>>
>> Fedora kernel: kernel-2.6.25-8.fc9, which includes UVC (added by Fedora).
> 
> That's a very buggy webcam. It has nasty firmware issues. See 
> http://www.quickcamteam.net/documentation/faq/logitech-webcam-linux-usb-incompatibilities
> 

Ah, I already feared that much, so its not MS's fault it doesn't work out of 
the box with vista then :)

>>> I would also appreciate if you could check the kernel log
>>> for error messages after triggering the problem.
>> No messages I'm afraid.
> 
> Now that's weird. The only error path that can return -EIO print a message to 
> the kernel log. Could you please double check ?
> 

Done,

There are some messages like this one:
uvcvideo: Failed to query (135) UVC control 7 (unit 2) : -75 (exp. 2).

(Also with different numbers) but those seemed harmless to me, as I interpreted 
them as could not get brightness / contrast / hue / etc. But maybe I 
misinterpreted them, sorry I should have reported them the first time.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
