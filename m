Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53178 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab1I3MNg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:13:36 -0400
Date: Fri, 30 Sep 2011 14:13:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 2/7] V4L menu: move legacy drivers into their own
 submenu.
Message-ID: <20110930141329.1331bbcd@stein>
In-Reply-To: <eb58a802b520329b54aebfeb2a1400870d61b127.1317372990.git.hans.verkuil@cisco.com>
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
	<eb58a802b520329b54aebfeb2a1400870d61b127.1317372990.git.hans.verkuil@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 30 Hans Verkuil wrote:
> +menuconfig V4L_LEGACY_DRIVERS
> +	bool "V4L legacy devices"
> +	default n

default n is redundant.

> +	---help---
> +	  Say Y here to enable support for these legacy drivers. These drivers
> +	  are for old and obsure hardware (e.g. parallel port webcams, ISA
> +	  drivers, niche hardware).

Perhaps add sentences like these which are commonly seen in such
menuconfig variables:

	  This option alone does not add any kernel code.

	  If you say N, all options in this submenu will be skipped and disabled.

There are obviously several already existing menuconfigs in the video section
which do not have these sentences; so maybe don't add the above, or add it
separately across the board, or whatever.  I find these sentences helpful when
running "make oldconfig" or the likes.
-- 
Stefan Richter
-=====-==-== =--= ====-
http://arcgraph.de/sr/
