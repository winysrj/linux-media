Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35398 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750939AbcIBISI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 04:18:08 -0400
Date: Fri, 2 Sep 2016 11:18:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/4] v4l: Add metadata buffer type and format
Message-ID: <20160902081804.GY12130@valkosipuli.retiisi.org.uk>
References: <1471436430-26245-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160829091339.GN12130@valkosipuli.retiisi.org.uk>
 <2431560.80mbed248J@avalon>
 <6187282.rGRMgY1WYC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6187282.rGRMgY1WYC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Sep 02, 2016 at 12:40:18AM +0300, Laurent Pinchart wrote:
...
> > >> +Data Format Negotiation
> > >> +=======================
> > >> +
> > >> +The metadata device uses the :ref:`format` ioctls to select the capture
> > >> format. +The metadata buffer content format is bound to that selected
> > >> format. In addition +to the basic :ref:`format` ioctls, the
> > >> 
> > >> :ref:`VIDIOC_ENUM_FMT` ioctl must be +supported as well.
> > >> 
> > >> +
> > >> +To use the :ref:`format` ioctls applications set the ``type`` of the
> > >> +:ref:`v4l2_format <v4l2-format>` structure to
> > >> ``V4L2_BUF_TYPE_META_CAPTURE`` +and use the :ref:`v4l2_meta_format
> > >> <v4l2-meta-format>` ``meta`` member of the +``fmt`` union as needed per
> > >> the desired operation. The :ref:`v4l2-meta-format` +structure contains
> > >> two fields, ``dataformat`` is set by applications to the V4L2
> > > 
> > > I might not specify the number of number of fields here. It has high
> > > chances of not getting updated when more fields are added. Up to you.
> > 
> > This has been copied from dev-sdr.rst. I can drop the last sentence
> > completely as the parameters are described in the table below. Hans, any
> > opinion ?
> 
> How about this ?
> 
> To use the :ref:`format` ioctls applications set the ``type`` of the

s/of/field of/

?

> :ref:`v4l2_format <v4l2-format>` structure to ``V4L2_BUF_TYPE_META_CAPTURE``
> and use the :ref:`v4l2_meta_format <v4l2-meta-format>` ``meta`` member of the
> ``fmt`` union as needed per the desired operation. Both drivers and 
> applications must set the remainder of the :ref:`v4l2_format <v4l2-format>` 
> structure to 0.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
