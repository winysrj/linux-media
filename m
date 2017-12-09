Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41376 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751008AbdLIIAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Dec 2017 03:00:23 -0500
Subject: Re: [PATCH] build: Added missing timer_setup_on_stack
To: "Jasmin J." <jasmin@anw.at>,
        Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org, d.scheller@gmx.net
References: <1512766859-7667-1-git-send-email-jasmin@anw.at>
 <3343c1fd-d0f0-46b1-fd3f-150f36de6fa4@anw.at>
 <21ccbddb-eada-fa44-93ea-f0b80e17d409@xs4all.nl>
 <20171208231606.GA5540@shambles.windy>
 <d3854754-84be-3bb8-6726-f5f351e7c142@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a1d85347-5f6f-4a64-7f0c-1fc6f10e4c39@xs4all.nl>
Date: Sat, 9 Dec 2017 09:00:18 +0100
MIME-Version: 1.0
In-Reply-To: <d3854754-84be-3bb8-6726-f5f351e7c142@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I misapplied a pr_fmt patch. It's now fixed.

	Hans

On 12/09/2017 12:29 AM, Jasmin J. wrote:
> Hello Vincent!
> 
>> Not quite there yet however.
> I always test with several Kernel headers ...
> 
>> patch -s -f -N -p1 -i ../backports/api_version.patch
>> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
>> 1 out of 1 hunk FAILED
> I have tested the patches on Linux Mint 18.1 (Kernel 4.4.0-62-generic):
> Applying patches for kernel 4.4.0-62-generic
> patch -f -N -p1 -i ../backports/api_version.patch
> checking file drivers/media/cec/cec-api.c
> Hunk #1 succeeded at 95 (offset 2 lines).
> checking file drivers/media/v4l2-core/v4l2-ioctl.c
> Hunk #1 succeeded at 1004 (offset 4 lines).
> checking file drivers/media/media-device.c
> patching file drivers/media/cec/cec-api.c
> Hunk #1 succeeded at 95 (offset 2 lines).
> patching file drivers/media/v4l2-core/v4l2-ioctl.c
> Hunk #1 succeeded at 1004 (offset 4 lines).
> patching file drivers/media/media-device.c
> patch -f -N -p1 -i ../backports/pr_fmt.patch
> checking file drivers/media/common/saa7146/saa7146_core.c
> checking file drivers/media/common/saa7146/saa7146_fops.c
> checking file drivers/media/common/saa7146/saa7146_hlp.c
> checking file drivers/media/common/saa7146/saa7146_i2c.c
> checking file drivers/media/common/saa7146/saa7146_video.c
> checking file drivers/media/common/siano/smscoreapi.h
> 
> Apply this patch, so we can see on which file it stops:
> diff --git a/linux/Makefile b/linux/Makefile
> index ce39f82..5fc5150 100644
> --- a/linux/Makefile
> +++ b/linux/Makefile
> @@ -147,9 +147,9 @@ apply_patches apply-patches:
>         touch .patches_applied; \
>         rm -f mm/frame_vector.c; \
>         for i in $$PATCHES; do \
> -               echo patch -s -f -N -p1 -i ../backports/$$i; \
> -               patch -s -f -N -p1 -i ../backports/$$i --dry-run || exit 1; \
> -               patch -s -f -N -p1 -i ../backports/$$i; \
> +               echo patch -f -N -p1 -i ../backports/$$i; \
> +               patch -f -N -p1 -i ../backports/$$i --dry-run || exit 1; \
> +               patch -f -N -p1 -i ../backports/$$i; \
>                 mv .patches_applied .patches_applied.old; \
>                 echo $$i > .patches_applied; \
>                 cat .patches_applied.old >> .patches_applied; \
> @@ -165,8 +165,8 @@ unapply_patches unapply-patches:
>         @if [ -e .patches_applied ]; then \
>         echo "Unapplying patches"; \
>         for i in `cat .patches_applied|grep -v '^#'`; do \
> -               echo patch -s -f -R -p1 -i ../backports/$$i; \
> -               patch -s -f -R -p1 -i ../backports/$$i || break; \
> +               echo patch -f -R -p1 -i ../backports/$$i; \
> +               patch -f -R -p1 -i ../backports/$$i || break; \
>         done; \
>         rm -f mm/frame_vector.c; \
>         rm -f .patches_applied; fi
> 
> 
> BR,
>    Jasmin
> 
