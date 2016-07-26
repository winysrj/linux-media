Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33417 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbcGZJ1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 05:27:14 -0400
Received: by mail-qk0-f180.google.com with SMTP id p74so866637qka.0
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2016 02:27:13 -0700 (PDT)
Received: from mail-qk0-f177.google.com (mail-qk0-f177.google.com. [209.85.220.177])
        by smtp.gmail.com with ESMTPSA id u6sm18575285qtu.43.2016.07.26.02.27.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jul 2016 02:27:12 -0700 (PDT)
Received: by mail-qk0-f177.google.com with SMTP id p74so866334qka.0
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2016 02:27:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <153d8766-bb47-30a4-2d9a-c5bb65396ae5@free-electrons.com>
References: <153d8766-bb47-30a4-2d9a-c5bb65396ae5@free-electrons.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 26 Jul 2016 18:26:52 +0900
Message-ID: <CAAFQd5C3vWrGEBxw3d5ySPV1k2Q4dHz7tGFsyFEcS2LAp05Y4A@mail.gmail.com>
Subject: Re: Questions about userspace, request and frame API in your Rockchip
 VPU driver
To: Florent Revest <florent.revest@free-electrons.com>
Cc: posciak@chromium.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florent,

Let's keep more people in the loop. CCing Pawel, Hans, Laurent and
linux-media ML, as there might be more people interested in the status
and/or helping.

On Tue, Jul 26, 2016 at 4:50 PM, Florent Revest
<florent.revest@free-electrons.com> wrote:
> Hi Tomasz,
>
> I'm currently an intern at Free Electrons working with Thomas and Maxime
> who told me that they know you.

Yeah, say hi to them from me. ;)

> I work on a v4l2 m2m VPU driver for
> Allwinner SoCs. This VPU has very similar problematics as the ones you
> meet on the Rockchip's RK3229. For instance, it is not able to work on
> raw bitstream and needs prior frames parsing, which can't be done in
> kernel space.
>
> Some time ago, I asked on the #v4l IRC channel what I should do to
> implement this behavior correctly and Hans Verkuil told me to get in
> touch with Pawel Osciak, but he is probably busy with other things and
> couldn't answer yet.

Yeah, I'm pretty much sure he is.

>
> So basically, I'm curious about the state of the "Frame API" he talked
> about at the linux kernel summit media workshop.
> https://blogs.s-osg.org/planning-future-media-linux-linux-kernel-summit-media-workshop-seoul-south-korea/
> Do you know what is the status of this API ?

I think the H264 API is more or less in a good shape. I don't remember
exactly, but VP8 API might need a bit more work. There is also VP9 API
in the works, but it's a quite early stage. Both are more or less
blocked currently on the request API, which needs to be extended to
support controls and merged upstream. I believe all the APIs could
benefit from adding more platforms to the discussion.

>
> Is this the place where it is implemented ?
> http://lists.infradead.org/pipermail/linux-rockchip/2016-February/007557.html
> If I get it right, this is just a new extended control that is attached
> to a frame with the media request API from Laurent, am I right ? I still
> have troubles understanding the overall concept of the request API and
> I'd like to know more about your usage of it.

You're correct. Basically for this kind of dumb decoding there is a
need to attach additional data to each frame. In theory that could be
done by a series of qbuf, s_ctrl, qbuf, s_ctrl, but it would require a
contract with the driver, so that it latches the controls at qbuf time
and would make the driver do basically the same as the request API,
but on its own. That would overly complicate the driver, considering
that you might want to queue multiple frames for better parallelism
and each needs its own set of data.

>
> Also, the text says "The user space code should be implemented as
> libv4l2 plugins". And Hans told me the opposite on IRC.
>     kido | is developing a libv4l2 plugin interface which uses
> libavformat to pre-process buffers the "right" way to do it ?
>     hverkuil | kido: no, there isn't. [...]
>     hverkuil | Chances are he has code floating around for chromium that
> you can use.

Personally I think that a plugin would be a good way to deal with
legacy apps. Still, if I remember correctly, the preferred way is to
have a shared bitstream parser library and then use the slice/frame
API directly in the app, feeding the kernel with data from the parser.

>
> How is the userspace part of your rockchip driver implemented in Chrome
> OS and most importantly, do you have any userspace code available to share ?

I believe all the related code should be over there:

https://cs.chromium.org/chromium/src/media/gpu/

There are variants for VA-API, regular "smart" V4L2 codec API and
frame/slice API, which you are interested in. The class responsible
for talking the V4L2 frame/slice API is
v4l2_slice_video_decode_accelerator.cc and there should be also some
modules responsible for parsing the bitstream, but I don't have enough
knowledge on this code to point exactly.

Best regards,
Tomasz
