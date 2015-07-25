Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38798 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755034AbbGYWO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2015 18:14:29 -0400
Date: Sun, 26 Jul 2015 01:13:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/7] v4l2-fh: v4l2_fh_add/del now return whether it
 was the first or last fh.
Message-ID: <20150725221358.GG12092@valkosipuli.retiisi.org.uk>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
 <1437733296-38198-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437733296-38198-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 24, 2015 at 12:21:31PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Simplify driver code by letting v4l2_fh_add/del return true if the
> filehandle was the first open or the last close.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
