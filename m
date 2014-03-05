Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:52341 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaCETvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:51:17 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1Z00EGCB6MV860@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Mar 2014 14:51:58 -0500 (EST)
Date: Wed, 05 Mar 2014 16:51:12 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.15] DocBook build fix
Message-id: <20140305165112.2d32f6cd@samsung.com>
In-reply-to: <20140302154024.GM15635@valkosipuli.retiisi.org.uk>
References: <20140302154024.GM15635@valkosipuli.retiisi.org.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Sun, 2 Mar 2014 17:40:24 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's a trivial fix for the DocBook build. Please pull.
> 
> The following changes since commit a06b429df49bb50ec1e671123a45147a1d1a6186:
> 
>   [media] au0828: rework GPIO management for HVR-950q (2014-02-28 15:21:31 -0300)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git v4l2-doc-fix
> 
> for you to fetch changes up to 8a7beb0cc41415f50c13bedc4dc13a4a49895839:
> 
>   v4l: Trivial documentation fix (2014-03-02 17:23:36 +0200)
> 
> ----------------------------------------------------------------
> Sakari Ailus (1):
>       v4l: Trivial documentation fix

Thanks for the patch. Unfortunately, I ended by writing the very same
fix before applying from this tree, as I noticed the DocBook compilation
breakage while merging some other docbook patch.

Regards,
Mauro

> 
>  Documentation/DocBook/media/v4l/controls.xml |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


-- 

Cheers,
Mauro
