Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANAvcMB008341
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 05:57:38 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANAvPsB032670
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 05:57:26 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <Pine.LNX.4.64.0811181945410.8628@axis700.grange>
	<Pine.LNX.4.64.0811182010460.8628@axis700.grange>
	<87y6zf76aw.fsf@free.fr>
	<Pine.LNX.4.64.0811202055210.8290@axis700.grange>
	<8763mg28bf.fsf@free.fr>
	<Pine.LNX.4.64.0811212051360.8956@axis700.grange>
	<878wrcztqb.fsf@free.fr>
	<Pine.LNX.4.64.0811212256160.8956@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 23 Nov 2008 11:46:57 +0100
In-Reply-To: <Pine.LNX.4.64.0811212256160.8956@axis700.grange> (Guennadi
	Liakhovetski's message of "Fri\,
	21 Nov 2008 23\:16\:33 +0100 \(CET\)")
Message-ID: <873ahilnxa.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 2/2 v3] pxa-camera: pixel format negotiation
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

>> I think it is documented in Micron MT9M111 datasheet, table 6, page 14.
>> My understanding is that it has a buswidth=8, and depth=16. But I may be wrong,
>> have a look with your trained eye and tell me please.
>
> I think we shouldn't (and possibly cannot) process this data in 
> pass-through mode on pxa270. In raw mode pxa270 expects each pixel to only 
> occupy one pixel clock. And we use icd->width and icd->height to configure 
> PXA registers in pxa_camera_set_bus_param(). Whereas in this case we would 
> have to lie to the PXA and configure it with, for example, the double 
> line-width. I think, this way it could work. Then your horizontal sync 
> would stay valid. So, I think, we have three options with this format:
>
> 1. Refuse to support this configuration, as PXA doesn't support 2 pixel 
> clocks per pixel in raw mode
>
> 2. Extend the API even further to allow for different geometries on the 
> sensor and on the controller. This, in fact, will anyway be required once 
> we support scaling on host...
>
> 3. Create a special translation entry for this mode and abuse some 16-bit 
> preprocessed format, like, e.g., RGB565. I _think_ this would work too, 
> because, in the end, PXA doesn't know what colour it should be:-)

Wow, that's clearly stated :)

I like both solutions 2 and 3. In solution 3, on YUV variant would be nicer I
think, because pxa reorders RGB while packing it, whereas VYUY is just passed
through.
I would even prefer a bit solution 3, just slightly, to split true host scaling
from "simulated" host scaling.

Now, it's up to you, make a choice. This would be anyway for the next patch
serie, not this one. I think we should finish that one ASAP (and I'm a bit late)
to stabilize the API.

Cheers.

--
Robert

PS: I forgot ... now I aggree we shouldn't use pass-through mode for 16bit
exotic formats :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
