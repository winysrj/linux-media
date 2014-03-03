Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50258 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750987AbaCCG2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 01:28:11 -0500
Date: Mon, 3 Mar 2014 08:28:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 06/17] vb2: call buf_finish from __queue_cancel.
Message-ID: <20140303062805.GN15635@valkosipuli.retiisi.org.uk>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
 <1393609335-12081-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609335-12081-7-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 28, 2014 at 06:42:04PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If a queue was canceled, then the buf_finish op was never called for the
> pending buffers. So add this call to queue_cancel. Before calling buf_finish
> set the buffer state to PREPARED, which is the correct state. That way the
> states DONE and ERROR will only be seen in buf_finish if streaming is in
> progress.
> 
> Since buf_finish can now be called from non-streaming state we need to
> adapt the handful of drivers that actually need to know this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
