Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:59443 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752723AbcGZLtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 07:49:35 -0400
Subject: Re: Questions about userspace, request and frame API in your Rockchip
 VPU driver
To: Tomasz Figa <tfiga@chromium.org>
References: <153d8766-bb47-30a4-2d9a-c5bb65396ae5@free-electrons.com>
 <CAAFQd5C3vWrGEBxw3d5ySPV1k2Q4dHz7tGFsyFEcS2LAp05Y4A@mail.gmail.com>
Cc: posciak@chromium.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Florent Revest <florent.revest@free-electrons.com>
Message-ID: <7d8e70b6-a9bc-204d-470b-5a815b886f2e@free-electrons.com>
Date: Tue, 26 Jul 2016 13:49:32 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C3vWrGEBxw3d5ySPV1k2Q4dHz7tGFsyFEcS2LAp05Y4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26/07/2016 11:26, Tomasz Figa wrote:
> I think the H264 API is more or less in a good shape. I don't remember
> exactly, but VP8 API might need a bit more work. There is also VP9 API
> in the works, but it's a quite early stage. Both are more or less
> blocked currently on the request API, which needs to be extended to
> support controls and merged upstream. I believe all the APIs could
> benefit from adding more platforms to the discussion.

Alright, I'll follow their development closely.

> You're correct. Basically for this kind of dumb decoding there is a
> need to attach additional data to each frame. In theory that could be
> done by a series of qbuf, s_ctrl, qbuf, s_ctrl, but it would require a
> contract with the driver, so that it latches the controls at qbuf time
> and would make the driver do basically the same as the request API,
> but on its own. That would overly complicate the driver, considering
> that you might want to queue multiple frames for better parallelism
> and each needs its own set of data.

This is indeed what I've been doing until now and I'm currently
switching to the request API to address this kind of issues. Thanks for
making it clearer!

I have another question regarding reference frames though. In
rockchip_vpu, you are referring to previous frames with their index in
"dst_bufs". Isn't it a problem to access buffers that have already been
dequeued by the driver ?

>> Also, the text says "The user space code should be implemented as
>> libv4l2 plugins". And Hans told me the opposite on IRC.
>>     kido | is developing a libv4l2 plugin interface which uses
>> libavformat to pre-process buffers the "right" way to do it ?
>>     hverkuil | kido: no, there isn't. [...]
>>     hverkuil | Chances are he has code floating around for chromium that
>> you can use.
> 
> Personally I think that a plugin would be a good way to deal with
> legacy apps. Still, if I remember correctly, the preferred way is to
> have a shared bitstream parser library and then use the slice/frame
> API directly in the app, feeding the kernel with data from the parser.

In ChromeOS, I understand that "directly in the app" refers to chromium.
But in a more traditional linux desktop userspace, I'm still open to
suggestions of alternatives to a libv4l2 plugin. I thought about a VA
API backend for slice API but if anyone has a better idea to suggest,
please let me know.

>> How is the userspace part of your rockchip driver implemented in Chrome
>> OS and most importantly, do you have any userspace code available to share ?
> 
> I believe all the related code should be over there:
> 
> https://cs.chromium.org/chromium/src/media/gpu/
> 
> There are variants for VA-API, regular "smart" V4L2 codec API and
> frame/slice API, which you are interested in. The class responsible
> for talking the V4L2 frame/slice API is
> v4l2_slice_video_decode_accelerator.cc and there should be also some
> modules responsible for parsing the bitstream, but I don't have enough
> knowledge on this code to point exactly.

Great, thanks for pointing me to this code, this is indeed what I've
been searching for and it will be very helpful !

BR,
    Florent

-- 
Florent Revest, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
