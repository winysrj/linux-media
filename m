Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdJQAAn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 20:00:43 -0400
Date: Mon, 16 Oct 2017 17:00:40 -0700
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Leon Luo <leonl@leopardimaging.com>
Subject: Re: [GIT PULL for 4.15] More sensor driver patches
Message-ID: <20171016170040.3fbb9e9a@vela.lan>
In-Reply-To: <20171013222345.x33ft5s7qspolf3k@valkosipuli.retiisi.org.uk>
References: <20171013222345.x33ft5s7qspolf3k@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 14 Oct 2017 01:23:45 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> Here's the second set of sensor driver patches for 4.15.
> 
> Please pull.
> 
> 
> The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:
> 
>   Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-2
> 
> for you to fetch changes up to 5164fc93c2d8c2e9a2de1461bfba9d6b2911ce9e:
> 
>   imx274: V4l2 driver for Sony imx274 CMOS sensor (2017-10-14 01:06:10 +0300)
> 
> ----------------------------------------------------------------
> Leon Luo (2):
>       imx274: device tree binding file
>       imx274: V4l2 driver for Sony imx274 CMOS sensor

As checkpatch complained:

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#69: 
new file mode 100644

Who will maintain this driver?

Regards,
Mauro



Cheers,
Mauro
