Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:43796 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751120AbbEQU0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2015 16:26:13 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave03.hostedemail.com (Postfix) with ESMTP id 59F0228D90D
	for <linux-media@vger.kernel.org>; Sun, 17 May 2015 20:16:56 +0000 (UTC)
Message-ID: <1431893812.15709.89.camel@perches.com>
Subject: Re: [PATCH] Clarify expression which uses both multiplication and
 pointer dereference
From: Joe Perches <joe@perches.com>
To: Alex Dowad <alexinbeijing@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	"open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Date: Sun, 17 May 2015 13:16:52 -0700
In-Reply-To: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
References: <1431883124-4937-1-git-send-email-alexinbeijing@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2015-05-17 at 19:18 +0200, Alex Dowad wrote:
> This fixes a checkpatch style error in vpfe_buffer_queue_setup.

There is no checkpatch message for this style.

Nor should there be.

> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
[]
> @@ -1095,7 +1095,7 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> -		while (size * *nbuffers > vpfe_dev->video_limit)
> +		while (size * (*nbuffers) > vpfe_dev->video_limit)


