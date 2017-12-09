Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37377 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751015AbdLIImP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Dec 2017 03:42:15 -0500
Subject: Re: What to do with input_enable_softrepeat in av7110_ir.c
To: "Jasmin J." <jasmin@anw.at>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <8b989e65-a514-ad29-0210-23a7973bbafd@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <03964141-14cd-c24f-74ea-296553936409@xs4all.nl>
Date: Sat, 9 Dec 2017 09:42:10 +0100
MIME-Version: 1.0
In-Reply-To: <8b989e65-a514-ad29-0210-23a7973bbafd@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2017 01:12 AM, Jasmin J. wrote:
> Hello Hans!
> 
> I try to fix the compilation for Kernel 3.13 (the kernel I use on my VDR).
> 
> In commit 5aeaa3e668de0782d1502f3d5751e2266a251d7c the timer handling in
> the driver has been changed and now it uses "input_enable_softrepeat". This
> function has been added with Kernel 4.4.
> 
> I tried to define "input_enable_softrepeat" in "v4l/compat.h", but it requires
> "input_repeat_key", which is a static function in "input.c".
> 
> I see this solutions:
> 1) Revert commit 5aeaa3e668de0782d1502f3d5751e2266a251d7c with a new patch for
>    Kernels older than 4.4.
> 2) Disable the  CONFIG_DVB_AV7110_IR, but this driver is available since
>    2008. So there might be a lot of people unhappy.
> 3) Hans looks into this and has another clever idea how to solve that.
> 
> I prefer 1) for a quick solution.
> 
> BR,
>    Jasmin
> 

I tried 2, that didn't work, then picked 1 and now it compiles.

Pushed all my changes. At least it now compiles from 4.1 onwards. Haven't tested
older builds.

Regards,

	Hans
