Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:47350 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754098AbeDPMOw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:14:52 -0400
Subject: Re: Smatch and sparse errors
To: "Jasmin J." <jasmin@anw.at>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: LMML <linux-media@vger.kernel.org>
References: <20180411122728.52e6fa9a@vento.lan>
 <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c969818-9036-6570-a2b3-5101ec13bbd3@xs4all.nl>
Date: Mon, 16 Apr 2018 14:14:47 +0200
MIME-Version: 1.0
In-Reply-To: <fc6e68a3-817b-8caf-ba4f-dd2ed76d2a52@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/14/2018 03:18 AM, Jasmin J. wrote:
> Hello Mauro/Hans!
> 
>> There is already an upstream patch for hidding it:
> The patch from https://patchwork.kernel.org/patch/10334353 will not
> apply at the smatch tree.
> 
> Attached is an updated version for smatch.
> 
> Even with the patched tools, sparse still complains:
>  CC      drivers/media/cec/cec-core.o
> /opt/media_test/media-git/include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:533:48: warning: constant 0xffffc90000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:624:29: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1098:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1795:27: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1887:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:151:25: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:236:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/dma-mapping.h:235:35: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/dma-mapping.h:238:33: warning: constant 0xffffea0000000000 is so big it is unsigned long
> 
>  CC      drivers/media/usb/gspca/gl860/gl860-mi2020.o
> /opt/media_test/media-git/include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:533:48: warning: constant 0xffffc90000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:624:29: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1098:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1795:27: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/mm.h:1887:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:151:25: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:236:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> /opt/media_test/media-git/include/linux/scatterlist.h:387:16: warning: constant 0xffffea0000000000 is so big it is unsigned long
> 
> But other warnings are gone with the patch.
> 
> The daily build is running on a machine of Hans. He need to update the
> tools there.
> 
> @Hans:
> Until this patches are in upstream, we need to patch smatch/sparse on the fly
> in build.sh after pulling the last tools version.

I've switched my sparse/smatch to Mauro's repositories for those utilities.

Let's see what happens tonight.

Regards,

	Hans
