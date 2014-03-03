Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50403 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752339AbaCCHNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Mar 2014 02:13:01 -0500
Date: Mon, 3 Mar 2014 09:12:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 12/17] vb2: properly clean up PREPARED and
 QUEUED buffers
Message-ID: <20140303071222.GO15635@valkosipuli.retiisi.org.uk>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl>
 <1393609335-12081-13-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609335-12081-13-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 28, 2014 at 06:42:10PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If __reqbufs was called then existing buffers are freed. However, if that
> happens without ever having started STREAMON, but if buffers have been queued,
> then the buf_finish op is never called.
> 
> Add a call to __vb2_queue_cancel in __reqbufs so that these buffers are
> cleaned up there as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
