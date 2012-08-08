Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57530 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752556Ab2HHJfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 05:35:44 -0400
Date: Wed, 8 Aug 2012 12:35:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
Message-ID: <20120808093538.GF29636@valkosipuli.retiisi.org.uk>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
 <1390726.ZQ58TDe5fq@avalon>
 <201208012350.00207.remi@remlab.net>
 <201208020835.58332.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201208020835.58332.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Rémi,

On Thu, Aug 02, 2012 at 08:35:58AM +0200, Hans Verkuil wrote:
...
> Minimum or maximum? The maximum is 32, that's hardcoded in the V4L2 core.

As far as I understand, V4L1 did have that limitation, as well as videobuf1
and 2 and a number of other drivers, but it's not found in the V4L2 core
itself. While I'm not aware of a driver that'd allow creating more buffers
than that the changes required to support more would be likely limited to
videobuf2.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
