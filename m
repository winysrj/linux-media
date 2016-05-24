Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34418 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751714AbcEXPIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:08:52 -0400
Date: Tue, 24 May 2016 18:08:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	David Binderman <linuxdev.baldrick@gmail.com>
Subject: Re: [PATCH for 4.7] v4l2-ioctl: fix stupid mistake in cropcap
 condition
Message-ID: <20160524150815.GE26360@valkosipuli.retiisi.org.uk>
References: <5742ED68.5020607@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5742ED68.5020607@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 23, 2016 at 01:45:44PM +0200, Hans Verkuil wrote:
> Fix duplicate tests in condition. The second test for vidioc_cropcap
> should have tested for vidioc_g_selection instead.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: David Binderman <linuxdev.baldrick@gmail.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
