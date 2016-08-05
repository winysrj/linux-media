Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56578 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161207AbcHEL0d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 07:26:33 -0400
Date: Fri, 5 Aug 2016 14:26:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 00/11] New raw bayer format definitions, fixes
Message-ID: <20160805112625.GN3243@valkosipuli.retiisi.org.uk>
References: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470393941-26959-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 05, 2016 at 01:45:30PM +0300, Sakari Ailus wrote:
> Hi all,
> 
> This is a third version of the new bayer format patchset. The second version
> of the set may be found here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg101498.html>
> 
> These patches fix and add new raw bayer format definitions. 12-bit packed
> V4L2 format definition is added as well as definitions of 14-bit media bus
> codes as well as unpacked and packed V4L2 formats.
> 
> No driver uses them right now, yet they're common formats needed by newer
> devices that use higher bit depths so adding them would make sense.
> 
> 16-bit pixel formats are added as well, and the 16-bit formats are now
> expected to have 16 bits of data. 8-bit format documentation is unified. 

The HTML documentation can be found here:

<URL:http://salottisipuli.retiisi.org.uk/~sailus/raw14-doc/media/uapi/v4l/pixfmt-rgb.html>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
