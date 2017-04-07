Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59280 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756384AbdDGVaV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 17:30:21 -0400
Date: Sat, 8 Apr 2017 00:30:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/8] v4l: fwnode: Support generic fwnode for parsing
 standardised properties
Message-ID: <20170407213010.GJ4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-3-git-send-email-sakari.ailus@linux.intel.com>
 <2366571.B7YdK6QUO2@avalon>
 <20170407103633.GD4192@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407103633.GD4192@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 07, 2017 at 01:36:34PM +0300, Sakari Ailus wrote:
...
> > > +	if (is_of_node(fwn)) {
> > > +		if (of_node_cmp(to_of_node(fwn)->name, "ports") == 0)
> > > +			fwn = fwnode_get_next_parent(fwn);
> > > +	} else {
> > > +		/* The "ports" node is always there in ACPI. */

This comment is actually wrong and does not reflect the current
implementation anymore. I'll fix that as well.

> > > +		fwn = fwnode_get_next_parent(fwn);
> > > +	}

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
