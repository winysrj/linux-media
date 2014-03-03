Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50457 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753535AbaCCHTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 02:19:39 -0500
Date: Mon, 3 Mar 2014 09:19:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 13/17] vb2: replace BUG by WARN_ON
Message-ID: <20140303071906.GP15635@valkosipuli.retiisi.org.uk>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
 <1393609335-12081-14-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609335-12081-14-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 28, 2014 at 06:42:11PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> No need to oops for this, WARN_ON is good enough.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I agree; BUG() is better for something that's always (or almost so)
executed.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
