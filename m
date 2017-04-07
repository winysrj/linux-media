Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43142 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752971AbdDGKpM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 06:45:12 -0400
Date: Fri, 7 Apr 2017 13:45:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/8] v4l: async: Add fwnode match support
Message-ID: <20170407104508.GF4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-4-git-send-email-sakari.ailus@linux.intel.com>
 <2374089.j4OXu9zDtc@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2374089.j4OXu9zDtc@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 01:04:47PM +0300, Laurent Pinchart wrote:
> > @@ -58,6 +60,9 @@ struct v4l2_async_subdev {
> >  			const struct device_node *node;
> >  		} of;
> >  		struct {
> > +			struct fwnode_handle *fwn;
> 
> Shouldn't this be const ?

I thought the same, but a lot of functions that operate on fwnode_handle
take a non-const argument. I attempted changing that, but it starts a
cascade of unavoidable changes elsewhere. That's not very well suitable for
this patchset.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
