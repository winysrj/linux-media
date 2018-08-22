Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59084 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbeHVKNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 06:13:16 -0400
Subject: Re: Question regarding optimizing pipeline in Vimc
To: Helen Koike <helen@koikeco.de>, linux-media@vger.kernel.org
Cc: Guilherme Alcarde Gallo <gagallo7@gmail.com>,
        =?UTF-8?Q?Lucas_Magalh=c3=a3es?= <lucmaga@gmail.com>
References: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
Date: Wed, 22 Aug 2018 08:49:40 +0200
MIME-Version: 1.0
In-Reply-To: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2018 05:35 AM, Helen Koike wrote:
> Hello,
> 
> One of the discussions we had when developing Vimc, was regarding
> optimizing image generation.
> The ideia was to generate the images directly in the capture instead
> of propagating through the pipeline (to make things faster).
> But my question is: if this optimization is on, and if there is a
> greyscaler filter in the middle of the pipeline, do you expect to see
> a grey image with this optimization?

Yes.

> Or if we just generate a dummy
> image (with the right size format) at the end of the pipeline, would
> it be ok? (I am asking because it doesn't sound that simple to
> propagate the image transformation made by each entity in the pipe)

No, that would not be OK.

My basic idea was that you use a TPG state structure that contains the
desired output: the sensor starts with e.g. 720p using some bayer pixelformat,
the debayer module replaces the pixelformat with e.g. PIX_FMT_RGB32, a
grayscale filter replaces it with PI_FMT_GREY, and that's what the TPG for the
video device eventually will use to generate the video.

This assumes of course that all the vimc blocks only do operations that can
be handled by the TPG. Depending on what the blocks will do the TPG might need
to be extended if a feature is missing.

Regards,

	Hans

> Or do you have any other thing in mind?
> 
> Thanks
> Helen
> 
