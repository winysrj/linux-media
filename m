Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47796 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbeGYOZ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:25:59 -0400
Date: Wed, 25 Jul 2018 16:14:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media.h: remove linux/version.h include
Message-ID: <20180725131419.csrytmdjmwewtqnm@valkosipuli.retiisi.org.uk>
References: <7f418498-14ae-c127-61a6-31071e042631@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f418498-14ae-c127-61a6-31071e042631@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 25, 2018 at 02:51:39PM +0200, Hans Verkuil wrote:
> The media.h public header is one of only three public headers that include
> linux/version.h. Drop it from media.h. It was only used for an obsolete
> define.
> 
> It has to be added to media-device.c, since that source relied on media.h
> to include it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
