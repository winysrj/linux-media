Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:35014 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab2JDMMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 08:12:07 -0400
From: Tom Cooksey <Tom.Cooksey@arm.com>
To: Rob Clark <rob.clark@linaro.org>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: "mesa-dev@lists.freedesktop.org" <mesa-dev@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Jesse Barker <jesse.barker@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 4 Oct 2012 13:12:02 +0100
Subject: RE: [Linaro-mm-sig] [RFC] New dma_buf -> EGLImage EGL extension
Message-ID: <20E136AF98049A48A90A7417B4343D5E26906290C8@BUNGLE.Emea.Arm.com>
References: <503f7244.1180cd0a.7c47.ffffed02SMTPIN_ADDED@mx.google.com>
	<506AD9A9.3090506@gmail.com>
 <CAF6AEGsOURL56B+sy5BJ6VD8P3njEkrjkC8+J3NY4H8tyBUXdA@mail.gmail.com>
In-Reply-To: <CAF6AEGsOURL56B+sy5BJ6VD8P3njEkrjkC8+J3NY4H8tyBUXdA@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

> -----Original Message-----
> From: robdclark@gmail.com [mailto:robdclark@gmail.com] On Behalf Of Rob Clark
> Sent: 03 October 2012 13:39
> To: Maarten Lankhorst
> Cc: Tom Cooksey; mesa-dev@lists.freedesktop.org; linaro-mm-sig@lists.linaro.org; dri-
> devel@lists.freedesktop.org; Jesse Barker; linux-media@vger.kernel.org
> Subject: Re: [Linaro-mm-sig] [RFC] New dma_buf -> EGLImage EGL extension
>
> On Tue, Oct 2, 2012 at 2:10 PM, Maarten Lankhorst
> <m.b.lankhorst@gmail.com> wrote:
> > How do you want to deal with the case where Y' and CbCr are different hardware buffers?
> > Could some support for 2d arrays be added in case Y' and CbCr are separated into top/bottom
> fields?
> > How are semi-planar/planar formats handled that have a different width/height for Y' and
> CbCr? (YUV420)
>
> The API works (AFAIU) like drm addfb2 ioctl, take I420 for example,
> you could either do:
>
>   single buffer:
>      fd0 = fd
>      offset0 = 0
>      pitch0 = width
>      fd1 = fd
>      offset1 = width * height
>      pitch1 = width / 2
>      fd2 = fd
>      offset2 = offset1 + (width / height / 4)
>      pitch2 = width / 2
>
>   multiple buffers:
>      offset0 = offset1 = offset2 = 0
>      fd0 = fd_luma
>      fd1 = fd_u
>      fd2 = fd_v
>      ... and so on

Yup, that's pretty much how I'd envisaged it.


> for interlaced/stereo.. is sticking our heads in sand an option?  :-P
>
> You could get lots of permutations for data layout of fields between
> interlaced and stereo.  One option might be to ignore and let the user
> create two egl-images and deal with blending in the shader?

I think for interlaced video the only option really is to create two EGLImages as the two fields have to be displayed at different times. If the application wanted to display them progressively they'd have to run a de-interlacing filter over the two images. Perhaps writing such a filter as a GLSL shader might not be such a bad idea, but it's kinda the app's problem. Same deal with stereo.


Cheers,

Tom

PS: I've updated the spec and sent out a new draft.


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

