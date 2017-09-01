Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45815 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751237AbdIAIkB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 04:40:01 -0400
Subject: Re: [PATCH V2 0/1] build: gpio-ir-tx for 3.13
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
References: <1503830124-3634-1-git-send-email-jasmin@anw.at>
Cc: d.scheller@gmx.net, sean@mess.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <80e63ffe-3537-c2bf-bd85-fb120bd464b0@xs4all.nl>
Date: Fri, 1 Sep 2017 10:39:58 +0200
MIME-Version: 1.0
In-Reply-To: <1503830124-3634-1-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/08/17 12:35, Jasmin J. wrote:
> From: Jasmin Jessich <jasmin@anw.at>
> 
> Changes to V1:
>  Moved IR_GPIO_TX from 4.10.0 to 3.13.0 instead of adding it.
> 
> Kernel 3.17 introduces GPIOD_OUT_LOW/HIGH. gpio-ir-tx requires this
> definitions. This patch adds the API calls prior to 3.17 to be used
> by gpio-ir-tx.
> With that gpio-ir-tx can be compiled back to Kernel 3.13.
> I tested the compilation (not the functionality!) on 4.4, 3.13 and
> 3.4.
> 
> @Sean: Please check if the code in v3.16_gpio-ir-tx.patch looks
> feasible for you (can't test this here). If not, we will drop this
> patch and simply disable gpio-ir-tx for Kernels older than 3.17.

I moved gpio-ir-tx to 3.17. Is there a really urgent need to compile
it for older kernels?

The problem is that you have to maintain that backports patch as well.
So I kept it simple.

Regards,

	Hans

> 
> Jasmin Jessich (1):
>   build: gpio-ir-tx backport
> 
>  backports/backports.txt          |  1 +
>  backports/v3.16_gpio-ir-tx.patch | 25 +++++++++++++++++++++++++
>  v4l/versions.txt                 |  2 +-
>  3 files changed, 27 insertions(+), 1 deletion(-)
>  create mode 100644 backports/v3.16_gpio-ir-tx.patch
> 
