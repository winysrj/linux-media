Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49383 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752352Ab3FEXwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 19:52:15 -0400
Date: Thu, 6 Jun 2013 02:52:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.10] v4l2-ioctl: don't print the clips list.
Message-ID: <20130605235210.GA2675@valkosipuli.retiisi.org.uk>
References: <201305311314.59873.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305311314.59873.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 31, 2013 at 01:14:59PM +0200, Hans Verkuil wrote:
> The clips pointer is a userspace pointer, not a kernelspace pointer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
