Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49729 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2FKLXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 07:23:05 -0400
Received: by bkcji2 with SMTP id ji2so3409760bkc.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jun 2012 04:23:03 -0700 (PDT)
Message-ID: <4FD5D514.20306@gmail.com>
Date: Mon, 11 Jun 2012 13:23:00 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/4] V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
 V4L2_SEL_TGT_[CROP/COMPOSE]
References: <4FD4F6B6.1070605@iki.fi> <1339356878-2179-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1339356878-2179-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for working on this.

On 06/10/2012 09:34 PM, Sakari Ailus wrote:
> From: Sylwester Nawrocki<s.nawrocki@samsung.com>
> 
> This patch drops the _ACTIVE part from the selection target names as
> a prerequisite to unify the selection target names on subdevs and regular
> video nodes.

There is a newer version of this patch, that I made after comments 
from Mauro: http://patchwork.linuxtv.org/patch/11357. Could you use 
this one instead ?

--
Regards, 
Sylwester
