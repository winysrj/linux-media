Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60957
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754037AbdA3T1z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 14:27:55 -0500
Date: Mon, 30 Jan 2017 17:18:21 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Hugues Fruchet <hugues.fruchet@st.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: Re: [GIT PULL FOR v4.11] New st-delta driver
Message-ID: <20170130171821.1ff63f52@vento.lan>
In-Reply-To: <20170130171536.07f4996d@vento.lan>
References: <b5f8fb46-6507-417c-8f1e-3b3f1410a64d@xs4all.nl>
        <20170130171536.07f4996d@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Jan 2017 17:15:36 -0200
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Mon, 9 Jan 2017 14:23:33 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > See the v4 series for details:
> > 
> > https://www.spinics.net/lists/linux-media/msg108737.html
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:
> > 
> >   [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)
> > 
> > are available in the git repository at:
> > 
> >   git://linuxtv.org/hverkuil/media_tree.git delta
> > 
> > for you to fetch changes up to e6f199d01e7b8bc4436738b6c666fda31b9f3340:
> > 
> >   st-delta: debug: trace stream/frame information & summary (2017-01-09 14:16:45 +0100)
> > 
> > ----------------------------------------------------------------
> > Hugues Fruchet (10):
> >       Documentation: DT: add bindings for ST DELTA
> >       ARM: dts: STiH410: add DELTA dt node
> >       ARM: multi_v7_defconfig: enable STMicroelectronics DELTA Support
> >       MAINTAINERS: add st-delta driver
> >       st-delta: STiH4xx multi-format video decoder v4l2 driver
> >       st-delta: add memory allocator helper functions
> >       st-delta: rpmsg ipc support
> >       st-delta: EOS (End Of Stream) support
> >       st-delta: add mjpeg support
> >       st-delta: debug: trace stream/frame information & summary
> 
> There is something wrong on this driver... even after applying all
> patches, it complains that there's a for there that does nothing:
> 
> drivers/media/platform/sti/delta/delta-v4l2.c:322 register_decoders() warn: we never enter this loop
> drivers/media/platform/sti/delta/delta-v4l2.c: In function 'register_decoders':
> drivers/media/platform/sti/delta/delta-v4l2.c:322:16: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>   for (i = 0; i < ARRAY_SIZE(delta_decoders); i++) {
>                 ^
> 
> On a first glance, it seems that the register_decoders() function is
> reponsible to register the format decoders that the hardware
> recognizes. If so, I suspect that this driver is deadly broken.
> 
> Please be sure that the upstream driver works properly before
> submitting it upstream.
> 
> Also, please fix the comments to match the Kernel standard. E. g.
> instead of:
> 
> /* guard output frame count:
>  * - at least 1 frame needed for display
>  * - at worst 21
>  *   ( max h264 dpb (16) +
>  *     decoding peak smoothing (2) +
>  *     user display pipeline (3) )
>  */
> 
> It should be:
> 
> /*
>  * guard output frame count:
>  * - at least 1 frame needed for display
>  * - at worst 21
>  *   ( max h264 dpb (16) +
>  *     decoding peak smoothing (2) +
>  *     user display pipeline (3) )
>  */
> 
> There are several similar occurrences among this patch series.

Ah, forgot to comment, but it mentions a firmware. Does such firmware
reside on some RAM memory? If so, how such firmware is loaded? 

> 
> Thanks,
> Mauro
> 
> Thanks,
> Mauro



Thanks,
Mauro
