Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:44026 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752917AbdFUCqv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 22:46:51 -0400
Message-ID: <1498013205.24451.9.camel@mtksdaap41>
Subject: Re: [PATCH v2] [media] mtk-mdp: Fix g_/s_selection capture/compose
 logic
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        "Eddie Huang" <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Wed, 21 Jun 2017 10:46:45 +0800
In-Reply-To: <74fa6870-fc5e-13b2-a111-cf9f2e83034c@xs4all.nl>
References: <1494556970-12278-1-git-send-email-minghsiu.tsai@mediatek.com>
         <a180f2fc-1dce-3630-ed48-25c247eff79a@xs4all.nl>
         <1497866607.25194.14.camel@mtksdaap41>
         <74fa6870-fc5e-13b2-a111-cf9f2e83034c@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-06-19 at 12:10 +0200, Hans Verkuil wrote:
> On 06/19/2017 12:03 PM, Minghsiu Tsai wrote:
> > Hi, Hans,
> > 
> > On Fri, 2017-06-16 at 12:42 +0200, Hans Verkuil wrote:
> >> On 05/12/17 04:42, Minghsiu Tsai wrote:
> >>> From: Daniel Kurtz <djkurtz@chromium.org>
> >>>
> >>> Experiments show that the:
> >>>   (1) mtk-mdp uses the _MPLANE form of CAPTURE/OUTPUT
> >>
> >> Please drop this, since this no longer applies to this patch.
> >>
> > 
> > I will remove it next version
> > 
> > 
> >>>   (2) CAPTURE types use CROP targets, and OUTPUT types use COMPOSE targets
> >>
> >> Are you really certain about this?
> >>
> >> For m2m devices the output (i.e. memory to hardware) typically crops from memory
> >> and the capture side (hardware to memory) composes into memory.
> >>
> >> I.e.: for the output side you crop the part of the memory buffer that you want
> >> to process and on the capture side you compose the result into a memory buffer:
> >> i.e. the memory buffer might be 1920x1080, but you compose the decoder output
> >> into a rectangle of 640x480 at offset 128x128 within that buffer (just an example).
> >>
> >> CAPTURE using crop would be if, before the data is DMAed, the hardware decoder
> >> output is cropped. E.g. if the stream fed to the decoder is 1920x1080, but you
> >> want to only DMA a subselection of that, then that would be cropping, and it
> >> would go to a memory buffer of the size of the crop selection.
> >>
> >> OUTPUT using compose is highly unlikely: that means that the frame you give
> >> is composed in a larger internal buffer with generated border data around it.
> >> Very rare and really only something that a compositor of some sort would do.
> >>
> > 
> > That's strange. In v4l2-ioctl.c, v4l_g_crop()
> > OUTPUT is using COMPOSE
> > CAPTURE is using CROP
> 
> The old crop API can't be used with most (all?) codec drivers. Codec drivers do
> exactly the opposite of what the old crop API did.
> 
> It is the reason the selection API was created.
> 
> The old crop API was written for SDTV receivers where the hardware would crop
> the received video. For output (rarely used) the hardware would compose the
> image into a larger (PAL or NTSC sizes) frame.
> 
> Applications have to use the selection API to work with codec drivers. Just
> ignore the old crop ioctls, they are not suitable for such hardware.
> 

Hi, Hans,
  Thanks for your review and comment. 
  Conclusion is application uses wrong ioctls, g/s_crop.

> > 
> > static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
> > 				struct file *file, void *fh, void *arg)
> > ...
> > 	/* crop means compose for output devices */
> > 	if (V4L2_TYPE_IS_OUTPUT(p->type))
> > 		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> > 	else
> > 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> > 
> > 	ret = ops->vidioc_g_selection(file, fh, &s);
> > 
> > 
> >> What exactly does the hardware do? Both for the encoder and for the decoder
> >> case. Perhaps if I knew exactly what that is, then I can advise.
> >>
> > 
> > NV12M/YUV420M/MT21 -> MDP -> NV12M/YUV420M
> > 
> > The usage would be like this:
> > For decoder:
> > decoder -> MT21 -> MDP -> NV12M/YUV420M
> > 
> > For encoder:
> > NV12M/YUV420M -> MDP -> NV12M/YUV420M -> encoder
> 
> That doesn't help. Where in these two chains does the cropping (encoder) or
> composing (decoder) take place? I assume it is the DMA engine that read from
> a rectangle in the source buffer (encoder) or writes to a rectangle in the
> destination buffer (decoder).
> 

 Yes. they are only buffer transfer between decoder, mdp and encoder.


> And in that case the current driver is correct.

 Next step, we will try to refine framework in userspace code.


> I wonder if the g/s_crop description in the V4L2 Specification should get a
> big fat warning that it doesn't apply to codec drivers and that the selection
> API should be used instead. A patch for that is welcome!
>
> Regards,
> 
> 	Hans
