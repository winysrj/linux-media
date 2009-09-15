Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:53830 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZIOIQA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 04:16:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: Handling second output from vpfe capture  - Any suggestion ?
Date: Tue, 15 Sep 2009 10:16:52 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <A69FA2915331DC488A831521EAE36FE40154FACF34@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40154FACF34@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909151016.52279.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

sorry for the late reply, I was on holidays.

On Friday 04 September 2009 15:03:00 Karicheri, Muralidharan wrote:
> Hi,
> 
> I am working on to add additional capabilities to vpfe capture driver to
>  allow capture two frames simultaneously for each received frame from the
>  input video decoder or sensor device. This is done using the IPIPE and
>  Resizer hw available in DM355. In our internal release this is done by
>  configuring IPIPE to receive from directly from CCDC and then passing it
>  to the Resizer. Resizer has two outputs that operates on the same input
>  frame. One output is usually used for capturing full resolution frame and
>  the other is limited to output VGA or less resolution frames. Typically
>  this will be useful for previewing the video on a smaller LCD screen using
>  the second output while using the full resolution frame for encoding.
> 
> Since input frame is same for both these inputs, we had implemented using a
>  bigger capture buffer that can hold both the frames. The second frame is
>  captured at the end of the first frame. This allowed us to DQBUF both
>  frames simultaneously. But we used proprietary IOCTL to change the output
>  size or format. I think a better alternative is to implement another Queue
>  in the vpfe capture that can take a V4L2_BUF_TYPE_PRIVATE. This will allow
>  me to configure the output format of second output independently for the
>  second output. Looking at the v4l2-ioctl.c there is support for this
>  buffer type. But this buffer type is not used by any driver and I am not
>  sure if this will work or is the right approach to deal with this problem.
>  Any suggestion here?

I think you should create two video devices, one to stream the full resolution 
video and the other one to stream the downscaled video. This is exactly the 
kind of use case that is going to be handled by the new media controller API.

-- 
Laurent Pinchart
