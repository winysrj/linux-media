Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2211 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2ERLv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 07:51:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [PATCH 0/2] media_build: fix compilation on old kernels (<2.6.34)
Date: Fri, 18 May 2012 13:51:18 +0200
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
References: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205181351.18371.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed May 16 2012 12:44:08 Gianluca Gennari wrote:
> This patches fix compilation of the media_build tree on kernels older than 2.6.34.
> 
> Tested on kernel 2.6.32 (Ubuntu 10.04).

Applied the patches, thanks!

Regards,

	Hans

> 
> Gianluca Gennari (2):
>   media_build: add SET_SYSTEM_SLEEP_PM_OPS definition to compat.h
>   media_build: disable VIDEO_SMIAPP driver on kernels older than 2.6.34
> 
>  v4l/compat.h                      |   14 ++++++++++++++
>  v4l/scripts/make_config_compat.pl |    1 +
>  v4l/versions.txt                  |    2 ++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
