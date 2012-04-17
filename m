Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:36773 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2DQKvi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:51:38 -0400
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 01/15] V4L: Extend =?UTF-8?Q?V=34L=32=5FCID=5FCOLORFX=20with?=
 =?UTF-8?Q?=20more=20image=20effects?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 17 Apr 2012 12:51:25 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<sakari.ailus@iki.fi>, <g.liakhovetski@gmx.de>,
	<hdegoede@redhat.com>, <moinejf@free.fr>,
	<m.szyprowski@samsung.com>, <riverful.kim@samsung.com>,
	<sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1334657396-5737-2-git-send-email-s.nawrocki@samsung.com>
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com> <1334657396-5737-2-git-send-email-s.nawrocki@samsung.com>
Message-ID: <3eb7475de1e1ce7d7a1dcae7dd11d13c@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Apr 2012 12:09:42 +0200, Sylwester Nawrocki

<s.nawrocki@samsung.com> wrote:

> This patch adds definition of additional color effects:

>  - V4L2_COLORFX_AQUA,

>  - V4L2_COLORFX_ART_FREEZE,

>  - V4L2_COLORFX_SILHOUETTE,

>  - V4L2_COLORFX_SOLARIZATION,

>  - V4L2_COLORFX_ANTIQUE,



There starts to be a lot of different color effects with no obvious way to

determine which ones the current device actually suppots. Should this not

be a menu control instead?



>  - V4L2_COLORFX_ARBITRARY.

>

> The control's type in the documentation is changed from 'enum' to 'menu'

> - V4L2_CID_COLORFX has always been a menu, not an integer type control.

> 

> The V4L2_COLORFX_ARBITRARY option enables custom color effects, which

are

> impossible or impractical to define as the menu items. For example, the

> devices may provide coefficients for Cb and Cr manipulation, which yield

> many permutations, e.g. many slightly different color tints. Such

devices

> are better exporting their own API for precise control of non-standard

> color effects.



I don't understand why you need a number for this, if it's going to use

another control anyway... ?



-- 

Rémi Denis-Courmont

Sent from my collocated server
