Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60469 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759976Ab2COMtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 08:49:52 -0400
Message-ID: <4F61E569.4080708@iki.fi>
Date: Thu, 15 Mar 2012 14:49:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.3] media fixes
References: <4F61CA9D.309@redhat.com>
In-Reply-To: <4F61CA9D.309@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Mauro,
Just for the sure, since it is last days of RC phase, that bugfix must 
be send for the Kernel 3.3 too:
http://patchwork.linuxtv.org/patch/10313/

regards
Antti

On 15.03.2012 12:55, Mauro Carvalho Chehab wrote:
> Hi Linus,
>
> Please pull from:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For 4 fixes for 3.3 (all trivial):
> 	- uvc video driver: fixes a division by zero;
> 	- davinci: add module.h to fix compilation;
> 	- smsusb: fix the delivery system setting;
> 	- smsdvb: the get_frontend implementation there is broken.
>
> The smsdvb patch has 127 lines, but it is trivial: instead of returning
> a cache of the set_frontend (with is wrong, as it doesn't have the
> updated values for the data, and the implementation there is buggy),
> it copies the information of the detected DVB parameters from the
> smsdvb private structures into the corresponding DVBv5 struct fields.
>
> Thanks!
> Mauro
>
> -
>
> Latest commit at the branch:
> d138210ffa90e6c78e3f7a2c348f50e865ff735c [media] smsdvb: fix get_frontend
> The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:
>
>    Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)
>
> are available in the git repository at:
>    git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> Gianluca Gennari (1):
>        [media] smsdvb: fix get_frontend
>
> Henrique Camargo (1):
>        [media] media: davinci: added module.h to resolve unresolved macros
>
> Laurent Pinchart (1):
>        [media] [FOR,v3.3] uvcvideo: Avoid division by 0 in timestamp calculation
>
> Mauro Carvalho Chehab (1):
>        [media] smsusb: fix the default delivery system setting
>
>   drivers/media/dvb/siano/smsdvb.c    |  127 ++++++++++++++++++++++++++++++++---
>   drivers/media/video/davinci/isif.c  |    1 +
>   drivers/media/video/uvc/uvc_video.c |   14 +++--
>   3 files changed, 128 insertions(+), 14 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
