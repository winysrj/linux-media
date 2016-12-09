Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51874 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932247AbcLIKIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 05:08:20 -0500
Date: Fri, 9 Dec 2016 12:07:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bartosz =?utf-8?Q?Go=C5=82aszewski?= <bgolaszewski@baylibre.com>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/5] [media] davinci: VPIF: fix module loading, init
 errors
Message-ID: <20161209100741.GL16630@valkosipuli.retiisi.org.uk>
References: <20161207183025.20684-1-khilman@baylibre.com>
 <20161207183025.20684-2-khilman@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207183025.20684-2-khilman@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 07, 2016 at 10:30:21AM -0800, Kevin Hilman wrote:
> Fix problems with automatic module loading by adding MODULE_ALIAS.  Also
> fix various load-time errors cause by incorrect or not present
> platform_data.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
