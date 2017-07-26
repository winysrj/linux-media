Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:42762 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750863AbdGZI50 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 04:57:26 -0400
Subject: Re: [PATCH V2 0/3] fix compile for kernel 3.13
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
Cc: d.scheller@gmx.net
References: <1500929617-13623-1-git-send-email-jasmin@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1506939c-3ca4-b539-5a2d-5315f1ba0d93@xs4all.nl>
Date: Wed, 26 Jul 2017 10:57:19 +0200
MIME-Version: 1.0
In-Reply-To: <1500929617-13623-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2017 10:53 PM, Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
> 
> Changes since V1:
> - CEC_PIN and VIDEO_OV5670 disabled for all kernels older 4.10.
> 
> This series fixed compilation errors for older kernels.
> I have tested it with Kernel 3.13 and Daniel with Kernel 4.12 and
> someone else with Kernel 4.4.
> 
> CEC_PIN and VIDEO_OV5670 is now disabled for all kernels older 4.10.
> 
> This series requires "Add compat code for skb_put_data" from Matthias
> Schwarzott to be applied first (see
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg116145.html )

Applied, much appreciated that you looked into this!

Regards.

	Hans

> 
> Daniel Scheller (2):
>    build: CEC_PIN and the VIDEO_OV5670 driver both require kernel 4.10 to compile
>    build: fix up build w/kernels <=4.12 by reverting 4.13 patches
> 
> Jasmin Jessich (1):
>    build: Add compat code for pm_runtime_get_if_in_use
> 
>   backports/backports.txt                            |  3 +
>   .../v4.12_revert_solo6x10_copykerneluser.patch     | 71 ++++++++++++++++++++++
>   v4l/compat.h                                       | 15 +++++
>   v4l/scripts/make_config_compat.pl                  |  1 +
>   v4l/versions.txt                                   |  6 ++
>   5 files changed, 96 insertions(+)
>   create mode 100644 backports/v4.12_revert_solo6x10_copykerneluser.patch
> 
