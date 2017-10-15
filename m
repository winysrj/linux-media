Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:51076 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbdJOKml (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 06:42:41 -0400
Subject: Re: [PATCH] build: Fixed patches partly for Kernel 2.6.32
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1507938731-23816-1-git-send-email-jasmin@anw.at>
 <fd99fe5a-81a8-8c6b-20c7-7c4b277432fa@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8435b63d-bded-2a5b-ab94-c8d4369973c1@xs4all.nl>
Date: Sun, 15 Oct 2017 12:42:36 +0200
MIME-Version: 1.0
In-Reply-To: <fd99fe5a-81a8-8c6b-20c7-7c4b277432fa@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

On 10/14/2017 02:00 AM, Jasmin J. wrote:
> Hi!
> 
> I have fixed the patches for 2.6.32 partly.
> File rc-ir-raw.c is still missing, but I can't fix that.
> Moreover, when compiling for 2.6.32, I get errors from compat.h:
>    implicit declaration of function 'ktime_to_ms'
> So it seems this needs a fix in compat.h also.
> 
> I am sending this patch anyway, so that someone may continue.
> On the other hand the daily build is done back to Kernel 2.6.36, so it
> seems media_build is tested only down to this Kernel Version.

Do you need build support for kernels < 2.6.36?

I gave up supporting such old kernels 2 or 3 years ago.

I'm holding off on merging this patch and the 2.6.35 patch until I
have a better idea of why you want to support those kernels.

The other patches I just merged.

Regards,

	Hans
