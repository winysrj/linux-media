Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49406 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933181AbdGKTiG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 15:38:06 -0400
Date: Tue, 11 Jul 2017 22:38:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH] [media] davinci: vpif_capture: fix potential NULL deref
Message-ID: <20170711193801.mohebkj6igfmy7hu@valkosipuli.retiisi.org.uk>
References: <20170711190752.30142-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170711190752.30142-1-khilman@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 11, 2017 at 12:07:52PM -0700, Kevin Hilman wrote:
> Fix potential NULL pointer dereference in the error path of memory
> allocation failure.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
