Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45348
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbcF1LfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:35:04 -0400
Date: Tue, 28 Jun 2016 08:34:58 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v4.8] Various fixes
Message-ID: <20160628083458.5a3b7975@recife.lan>
In-Reply-To: <74472839-8078-c8e4-5d92-43557fdb3f6e@xs4all.nl>
References: <74472839-8078-c8e4-5d92-43557fdb3f6e@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Jun 2016 14:31:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Note for Ulrich's patches: these are prerequisites for two other patch
> series (one from Ulrich for HDMI support and one from Niklas for Gen3
> support). It doesn't hurt to add these now, and it will simplify future
> development.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:
> 
>   [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v4.8c
> 
> for you to fetch changes up to ad124b474f36aa0581ca46a5f609e7d8c7e0a5a6:
> 
>   media: rcar-vin: add DV timings support (2016-06-27 11:34:52 +0200)
> 
> ----------------------------------------------------------------
> Alexey Khoroshilov (1):
>       radio-maxiradio: fix memory leak when device is removed
> 
> Hans Verkuil (1):
>       v4l2-ctrl.h: fix comments
> 
> Helen Fornazier (1):
>       stk1160: Check *nplanes in queue_setup
> 
> Ismael Luceno (1):
>       solo6x10: Simplify solo_enum_ext_input
> 


> Ulrich Hecht (3):
>       media: rcar_vin: Use correct pad number in try_fmt
>       media: rcar-vin: pad-aware driver initialisation
>       media: rcar-vin: add DV timings support

I'm not applying those three patches. The first one broke compilation.
Clearly, they weren't tested.

Please re-submit those three patches after fixing and testing them.

Regard

Thanks,
Mauro
