Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752782AbdHNKyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 06:54:43 -0400
Date: Mon, 14 Aug 2017 13:54:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v1.2 1/1] omap3isp: Skip CSI-2 receiver initialisation in
 CCP2 configuration
Message-ID: <20170814105441.qg273z3vm4iowxhj@valkosipuli.retiisi.org.uk>
References: <20170811095709.3069-1-sakari.ailus@linux.intel.com>
 <29475894.0Ps0lzjic1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29475894.0Ps0lzjic1@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 11, 2017 at 02:32:00PM +0300, Laurent Pinchart wrote:
> > +	if (!pipe)
> > +		return -EBUSY;
> 
> When can this happen ?

And this test should be for phy->entity instead.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
