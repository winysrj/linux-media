Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46520 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761005AbaGRJYg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 05:24:36 -0400
Date: Fri, 18 Jul 2014 12:24:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] v4l2-ctrls: fix compiler warning
Message-ID: <20140718092402.GP16460@valkosipuli.retiisi.org.uk>
References: <53C7D43B.20905@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7D43B.20905@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 17, 2014 at 03:48:43PM +0200, Hans Verkuil wrote:
> Fixed a compiler warning in v4l_print_query_ext_ctrl() due to the change from
> dims[8] to dims[4].
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For both:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
