Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48447 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1LVNKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 08:10:19 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
Subject: RE: [PATCH v7 1/8] davinci: vpif: remove machine specific inclusion
 from driver
Date: Thu, 22 Dec 2011 13:10:01 +0000
Message-ID: <DF0F476B391FA8409C78302C7BA518B6053133@DBDE01.ent.ti.com>
References: <1324475021-32509-1-git-send-email-manjunath.hadli@ti.com>
 <1324475021-32509-2-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1324475021-32509-2-git-send-email-manjunath.hadli@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Wed, Dec 21, 2011 at 19:13:34, Hadli, Manjunath wrote:
> remove machine specific inclusion from the driver which
> comes in the way of platform code consolidation.

I think it would be more readable to use the term "header file"
here and in the headline. Just "machine specific inclusion"
begs the question - "inclusion of what?"

> currently was seen that these header inclusions were
> not necessary.

Sorry about nit-picking, but it is not good to talk in
past tense in commit text. Past tense is natural for you
to use since you write the text after making the changes,
but for the reviewer it is not natural since he is seeing
the commit text and the patch both at once. Also, usage
of "currently" in above line is not necessary. It is assumed
that commit text talks about current state of affairs.

I would have made these changes myself after Mauro's ack,
but..

> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: LMML <linux-media@vger.kernel.org>
> ---
>  drivers/media/video/davinci/vpif.h         |    2 --
>  drivers/media/video/davinci/vpif_display.c |    2 --
>  include/media/davinci/vpif_types.h         |    2 ++
>  sound/soc/codecs/cq93vc.c                  |    2 --

.. you clubbed this unrelated sound/soc/ change in this patch.
First, the change is not related to VPIF in any way so it
has no business being in this patch. Second, there is no way
the sound/soc folks will have a look at this patch, so basically
the change will end up bypassing the right maintainers if other
reviewers fail to catch it.

Please separate the change into another patch. You can just
post the two patches alone copying the right maintainers
in each instead of posting the entire series again.

Thanks,
Sekhar

