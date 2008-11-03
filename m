Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3HOH9T031768
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:24:17 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mA3HO6vN024726
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:24:07 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
	<Pine.LNX.4.64.0811022048430.14486@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 03 Nov 2008 18:23:18 +0100
In-Reply-To: <Pine.LNX.4.64.0811022048430.14486@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun\,
	2 Nov 2008 22\:15\:29 +0100 \(CET\)")
Message-ID: <87skq87mgp.fsf@free.fr>
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

> On Fri, 31 Oct 2008, Robert Jarzmik wrote:
>
> Hm, I am not all that happy about it. The first part is ok - it is indeed 
> a 16-bit format. But the second part doesn't seem right. Before you were 
> using the non-swapped camera configuration unconditionally. Now you swap 
> it - also unconditionally. Whereas under different conditions we need 
> different byte order. Here we arrive again at pixel-format negotiation 
> between the host and the camera...
We've already talked about it in August.

I agree the clean fix will be through format negociation. And that clean fix
will impact mt9m111 driver, pxa camera driver, and maybe other camera drivers.

So even if you or I make the clean patch for the 2.6.28-rc branch, this little
fix should go into 2.6.27.n fix branch, as all mt9m111 users are _by now_ on pxa
bus. The clean patch obviously can't, because of impacts on other drivers.

I would strongly encourage you to push the fix into the stable branch, and wait
for my clean patch or make the patch yourself.

> Next, let's see how data is transferred over the 8-bit data bus. The 
> PXA270 is expecting the data in the order
>
> UYVY.... (Table 27-19)
>
> MT9M111 can either send UYVY or YUYV depending on the value of bit 1 in 
> Output Format Control register(s). Now we know, that 
> OUTPUT_FORMAT_CTRL2[1] = 1 matches PXA270 format (UYUV), hence 
> OUTPUT_FORMAT_CTRL2[1] = 0 means YUYV, which might be necessary for other 
> camera hosts.
True. Assuming the mt9m111 specification is correct, table 27-19 is wrong, and
real byte order for pxa is UYUV.

> So, we have: PXA270 supports V4L2_PIX_FMT_UYVY on input and can convert it 
> to either V4L2_PIX_FMT_UYVY or V4L2_PIX_FMT_YUV422P on output.
Yep.

> MT9M111 supports V4L2_PIX_FMT_UYVY and V4L2_PIX_FMT_YUYV (as well as 
> V4L2_PIX_FMT_VYUY and V4L2_PIX_FMT_YVYU) on output. Now, PXA270 driver 
> should accept user requests for UYVY and YUV422P and request UYUV from the 
> camera.
Yep.
>
> I think, we could just add another format entry to mt9m111 with 
> V4L2_PIX_FMT_UYVY and set OUTPUT_FORMAT_CTRL2[1] if _that_ format is 
> requested, as opposed to V4L2_PIX_FMT_YUYV. This way mt9m111's behaviour 
> will not change, and will even become correct:-) And in pxa driver we 
> should check for V4L2_PIX_FMT_UYVY and _not_ V4L2_PIX_FMT_YUYV. And, of 
> course, mt9m111 users will have to switch to use V4L2_PIX_FMT_UYVY in 
> their user-space applications. Does this sound acceptable?
Yes. Even better, mt9m111 should offer :
 - V4L2_PIX_FMT_UYVY
 - V4L2_PIX_FMT_VYUY
 - V4L2_PIX_FMT_YUYV
 - V4L2_PIX_FMT_YVYU
And setup the output format accordingly.

> In the longer run we should do something along the lines:
>
> 1. merge .try_bus_param() into .try_fmt_cap() camera host methods - they 
> are called only at one place one after another.
Agreed.

> 2. add a data format table list similar to the one in struct 
> soc_camera_device (or identical) to struct soc_camera_host.
For negociation. Absolutely.

> 3. soc_camera.c should use the list from struct soc_camera_host in calls 
> to format_by_fourcc().
>
> 4. camera host drivers then decide based upon user request which format to 
> request from the camera in calls to .try_fmt_cap() and .set_fmt_cap() 
> methods from struct soc_camera_ops.
Yes.

I'll see what I can do. Meanwhile, please send the patch into the fix 2.6.27 fix branch.

--
Robert

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
