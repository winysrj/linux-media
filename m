Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3KJtDP032289
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 15:19:55 -0500
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3KJsF7002636
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 15:19:54 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 03 Nov 2008 21:19:50 +0100
In-Reply-To: <Pine.LNX.4.64.0811031944340.7744@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon\,
	3 Nov 2008 20\:09\:53 +0100 \(CET\)")
Message-ID: <87mygg4l5l.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
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

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hm, wondering how you know?:-) I agree most probably there are about 2 
> users of this driver in the world:-), but who knows?
Yes, who knows ...

> I don't see why 27-19 should be wrong - it specifies exactly the byte 
> order CbYCrY, i.r., UYVY (I think, this is what you meant by "UYUV".)
Well, the one working configuration known, Antonio's is :
 - pxa CPU
 - mt9m111, with OUTPUT_FORMAT_CTRL[1]=1

According to the mt9m111 datasheet, table 3, page 14, when OUTPUT_FORMAT_CTRL[1]
= 1 and OUTPUT_FORMAT_CTRL[0] = 0, the MT9M111 sensor outputs data as follows :
 - byte1 = Y1
 - byte2 = Cb1
 - byte3 = Y2
 - byte4 = Cr1
 - and so on ...

According to PXA27x datasheet, table 27-19, input bytes from the sensor should
be :
 - byte1 = Cb1
 - byte2 = Y1
 - byte3 = Cr1
 - byte4 = Y2
 - and so on ...

Do you see the discrepancy now ? Either pxa27x datasheet of mt9m111 datasheet is
wrong, or else Antonio's setup wouldn't work.

> Good, then this is the fix that I'd like to have. It seems pretty simple, 
> it will preserve behaviour of mt9m111. It will change the behaviour of 
> pxa-camera for the YUYV format, to be precise, it will stop supporting 
> this format. So, I would print out a warning, explaining that this format 
> is not supported by pxa270 and the user should use UYVY instead. I 
> suggested to add only one format to mt9m111 so far, just because this is 
> the easiest as a bug-fix. But if you prefer, you can add all four, yes.
Right, so be it for the 4 formats.

> Still, I would really prefer to see the version described above - add more 
> formats to mt9m111 and fix pxa270 to claim the correct format and print a 
> warning for YUYV. This shouldn't be much more difficult to make than the 
> proposed patch, and it will be correct. I made enough bad experiences with 
> "temporary fixes" to try to avoid them as much as possible:-)

If you wish so. I'll watch you pushing the fix in the stable branch to see how
you convince people that changing the pxa camera driver is only a "fix" and not
an evolution :) Too bad for a quick working fix.

Cheers.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
