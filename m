Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3KqODq018122
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 15:52:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA3KqBQK022184
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 15:52:11 -0500
Date: Mon, 3 Nov 2008 21:52:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87mygg4l5l.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811032131410.7744@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
	<Pine.LNX.4.64.0811031944340.7744@axis700.grange>
	<87mygg4l5l.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 3 Nov 2008, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > Hm, wondering how you know?:-) I agree most probably there are about 2 
> > users of this driver in the world:-), but who knows?
> Yes, who knows ...
> 
> > I don't see why 27-19 should be wrong - it specifies exactly the byte 
> > order CbYCrY, i.r., UYVY (I think, this is what you meant by "UYUV".)
> Well, the one working configuration known, Antonio's is :
>  - pxa CPU
>  - mt9m111, with OUTPUT_FORMAT_CTRL[1]=1
> 
> According to the mt9m111 datasheet, table 3, page 14, when OUTPUT_FORMAT_CTRL[1]
> = 1 and OUTPUT_FORMAT_CTRL[0] = 0, the MT9M111 sensor outputs data as follows :
>  - byte1 = Y1
>  - byte2 = Cb1
>  - byte3 = Y2
>  - byte4 = Cr1
>  - and so on ...
> 
> According to PXA27x datasheet, table 27-19, input bytes from the sensor should
> be :
>  - byte1 = Cb1
>  - byte2 = Y1
>  - byte3 = Cr1
>  - byte4 = Y2
>  - and so on ...
> 
> Do you see the discrepancy now ? Either pxa27x datasheet of mt9m111 datasheet is
> wrong, or else Antonio's setup wouldn't work.

Yes, now I see it. Then we have to figure out which one is wrong... Or 
just decide as it best suits us. Would be interesting to know how the data 
is stored in RAM in the packed format - CbYCrY as is claimed in 27-21 or 
YCbYCr? Antonio, did you test in planar or in packed mode? Maybe you could 
test the packed mode and look at the data? One could also try to read data 
out of the FIFO, but that's too much work:-) I think, it would suffice to 
test in packed mode and use some standard application and see with what 
format it will produce the correct picture.

In fact, I think, it might even be, that both datasheets are correct and 
the testing was wrong. In packed mode pxa270 probably just pipes the data 
through one-to-one. So, if both datasheets are correct you would get UYUV 
in application buffers. Now, if you tell the application, that it's YUYV 
the picture will be wrong of course. And if you just swap the bytes _at_ 
_the_ _sensor_ the picture will be right, even though the pxa is only 
documented to work in UYUV mode. In packed mode it probably just doesn't 
care. Or am I missing something? Antonio, how did you test - in packed or 
planar mode and what format have you configured at the application level?

> > Good, then this is the fix that I'd like to have. It seems pretty simple, 
> > it will preserve behaviour of mt9m111. It will change the behaviour of 
> > pxa-camera for the YUYV format, to be precise, it will stop supporting 
> > this format. So, I would print out a warning, explaining that this format 
> > is not supported by pxa270 and the user should use UYVY instead. I 
> > suggested to add only one format to mt9m111 so far, just because this is 
> > the easiest as a bug-fix. But if you prefer, you can add all four, yes.
> Right, so be it for the 4 formats.
> 
> > Still, I would really prefer to see the version described above - add more 
> > formats to mt9m111 and fix pxa270 to claim the correct format and print a 
> > warning for YUYV. This shouldn't be much more difficult to make than the 
> > proposed patch, and it will be correct. I made enough bad experiences with 
> > "temporary fixes" to try to avoid them as much as possible:-)
> 
> If you wish so. I'll watch you pushing the fix in the stable branch to see how
> you convince people that changing the pxa camera driver is only a "fix" and not
> an evolution :) Too bad for a quick working fix.

Well, I am not at all sure we need it for 2.6.27-stable. This is not a 
regression.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
