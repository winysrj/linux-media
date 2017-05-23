Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49134 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1034371AbdEWVoB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 17:44:01 -0400
Date: Wed, 24 May 2017 00:43:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Kieran Bingham <kbingham@kernel.org>,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v3 2/2] v4l: async: Match parent devices
Message-ID: <20170523214352.GH29527@valkosipuli.retiisi.org.uk>
References: <cover.33d4457de9c9f4e5285e7b1d18a8a92345c438d3.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6154c8f092e1cb4f5286c1f11f4a846c821b53d6.1495473356.git-series.kieran.bingham+renesas@ideasonboard.com>
 <20170523130222.GE29527@valkosipuli.retiisi.org.uk>
 <f56ce770-c7cc-1613-194f-e5f9a944dc4e@ideasonboard.com>
 <20170523214018.GG29527@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523214018.GG29527@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 24, 2017 at 12:40:19AM +0300, Sakari Ailus wrote:
> >  * When all devices use endpoint matching, this code can be simplified, and the
> >  * parent comparisons can be removed.

Oh, and this I'm not so sure about --- we'll need to match lens controllers
and flash drivers. There are no endpoints in those devices. Let's see how it
goes when we get there...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
