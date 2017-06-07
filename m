Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54519
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751433AbdFGWtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 18:49:43 -0400
Date: Wed, 7 Jun 2017 19:49:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>
Cc: rjkm@metzlerbros.de, linux-media@vger.kernel.org,
        max.kellermann@gmail.com, d.scheller@gmx.net
Subject: Re: [PATCH 0/7] Add block read/write to en50221 CAM functions
Message-ID: <20170607194934.00576613@vento.lan>
In-Reply-To: <a8d025a0-b090-7c58-bb25-aed32111c1de@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
        <20170607125747.63d057c2@vento.lan>
        <a8d025a0-b090-7c58-bb25-aed32111c1de@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 7 Jun 2017 21:18:14 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> Hello Mauro!
> 
> THX for looking into this!
> 
>  > Hmm... from what I understood, the original author for those patches
>  > is Ralph, right?  
> Yes. I re-formatted them into smaller pieces to be easier reviewed.
> The goal of this series is to make the Kernel version equal to the official
> DD version. But I wrote all of this already in the preamble of the series.

The problem with this series is that, while you're saying it at the
preamble, and the SOB on each patch seems to indicate it, the patches
themselves are tagging you as the author of the patch series, and not Ralph.
See the From: at the first line of each patch on it:

	https://patchwork.linuxtv.org/patch/41193/
	https://patchwork.linuxtv.org/patch/41194/
	https://patchwork.linuxtv.org/patch/41196/
	https://patchwork.linuxtv.org/patch/41197/
	...

It should be, instead:
	From: Ralph Metzler <km@metzlerbros.de>

For all patches he wrote (even if you later rebased or splitted
them).

Thanks,
Mauro
