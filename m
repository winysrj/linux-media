Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab1IRSFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 14:05:49 -0400
Message-ID: <4E7632F6.204@redhat.com>
Date: Sun, 18 Sep 2011 15:05:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: mats.randgaard@tandberg.com
CC: linux-media@vger.kernel.org, sudhakar.raj@ti.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/2] Patches for TVP7002
References: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
In-Reply-To: <1280823484-21664-1-git-send-email-mats.randgaard@tandberg.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2010 05:18, mats.randgaard@tandberg.com escreveu:
> From: Mats Randgaard <mats.randgaard@tandberg.com>
> 
> The patch "TVP7002: Changed register values" depends on http://www.mail-archive.com/linux-media@vger.kernel.org/msg20769.html

Hmm... those patches still apply over the latest development tree.
I didn't saw any comments about it. Are they still applicable?

> 
> Mats Randgaard (2):
>   TVP7002: Return V4L2_DV_INVALID if any of the errors occur.
>   TVP7002: Changed register values.
> 
>  drivers/media/video/tvp7002.c |   14 ++++----------
>  1 files changed, 4 insertions(+), 10 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

