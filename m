Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7HEhxP002518
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 12:14:43 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7HEMWO015339
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 12:14:22 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811070040130.8681@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 07 Nov 2008 18:14:20 +0100
In-Reply-To: <Pine.LNX.4.64.0811070040130.8681@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri\,
	7 Nov 2008 00\:52\:12 +0100 \(CET\)")
Message-ID: <874p2jlaqb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Fix YUV format handling.
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

> On Fri, 7 Nov 2008, Robert Jarzmik wrote:
>
>> Allows all YUV formats on pxa interface. Even if PXA capture
>> interface expects data in UYVY format, we allow all formats
>
> Here you call it UYVY, and I agree with it, however, in the comment in the 
> patch you call it VYUY, which, I think is less natural.
Yes, the patch is wrong.
It's UYVY (Cb Y Cr Y). I'll amend the patch.

> i.e., you call mt9m111's default format "UYVY", and again, I think, this 
> is logical. If both datasheets are correct, this is also the format 
> expected by the PXA, so, you should translate YUV planar to UYVY. Have you 
> tested it?
Yes, I had.
And I didn't saw the problem. I checked again today, and the image is greyish.

I was using my phone and myself as the picture model. My pullover is white, I'm
grey lately, the background is grey also, as is the phone. Thus, even if the
image looked correct, it was not.

I tried again today the planar YUV422P, but with a bright red pullover. With
either UYVY or VYUY, the colors are not displayed, all remains grey. I don't
really know if the problem comes from my image transformation (yuvsplittoppm),
or from the pxa_camera driver. I'll dig deeper this week-end.

> Do I understand it right from the pxa270 datasheet, that UYVY would be the 
> only possible format if it were used for overlay2? Then I would mention 
> this here as well.
As you wish.

> So, let's just get the naming consistent. Are you also planning to update 
> your "Add new pixel format VYUY 16 bits wide" patch as requested by Hans 
> Verkuil? Then you could put all these patches in a patch series to make it 
> easier to manage them:-)
I didn't get that mail, either on direct destination or from the mailing
list. I'll look into the archives.

> Also, I would _at the very least_ give credit to Antonio Ospite for 
> reporting the problem and suggesting a first fix in your patch for 
> mt9m111. Eventually we would also like to have a Tested-by from him.
Yes, of course.

--
Robert

PS: I didn't mentioned it yet, but I had amended the mt9m111 patch, because
format_by_fourcc() in soc_camera.c is looking for YUV422P in mt9m111 formats,
even if pxa_camera translates the format.
This would deserve a cleaner patch, if you can think of one ...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
