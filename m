Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46297 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbaDKJkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 05:40:11 -0400
Date: Fri, 11 Apr 2014 12:39:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, s.nawrocki@samsung.com
Subject: Re: [REVIEWv3 PATCH 00/13] vb2: various small fixes/improvements
Message-ID: <20140411093937.GA8753@valkosipuli.retiisi.org.uk>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 11, 2014 at 10:11:06AM +0200, Hans Verkuil wrote:
> This is the third version of this review patch series.
> The previous can be found here:
> 
> http://www.spinics.net/lists/linux-media/msg75428.html
> 
> Changes since v2:
> 
> - Updated v4l2-pci-skeleton.c as well in patch 01/13
> - Dropped patch 10/13 as it is not needed
> - Added comment to patch 06/13 as suggested by Pawel
> - Added patch 13/13: fix HDTV interlaced handling in v4l2-pci-skeleton.c

For patches 10--13,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
