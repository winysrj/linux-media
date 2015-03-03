Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49765 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756661AbbCCWTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 17:19:22 -0500
Date: Wed, 4 Mar 2015 00:19:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] vb2: check if vb2_fop_write/read is allowed
Message-ID: <20150303221919.GY6539@valkosipuli.retiisi.org.uk>
References: <54F599CF.90508@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54F599CF.90508@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 03, 2015 at 12:23:59PM +0100, Hans Verkuil wrote:
> Return -EINVAL if read() or write() is not supported by the queue. This
> makes it possible to provide both vb2_fop_read and vb2_fop_write in a
> struct v4l2_file_operations since the vb2_fop_* function will check if
> the file operation is allowed.
> 
> A similar check exists in __vb2_init_fileio() which is called from
> __vb2_perform_fileio(), but that check is only done if no file I/O is
> active. So the sequence of read() followed by write() would be allowed,
> which is obviously a bug.
> 
> In addition, vb2_fop_write/read should always return -EINVAL if the
> operation is not allowed, and by putting the check in the lower levels
> of the code it is possible that other error codes are returned (EBUSY
> or ERESTARTSYS).
> 
> All these issues are avoided by just doing a quick explicit check.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
