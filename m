Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41265 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932406AbcIFKm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:42:29 -0400
Subject: Re: Build fails
To: timo.helkio@kapsi.fi, linux-media@vger.kernel.org
References: <7f64a902-3436-e21c-653d-5dff2c1115a2@kapsi.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4d834cab-e834-1a20-f9cf-d03c7ed4bb31@xs4all.nl>
Date: Tue, 6 Sep 2016 12:42:22 +0200
MIME-Version: 1.0
In-Reply-To: <7f64a902-3436-e21c-653d-5dff2c1115a2@kapsi.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/16 12:21, Timo Helkiö wrote:
> make -C /omat/media_build/v4l allyesconfig
> make[1]: Entering directory '/omat/media_build/v4l'
> No version yet, using 4.4.0-36-generic
> make[2]: Entering directory '/omat/media_build/linux'
> Syncing with dir ../media/
> Applying patches for kernel 4.4.0-36-generic
> patch -s -f -N -p1 -i ../backports/api_version.patch
> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
> patch -s -f -N -p1 -i ../backports/debug.patch
> patch -s -f -N -p1 -i ../backports/drx39xxj.patch
> patch -s -f -N -p1 -i ../backports/v4.7_dma_attrs.patch
> patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
> 1 out of 2 hunks FAILED
> Makefile:138: recipe for target 'apply_patches' failed
> make[2]: *** [apply_patches] Error 1
> make[2]: Leaving directory '/omat/media_build/linux'
> Makefile:369: recipe for target 'allyesconfig' failed
> make[1]: *** [allyesconfig] Error 2
> make[1]: Leaving directory '/omat/media_build/v4l'
> Makefile:26: recipe for target 'allyesconfig' failed
> make: *** [allyesconfig] Error 2
> can't select all drivers at ./build line 490.

Fixed 15 minutes ago in the media_build repo!

	Hans

>
>
>          Timo Helkiö
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
