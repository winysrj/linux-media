Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1267 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932763AbeAHVFB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 Jan 2018 16:05:01 -0500
Date: Mon, 8 Jan 2018 23:04:57 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drivers/media/common/videobuf2: rename from videobuf
Message-ID: <20180108210457.v7xytriqwrkflfdf@kekkonen.localdomain>
References: <1e1c91db-d439-f750-0bd2-249082298342@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e1c91db-d439-f750-0bd2-249082298342@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 08, 2018 at 09:20:01PM +0100, Hans Verkuil wrote:
> This directory contains the videobuf2 framework, so name the
> directory accordingly.
> 
> The name 'videobuf' typically refers to the old and deprecated
> videobuf version 1 framework so that was confusing.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I'm not sure there's much real danger of confusing this with videobuf1;
nevertheless videobuf2 is the only recommended videobuf version anyway.

So,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
