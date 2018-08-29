Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:37596 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727428AbeH2Pyy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 11:54:54 -0400
Received: by mail-oi0-f42.google.com with SMTP id p84-v6so8618671oic.4
        for <linux-media@vger.kernel.org>; Wed, 29 Aug 2018 04:58:20 -0700 (PDT)
Subject: Re: Question regarding optimizing pipeline in Vimc
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Guilherme Alcarde Gallo <gagallo7@gmail.com>,
        =?UTF-8?Q?Lucas_Magalh=c3=a3es?= <lucmaga@gmail.com>
References: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
 <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
From: Helen Koike <helen@koikeco.de>
Message-ID: <f37b690f-68bd-178b-a282-30106d6a2e69@koikeco.de>
Date: Wed, 29 Aug 2018 08:58:17 -0300
MIME-Version: 1.0
In-Reply-To: <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 8/22/18 3:49 AM, Hans Verkuil wrote:
> On 08/22/2018 05:35 AM, Helen Koike wrote:
>> Hello,
>>
>> One of the discussions we had when developing Vimc, was regarding
>> optimizing image generation.
>> The ideia was to generate the images directly in the capture instead
>> of propagating through the pipeline (to make things faster).
>> But my question is: if this optimization is on, and if there is a
>> greyscaler filter in the middle of the pipeline, do you expect to see
>> a grey image with this optimization?
> 
> Yes.
> 
>> Or if we just generate a dummy
>> image (with the right size format) at the end of the pipeline, would
>> it be ok? (I am asking because it doesn't sound that simple to
>> propagate the image transformation made by each entity in the pipe)
> 
> No, that would not be OK.
> 
> My basic idea was that you use a TPG state structure that contains the
> desired output: the sensor starts with e.g. 720p using some bayer pixelformat,
> the debayer module replaces the pixelformat with e.g. PIX_FMT_RGB32, a
> grayscale filter replaces it with PI_FMT_GREY, and that's what the TPG for the
> video device eventually will use to generate the video.
> 
> This assumes of course that all the vimc blocks only do operations that can
> be handled by the TPG. Depending on what the blocks will do the TPG might need
> to be extended if a feature is missing.
> 
> Regards,
> 
> 	Hans
> 
>> Or do you have any other thing in mind?
>>
>> Thanks
>> Helen
>>
> 

Thanks Hans,

We'll be working on that soon.

Helen
