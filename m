Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35736 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753472AbdDGKqZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 06:46:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/8] v4l: async: Add fwnode match support
Date: Fri, 07 Apr 2017 13:47:11 +0300
Message-ID: <3116679.V91IAuC66O@avalon>
In-Reply-To: <20170407104508.GF4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com> <2374089.j4OXu9zDtc@avalon> <20170407104508.GF4192@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 07 Apr 2017 13:45:09 Sakari Ailus wrote:
> On Fri, Apr 07, 2017 at 01:04:47PM +0300, Laurent Pinchart wrote:
> > > @@ -58,6 +60,9 @@ struct v4l2_async_subdev {
> > >  			const struct device_node *node;
> > >  		} of;
> > >  		struct {
> > > +			struct fwnode_handle *fwn;
> > 
> > Shouldn't this be const ?
> 
> I thought the same, but a lot of functions that operate on fwnode_handle
> take a non-const argument. I attempted changing that, but it starts a
> cascade of unavoidable changes elsewhere. That's not very well suitable for
> this patchset.

fwnode is young, we should try to fix it instead of propagating issues :-)

-- 
Regards,

Laurent Pinchart
