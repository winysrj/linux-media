Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34268 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbeHaDl4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 23:41:56 -0400
Received: by mail-io0-f169.google.com with SMTP id c22-v6so9048290iob.1
        for <linux-media@vger.kernel.org>; Thu, 30 Aug 2018 16:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAPW4XYY0k_rjbhTNVOjUcm6cpOXRyoDYk81HV0honCgFF+Crig@mail.gmail.com>
 <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
In-Reply-To: <61e3a97c-3a71-77b8-e14e-90dccc64a2a9@xs4all.nl>
From: =?UTF-8?Q?Lucas_Magalh=C3=A3es?= <lucmaga@gmail.com>
Date: Thu, 30 Aug 2018 20:37:06 -0300
Message-ID: <CAK0xOaHQ-xBWc6L=M_mZV5OcsRBL5qq2n8Tq5hNWLdPoMxubwA@mail.gmail.com>
Subject: Re: Question regarding optimizing pipeline in Vimc
To: hverkuil@xs4all.nl
Cc: Helen Koike <helen@koikeco.de>, linux-media@vger.kernel.org,
        gagallo7@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 22, 2018 at 3:49 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
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
Hi Hans,

I start to work on this task but I have another question. I understand that the
final image should have the correct format as if the frame was passing through
the whole topology. But the operations itself doesn't needed to be done on each
entity. For example, a scaled image will have deformations that will not be
present if it is generated on the end of the pipeline with the final size.
You just need the format, size and properties to be correct, do I got it right?

Thanks Lucas.
