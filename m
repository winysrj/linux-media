Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45672 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932134Ab2GALN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 07:13:57 -0400
Date: Sun, 1 Jul 2012 14:13:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 3/8] v4l: Unify selection targets across V4L2 and V4L2
 subdev interfaces
Message-ID: <20120701111352.GH19384@valkosipuli.retiisi.org.uk>
References: <20120630170506.GE19384@valkosipuli.retiisi.org.uk>
 <1341075839-18586-3-git-send-email-sakari.ailus@iki.fi>
 <4FEF6006.3050109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEF6006.3050109@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Jun 30, 2012 at 10:22:30PM +0200, Sylwester Nawrocki wrote:
> On 06/30/2012 07:03 PM, Sakari Ailus wrote:
> 
> Would be good to add at least a small description here, that this
> patch converts users of V4L2_SUBDEV_SEL_TGT_* to use V4L2_SEL_TGT_*,
> or something similar.

Fixed.

...

> >diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
> >new file mode 100644
> >index 0000000..b49a37a
> >--- /dev/null
> >+++ b/include/linux/v4l2-common.h
> >@@ -0,0 +1,57 @@
> >+/*
> >+ * include/linux/v4l2-common.h
> >+ *
> >+ * Common V4L2 and V4L2 subdev definitions.
> >+ *
> >+ * Users are advised to #include this file either through videodev2.h
> >+ * (V4L2) or through v4l2-subdev.h (V4L2 subdev) rather than to refer
> >+ * to this file directly.
> >+ *
> >+ * Copyright (C) 2012 Nokia Corporation
> >+ * Contact: Sakari Ailus<sakari.ailus@iki.fi>
> >+ *
> >+ * This program is free software; you can redistribute it and/or
> >+ * modify it under the terms of the GNU General Public License
> >+ * version 2 as published by the Free Software Foundation.
> >+ *
> >+ * This program is distributed in the hope that it will be useful, but
> >+ * WITHOUT ANY WARRANTY; without even the implied warranty of
> >+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> >+ * General Public License for more details.
> >+ *
> >+ * You should have received a copy of the GNU General Public License
> >+ * along with this program; if not, write to the Free Software
> >+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> >+ * 02110-1301 USA
> >+ *
> >+ */
> >+
> >+#ifndef __V4L2_COMMON__
> >+#define __V4L2_COMMON__
> >+
> >+/* Selection target definitions */
> >+
> >+/* Current cropping area */
> >+#define V4L2_SEL_TGT_CROP		0x0000
> >+/* Default cropping area */
> >+#define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
> >+/* Cropping bounds */
> >+#define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
> >+/* Current composing area */
> >+#define V4L2_SEL_TGT_COMPOSE		0x0100
> >+/* Default composing area */
> >+#define V4L2_SEL_TGT_COMPOSE_DEFAULT	0x0101
> >+/* Composing bounds */
> >+#define V4L2_SEL_TGT_COMPOSE_BOUNDS	0x0102
> >+/* Current composing area plus all padding pixels */
> >+#define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
> >+
> >+/* Backward compatibility definitions */
> >+#define V4L2_SEL_TGT_CROP_ACTIVE	V4L2_SEL_TGT_CROP
> >+#define V4L2_SEL_TGT_COMPOSE_ACTIVE	V4L2_SEL_TGT_COMPOSE
> >+#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL \
> >+	V4L2_SUBDEV_SEL_TGT_CROP
> >+#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL \
> >+	V4L2_SUBDEV_SEL_TGT_COMPOSE
> 
> This should read:
> 
> #define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL		V4L2_SEL_TGT_CROP
> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL	V4L2_SEL_TGT_COMPOSE
> 
> right ? As V4L2_SUBDEV_SEL_TGT_* defines are already annihilated
> at this point ?

Correct. There's been so many variations of these that I've become blind to
small differences. ;-)

> I would also increase indentation between symbols and numbers
> and wouldn't use backslashes.
> 
> With this fixed:
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks!!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
