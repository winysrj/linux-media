Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53707 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967795AbaLLN24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:28:56 -0500
Date: Fri, 12 Dec 2014 15:28:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, prabhakar.csengg@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
Message-ID: <20141212132824.GZ15559@valkosipuli.retiisi.org.uk>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl>
 <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 04, 2014 at 10:54:54AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Weird, this op isn't used at all. Seems to be orphaned code.
> Remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
