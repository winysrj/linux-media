Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaG3OHr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 10:07:47 -0400
Message-ID: <53D8FC30.6050307@suse.de>
Date: Wed, 30 Jul 2014 16:07:44 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
MIME-Version: 1.0
To: Zhaowei Yuan <zhaowei.yuan@samsung.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, jtp.park@samsung.com
CC: linux-samsung-soc@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH] media: v4l2: make alloction alogthim more robust and
 flexible
References: <1406692532-31800-1-git-send-email-zhaowei.yuan@samsung.com>
In-Reply-To: <1406692532-31800-1-git-send-email-zhaowei.yuan@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

A few trivial typos:

s/alloction/allocation/

s/alogthim/algorithm/

Am 30.07.2014 05:55, schrieb Zhaowei Yuan:
> Current algothim relies on the fact that caller will align the

s/algothim/algorithm/

> size to PAGE_SIZE, otherwise order will be decreased to negative
> when remain size is less than PAGE_SIZE, it makes the function

s/remain/remaining/

> hard to be migrated.
> This patch sloves the hidden problem.

s/sloves/solves/

> 
> Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
