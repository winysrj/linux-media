Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947421Ab3BIAdu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Feb 2013 19:33:50 -0500
Date: Fri, 8 Feb 2013 22:33:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PULL FOR v3.8] Regression fix: cx18/ivtv: remove __init
 from a non-init function.
Message-ID: <20130208223344.38009a5c@redhat.com>
In-Reply-To: <201302080940.27735.hverkuil@xs4all.nl>
References: <201302080940.27735.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Feb 2013 09:40:27 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Mauro,
> 
> Please fast-track this for 3.8. Yesterday I discovered that commits made earlier
> for 3.8 kill ivtv and cx18 (as in: unable to boot, instant crash) since a
> function was made __init that was actually called *after* initialization.
> 
> We are already at rc6 and this *must* make it for 3.8. Without this patch
> anyone with a cx18/ivtv will crash immediately as soon as they upgrade to 3.8.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 248ac368ce4b3cd36515122d888403909d7a2500:
> 
>   [media] s5p-fimc: Fix fimc-lite entities deregistration (2013-02-06 09:42:19 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git ivtv
> 
> for you to fetch changes up to ddf276062e68607323fca363b99bdf426dddad9b:
> 
>   cx18/ivtv: fix regression: remove __init from a non-init function. (2013-02-08 09:30:11 +0100)
> 
> ----------------------------------------------------------------
> Hans Verkuil (1):
>       cx18/ivtv: fix regression: remove __init from a non-init function.

Hmm... the patch seems to be broken/incomplete:


WARNING: drivers/media/pci/cx18/cx18-alsa.o(.text+0x449): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_pcm_create()
The function cx18_alsa_load() references
the function __init snd_cx18_pcm_create().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_pcm_create is wrong.

WARNING: drivers/media/pci/cx18/built-in.o(.text+0x1be69): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_pcm_create()
The function cx18_alsa_load() references
the function __init snd_cx18_pcm_create().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_pcm_create is wrong.

WARNING: drivers/media/pci/ivtv/ivtv-alsa.o(.text+0x454): Section mismatch in reference from the function ivtv_alsa_load() to the function .init.text:snd_ivtv_pcm_create()
The function ivtv_alsa_load() references
the function __init snd_ivtv_pcm_create().
This is often because ivtv_alsa_load lacks a __init 
annotation or the annotation of snd_ivtv_pcm_create is wrong.

WARNING: drivers/media/pci/ivtv/built-in.o(.text+0x20790): Section mismatch in reference from the function ivtv_alsa_load() to the function .init.text:snd_ivtv_pcm_create()
The function ivtv_alsa_load() references
the function __init snd_ivtv_pcm_create().
This is often because ivtv_alsa_load lacks a __init 
annotation or the annotation of snd_ivtv_pcm_create is wrong.

WARNING: drivers/media/pci/built-in.o(.text+0x6b958): Section mismatch in reference from the function ivtv_alsa_load() to the function .init.text:snd_ivtv_pcm_create()
The function ivtv_alsa_load() references
the function __init snd_ivtv_pcm_create().
This is often because ivtv_alsa_load lacks a __init 
annotation or the annotation of snd_ivtv_pcm_create is wrong.

WARNING: drivers/media/pci/built-in.o(.text+0x9fc21): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_pcm_create()
The function cx18_alsa_load() references
the function __init snd_cx18_pcm_create().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_pcm_create is wrong.

WARNING: drivers/media/built-in.o(.text+0x289f48): Section mismatch in reference from the function ivtv_alsa_load() to the function .init.text:snd_ivtv_pcm_create()
The function ivtv_alsa_load() references
the function __init snd_ivtv_pcm_create().
This is often because ivtv_alsa_load lacks a __init 
annotation or the annotation of snd_ivtv_pcm_create is wrong.

WARNING: drivers/media/built-in.o(.text+0x2be211): Section mismatch in reference from the function cx18_alsa_load() to the function .init.text:snd_cx18_pcm_create()
The function cx18_alsa_load() references
the function __init snd_cx18_pcm_create().
This is often because cx18_alsa_load lacks a __init 
annotation or the annotation of snd_cx18_pcm_create is wrong.
-- 

Cheers,
Mauro
