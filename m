Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3DZVAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Apr 2013 17:00:53 -0400
Date: Fri, 26 Apr 2013 23:00:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] soc_camera: Add V4L2_MBUS_FMT_YUYV10_2X10 format
In-Reply-To: <OF3A7A50DA.5DC9276D-ON80257B59.0058D7D1-80257B59.005907F0@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1304262255270.5698@axis700.grange>
References: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1304242249410.16970@axis700.grange>
 <OF975E3643.061D9EDC-ON80257B58.003660C1-80257B58.00379495@eu.necel.com>
 <Pine.LNX.4.64.1304251241430.21045@axis700.grange>
 <OF94EFCFB7.8EC190E4-ON80257B58.00450077-80257B58.0049B035@eu.necel.com>
 <Pine.LNX.4.64.1304251535590.21045@axis700.grange>
 <OF3A7A50DA.5DC9276D-ON80257B59.0058D7D1-80257B59.005907F0@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil

On Fri, 26 Apr 2013, phil.edworthy@renesas.com wrote:

> Hi Guennadi,
> 
> <snip>
> > > > > > Wow, what kind of host can pack two 10-bit samples into 3 bytes 
> and 
> > > > > write 
> > > > > > 3-byte pixels to memory?
> > > > > I think I might have misunderstood how this is used. From my 
> > > > > understanding, the MBUS formats are used to describe the hardware 
> > > > > interfaces to cameras, i.e. 2 samples of 10 bits. I guess that the 
> 
> > > fourcc 
> > > > > field also determines what v4l2 format is required to capture 
> this. 
> > > > 
> > > > No, not quite. This table describes default "pass-through" capture 
> of 
> > > > video data on a media bus to memory. E.g. the first entry in the 
> table 
> > > > means, that if you get the V4L2_MBUS_FMT_YUYV8_2X8 format on the 
> bus, 
> > > you 
> > > > sample 8 bits at a time, and store the samples 1-to-1 into RAM, you 
> get 
> > > > the V4L2_PIX_FMT_YUYV format in your buffer. It can also describe 
> some 
> > > > standard operations with the sampled data, like swapping the order, 
> > > > filling missing high bits (e.g. if you sample 10 bits but store 16 
> bits 
> > > > per sample with high 6 bits nullified). The table also specifies 
> which 
> > > > bits are used for padding in the original data, e.g. 
> > > > V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE has SOC_MBUS_PACKING_2X8_PADLO, 
> > > whereas 
> > > > V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE has SOC_MBUS_PACKING_2X8_PADHI, 
> which 
> > > 
> > > > means, that out of 16 bits of data, that you get when you sample an 
> > > 8-bit 
> > > > bus twice, either low or high 6 bits are invalid and should be 
> > > discarded.
> > > 
> > > Ok, I see. However, is it necessary to provide a default pass-through 
> v4l2 
> > > format?
> > 
> > No, it's not. If no (soc-camera) host camera driver is willing to use 
> this 
> > pass-through conversion, then it's not required.
> Ok, I'll look at that when I get a moment!
> 
> > > I can't see a suitable v4l2 format! For the hardware I have been 
> > > working on, there is always the option of converting the data to 
> another 
> > > format, so this is not really needed. I doubt that it makes sense to 
> add 
> > > yet another v4l2 format for userspace, when typical uses would involve 
> the 
> > > host hardware converting the format to something else, e.g. 
> > > V4L2_PIX_FMT_RGB32.
> > 
> > Up to you, really. If you don't need this default conversion, don't add 
> > it.
> Ok, it seems like it would be a bad idea to provide a default conversion 
> that my not be supported by other hosts.

Right, that table collects "natural" conversions, mostly just 
straightforward bus-to-buffer. In your case of 2 10-bit samples such a 
natural transfer would produce one 16-bit word per sample, of which only 
10 bits are useful information. So, your 20 bits of pixel data would be 
located in bits 25:16 and 9:0 of each 32-bit (long)word. I don't think 
there is a fourcc code, describing such a buffer layout... It probably 
would be useless without a special conversion software.

Thanks
Guennadi

> > > > > However, I am not sure how the two relate to each other. How does 
> the 
> > > > > above code imply 3 bytes?
> > > > 
> > > > Not the above code, but your entry in the soc_mbus_bytes_per_line() 
> > > > function below, where you multiply width * 3.
> > > 
> > > It looks like hosts use soc_mbus_bytes_per_line() to report the size 
> of 
> > > video buffers needed. Shouldn't the hosts report the buffer metrics 
> for 
> > > the v4l2 format, since that is what will be output? What has this to 
> do 
> > > with the MBUS specifics?
> > 
> > struct soc_mbus_pixelfmt describes a conversion from an MBUS code to a 
> > pixel format in memory. Camera host drivers call that function with a 
> > _suitable_ conversion descriptor (either a standard or a special one) 
> and 
> > the function calculates the number of bytes.
> Right, I think I understand!
> 
> Thanks
> Phil
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
