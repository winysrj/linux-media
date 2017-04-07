Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60554 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752470AbdDGW42 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 18:56:28 -0400
Date: Sat, 8 Apr 2017 01:56:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 6/8] v4l: media/drv-intf/soc_mediabus.h: include
 dependent header file
Message-ID: <20170407225624.GN4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-7-git-send-email-sakari.ailus@linux.intel.com>
 <2155093.Y2052RbRLf@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2155093.Y2052RbRLf@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 01:01:29PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 06 Apr 2017 16:12:08 Sakari Ailus wrote:
> > media/drv-intf/soc_mediabus.h does depend on struct v4l2_mbus_config which
> > is defined in media/v4l2-mediabus.h. Include it.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Was this provided indirectly before, through v4l2-of.h perhaps ? If so, 
> shouldn't this patch be moved before 5/8 ? Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I tried compiling with and without this patch and see no difference. I could
miss something but the more likely case is that the reason why I wrote this
patch has ceased to exist. I'll drop it from the set, at least for now.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
