Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA5Fee0D018650
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 10:41:23 -0500
Received: from namebay.info (mail.namebay.info [80.247.68.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA5EAjNu003331
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 09:11:17 -0500
Received: from localhost by namebay.info (MDaemon PRO v9.6.2)
	with ESMTP id md50003731100.msg
	for <video4linux-list@redhat.com>; Wed, 05 Nov 2008 15:10:42 +0100
Message-ID: <20081105151400.8rdg045o5cs80080@webmail.hebergement.com>
Date: Wed, 05 Nov 2008 15:14:00 +0100
From: fpantaleao@mobisensesystems.com
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: About CITOR register value for pxa_camera
Reply-To: fpantaleao@mobisensesystems.com
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

Thank you for your answer.
I have tested with "67 x 1" resolution (and many others), I can't with  
"1619 x 1".
I don't get overruns with CITOR != 0.

Before submitting a patch, I would like to have the opinion of other
developpers about the CITOR value.
The resulting time-out is CITOR/CICLK. What we need is a time-out a bit
longer than 1 pixel period (1/PCLK).
The condition for CITOR is then: CITOR > CICLK/PCLK.
Since PCLK is a platform dependent value, I suggest to add a field in
pxacamera_platform_data.
If no value is assigned, a value of 16 can be used which equals 2 pixel
periods when PCLK=13MHz ("slow" sensor) and CICLK=104MHz (highest CI clock).
CITOR can be set in pxa_camera_activate.

Best regards

Florian

> fpantaleao@mobisensesystems.com writes:
>
> > Hi all,
> >
> > While testing, I think I have found one reason why overruns occur with
> > pxa_camera.
> > I propose to set CITOR to a non-null value.
> Yes, seconded.
>
> > I would appreciate any comment about this.
> Well, at first sight I would advice to test some corner case to see if DMA
> trailing bytes are handled well. I know this can be a pain, but you seem
to be
> testing thouroughly ..
>
> So, if your configuration/sensor is able to, try some funny resolution
like
> "1619 x 1", and then "67 x 1", and see what happens. If you don't have any
> capture issue, you're done, and post a patch (only CITOR or CITOR +
trailling
> bytes handling).
>
> Have fun.
>
> --
> Robert


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
