Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3J9mXO011624
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 14:09:48 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA3J9ces024245
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 14:09:38 -0500
Date: Mon, 3 Nov 2008 20:09:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
In-Reply-To: <87skq87mgp.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0811031944340.7744@axis700.grange>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
	<87skq87mgp.fsf@free.fr>
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
> > On Fri, 31 Oct 2008, Robert Jarzmik wrote:
> >
> > Hm, I am not all that happy about it. The first part is ok - it is indeed 
> > a 16-bit format. But the second part doesn't seem right. Before you were 
> > using the non-swapped camera configuration unconditionally. Now you swap 
> > it - also unconditionally. Whereas under different conditions we need 
> > different byte order. Here we arrive again at pixel-format negotiation 
> > between the host and the camera...
> We've already talked about it in August.
> 
> I agree the clean fix will be through format negociation. And that clean fix
> will impact mt9m111 driver, pxa camera driver, and maybe other camera drivers.
> 
> So even if you or I make the clean patch for the 2.6.28-rc branch, this little
> fix should go into 2.6.27.n fix branch, as all mt9m111 users are _by now_ on pxa
> bus.

Hm, wondering how you know?:-) I agree most probably there are about 2 
users of this driver in the world:-), but who knows?

I'm adding Mike Rapoport - the author of YCbCr support in pxa-camera 
(sorry, should have done this from the beginning of this thread) to CC to 
ask for his opinion - do we understand it right that pxa270 actually 
supports UYVY and not YUYV? Any objections against fixing this? Here's a 
link to the archived thread: http://marc.info/?t=122531935000001&r=1&w=2

> The clean patch obviously can't, because of impacts on other drivers.
> 
> I would strongly encourage you to push the fix into the stable branch, and wait
> for my clean patch or make the patch yourself.
> 
> > Next, let's see how data is transferred over the 8-bit data bus. The 
> > PXA270 is expecting the data in the order
> >
> > UYVY.... (Table 27-19)
> >
> > MT9M111 can either send UYVY or YUYV depending on the value of bit 1 in 
> > Output Format Control register(s). Now we know, that 
> > OUTPUT_FORMAT_CTRL2[1] = 1 matches PXA270 format (UYUV), hence 
> > OUTPUT_FORMAT_CTRL2[1] = 0 means YUYV, which might be necessary for other 
> > camera hosts.
> True. Assuming the mt9m111 specification is correct, table 27-19 is wrong, and
> real byte order for pxa is UYUV.

I don't see why 27-19 should be wrong - it specifies exactly the byte 
order CbYCrY, i.r., UYVY (I think, this is what you meant by "UYUV".)

> > So, we have: PXA270 supports V4L2_PIX_FMT_UYVY on input and can convert it 
> > to either V4L2_PIX_FMT_UYVY or V4L2_PIX_FMT_YUV422P on output.
> Yep.
> 
> > MT9M111 supports V4L2_PIX_FMT_UYVY and V4L2_PIX_FMT_YUYV (as well as 
> > V4L2_PIX_FMT_VYUY and V4L2_PIX_FMT_YVYU) on output. Now, PXA270 driver 
> > should accept user requests for UYVY and YUV422P and request UYUV from the 
> > camera.
> Yep.
> >
> > I think, we could just add another format entry to mt9m111 with 
> > V4L2_PIX_FMT_UYVY and set OUTPUT_FORMAT_CTRL2[1] if _that_ format is 
> > requested, as opposed to V4L2_PIX_FMT_YUYV. This way mt9m111's behaviour 
> > will not change, and will even become correct:-) And in pxa driver we 
> > should check for V4L2_PIX_FMT_UYVY and _not_ V4L2_PIX_FMT_YUYV. And, of 
> > course, mt9m111 users will have to switch to use V4L2_PIX_FMT_UYVY in 
> > their user-space applications. Does this sound acceptable?
> Yes. Even better, mt9m111 should offer :
>  - V4L2_PIX_FMT_UYVY
>  - V4L2_PIX_FMT_VYUY
>  - V4L2_PIX_FMT_YUYV
>  - V4L2_PIX_FMT_YVYU
> And setup the output format accordingly.

Good, then this is the fix that I'd like to have. It seems pretty simple, 
it will preserve behaviour of mt9m111. It will change the behaviour of 
pxa-camera for the YUYV format, to be precise, it will stop supporting 
this format. So, I would print out a warning, explaining that this format 
is not supported by pxa270 and the user should use UYVY instead. I 
suggested to add only one format to mt9m111 so far, just because this is 
the easiest as a bug-fix. But if you prefer, you can add all four, yes.

> > In the longer run we should do something along the lines:
> >
> > 1. merge .try_bus_param() into .try_fmt_cap() camera host methods - they 
> > are called only at one place one after another.
> Agreed.
> 
> > 2. add a data format table list similar to the one in struct 
> > soc_camera_device (or identical) to struct soc_camera_host.
> For negociation. Absolutely.
> 
> > 3. soc_camera.c should use the list from struct soc_camera_host in calls 
> > to format_by_fourcc().
> >
> > 4. camera host drivers then decide based upon user request which format to 
> > request from the camera in calls to .try_fmt_cap() and .set_fmt_cap() 
> > methods from struct soc_camera_ops.
> Yes.
> 
> I'll see what I can do.

I started working on this, (1) is of course simple, then I fixed one more 
issue with bus-width configuration, and I started (2)...

> Meanwhile, please send the patch into the fix 2.6.27 fix branch.

Still, I would really prefer to see the version described above - add more 
formats to mt9m111 and fix pxa270 to claim the correct format and print a 
warning for YUYV. This shouldn't be much more difficult to make than the 
proposed patch, and it will be correct. I made enough bad experiences with 
"temporary fixes" to try to avoid them as much as possible:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
