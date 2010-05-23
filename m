Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4157 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0EWMF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 08:05:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: asheeshb@ti.com
Subject: Re: [PATCH 1/7] changed driver for MMAP buffer
Date: Sun, 23 May 2010 14:07:44 +0200
Cc: linux-media@vger.kernel.org
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com> <1274287478-14661-2-git-send-email-asheeshb@ti.com>
In-Reply-To: <1274287478-14661-2-git-send-email-asheeshb@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231407.44283.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 19 May 2010 18:44:32 asheeshb@ti.com wrote:
> From: Asheesh Bhardwaj <asheeshb@ti.com>
> 
> ---
>  drivers/media/video/davinci/vpif_display.c |   59 ++++++++++++++++++++++++++++
>  drivers/media/video/davinci/vpif_display.h |    1 +
>  2 files changed, 60 insertions(+), 0 deletions(-)

Hi Asheesh,

This is a general comment for this patch series: I think these drivers are
in need of some comments in the code describing these buffer module options
and how to use them.

Or perhaps instead of comments there should be a document in the
Documentation/video4linux directory. Although comments have the advantage of
being more likely to be kept up to date.

You should also run checkpatch.pl over your patches: I saw several coding style
violations.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
