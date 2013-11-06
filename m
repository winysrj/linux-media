Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53748 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754524Ab3KFRew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Nov 2013 12:34:52 -0500
Date: Wed, 6 Nov 2013 19:34:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-fh: Include linux/fs.h for struct file definition
Message-ID: <20131106173449.GK24988@valkosipuli.retiisi.org.uk>
References: <1380837352-29950-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380837352-29950-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 03, 2013 at 11:55:52PM +0200, Laurent Pinchart wrote:
> v4l2-fh.h dereferences struct file, the structure must thus be defined.
> Pull in its definition by including linux/fs.h.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
