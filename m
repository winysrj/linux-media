Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4014 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933AbZDMLUB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 07:20:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Chaithrika U S <chaithrika@ti.com>
Subject: Re: [PATCH v2 0/4] ARM: DaVinci: DM646x Video: DM646x display driver
Date: Mon, 13 Apr 2009 13:19:52 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>
References: <1239189476-19863-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1239189476-19863-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904131319.53148.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 08 April 2009 13:17:56 Chaithrika U S wrote:
> Display driver for TI DM646x EVM
>
> Signed-off-by: Manjunath Hadli <mrh@ti.com>
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
>
> These patches add the display driver support for TI DM646x EVM.
> This patch set has been tested for basic display functionality for
> Composite and Component outputs.
>
> In this version of the patches, the review comments got for the earlier
> version have been incorporated. The standard information(timings) has
> been moved to the display driver. The display driver has been modified
> accordingly. Also simplified the code by removing the redundant
> vpif_stdinfo data structure.
>
> Patch 1: Display device platform and board setup
> Patch 2: VPIF driver
> Patch 3: DM646x display driver
> Patch 4: Makefile and config files modifications for Display
>
> Some of the features like the HBI/VBI support are not yet implemented.
> Also there are some known issues in the code implementation like
> fine tuning to be done to TRY_FMT ioctl.The USERPTR usage has not been
> tested extensively.

Time permitting I'll review this during the weekend. During a very 
superficial scan I saw a few things that could be improved, but I think it 
only needs one more cycle before it can be merged. It looks much, much 
better now!

Regards,

	Hans

>
> -Chaithrika
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
