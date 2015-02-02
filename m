Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:57507 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932871AbbBBLOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 06:14:05 -0500
Message-ID: <54CF5BC9.3040501@xs4all.nl>
Date: Mon, 02 Feb 2015 12:13:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Miguel Casas-Sanchez <mcasas@chromium.org>,
	linux-media@vger.kernel.org
Subject: Re: Vivid test device: adding YU12
References: <CAKoAQ7=kQyJLP62iAA43aDGGnnwVS8LAQBUK-FrwWWLFF2Tm6w@mail.gmail.com>
In-Reply-To: <CAKoAQ7=kQyJLP62iAA43aDGGnnwVS8LAQBUK-FrwWWLFF2Tm6w@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/29/2015 03:44 AM, Miguel Casas-Sanchez wrote:
> Hi folks, I've been trying to add a triplanar format to those that vivid
> can generate, and didn't quite manage :(
> 
> So, I tried adding code for it like in the patch (with some dprintk() as
> well) to clarify what I wanted to do. Module is insmod'ed like "insmod
> vivid.ko n_devs=1 node_types=0x1 multiplanar=2 vivid_debug=1"

You are confusing something: PIX_FMT_YUV420 is single-planar, not multi-planar.
That is, all image data is contained in one buffer. PIX_FMT_YUV420M is multi-planar,
however. So you need to think which one you actually want to support.

Another problem is that for the chroma part you need to average the values over
four pixels. So the TPG needs to be aware of the previous line. This makes the TPG
more complicated, and of course it is the reason why I didn't implement 4:2:0
formats :-)

I would implement YUV420 first, and (if needed) YUV420M and/or NV12 can easily be
added later.

Regards,

	Hans

> With the patch, vivid:
> - seems to enumerate the new triplanar format all right
> - vid_s_fmt_vid_cap() works as intended too, apparently
> - when arriving to vid_cap_queue_setup(), the size of the different
> sub-arrays does not look quite ok.
> - Generated video is, visually, all green.
> 
> I added as well a capture output dmesgs. Not much of interest here, the
> first few lines configure the queue -- with my few added dprintk it can be
> seen that the queue sizes are seemingly incorrect.
> 
> If and when this part is up and running, I wanted to use Vivid to test
> dma-buf based capture.
> 
> Big thanks!
> 

