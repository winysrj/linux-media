Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60991 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726990AbeHaOE3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 10:04:29 -0400
Subject: Re: Question regarding optimizing pipeline in Vimc
To: =?UTF-8?Q?Lucas_Magalh=c3=a3es?= <lucmaga@gmail.com>
Cc: Helen Koike <helen@koikeco.de>, linux-media@vger.kernel.org,
        gagallo7@gmail.com
References: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
 <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
 <CAK0xOaHQ-xBWc6L=M_mZV5OcsRBL5qq2n8Tq5hNWLdPoMxubwA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <80cbe2b3-c8aa-e0d5-90ee-d826f4cebfa3@xs4all.nl>
Date: Fri, 31 Aug 2018 11:57:44 +0200
MIME-Version: 1.0
In-Reply-To: <CAK0xOaHQ-xBWc6L=M_mZV5OcsRBL5qq2n8Tq5hNWLdPoMxubwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2018 01:37 AM, Lucas Magalhães wrote:
> On Wed, Aug 22, 2018 at 3:49 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> My basic idea was that you use a TPG state structure that contains the
>> desired output: the sensor starts with e.g. 720p using some bayer pixelformat,
>> the debayer module replaces the pixelformat with e.g. PIX_FMT_RGB32, a
>> grayscale filter replaces it with PI_FMT_GREY, and that's what the TPG for the
>> video device eventually will use to generate the video.
>>
>> This assumes of course that all the vimc blocks only do operations that can
>> be handled by the TPG. Depending on what the blocks will do the TPG might need
>> to be extended if a feature is missing.
>>
> Hi Hans,
> 
> I start to work on this task but I have another question. I understand that the
> final image should have the correct format as if the frame was passing through
> the whole topology. But the operations itself doesn't needed to be done on each
> entity. For example, a scaled image will have deformations that will not be
> present if it is generated on the end of the pipeline with the final size.
> You just need the format, size and properties to be correct, do I got it right?

Yes. Although this example is unfortunate since the TPG can actually scale:
with tpg_reset_source you define the width/height of the 'source', and with
tpg_s_crop_compose you can define the crop and compose rectangles, which in
turn translates to scaling. The TPG has a poor man's scaler, so if you scale
up by a factor of 2, you will in fact see those deformations.

But if you have a complex pipeline with e.g. two scalers with additional
processing in between, then that cannot be modeled accurately with the TPG.
So be it. There is a balance between accuracy and performance, and I think
this is a decent compromise.

Regards,

	Hans
