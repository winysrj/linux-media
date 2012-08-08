Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:6805 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2HHJqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 05:46:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Date: Wed, 8 Aug 2012 11:46:50 +0200
Cc: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com> <201208020835.58332.hverkuil@xs4all.nl> <20120808093538.GF29636@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120808093538.GF29636@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208081146.50880.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 8 August 2012 11:35:38 Sakari Ailus wrote:
> Hi Hans and Rémi,
> 
> On Thu, Aug 02, 2012 at 08:35:58AM +0200, Hans Verkuil wrote:
> ...
> > Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2 core.
> 
> As far as I understand, V4L1 did have that limitation, as well as videobuf1
> and 2 and a number of other drivers, but it's not found in the V4L2 core
> itself. While I'm not aware of a driver that'd allow creating more buffers
> than that the changes required to support more would be likely limited to
> videobuf2.

You are correct. It does not touch the v4l2 core, just videobuf and videobuf2.
Although the define is in videodev2.h as well, so it's something that apps
might use as well. But frankly, 32 is a very generous maximum anyway.

Only in special cases can I imagine needing more buffers (frame slicing,
high-speed capture).

Regards,

	Hans
