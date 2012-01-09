Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51928 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2AIKsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 05:48:24 -0500
Date: Mon, 9 Jan 2012 12:48:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: tuukkat76@gmail.com, dacohen@gmail.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, snjw23@gmail.com
Subject: Re: [ANN] IRC meeting on new sensor control interface, 2012-01-09
 14:00 GMT+2
Message-ID: <20120109104815.GQ9323@valkosipuli.localdomain>
References: <20120104085633.GM3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104085633.GM3677@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Jan 04, 2012 at 10:56:33AM +0200, Sakari Ailus wrote:
> Hi all,
> 
> I'd like to announce that we'll have an IRC meeting on #v4l-meeting channel
> on the new sensor control interface. The date is next Monday 2012-01-09
> 14:00 GMT + 2. Most important background information is this; it discusses
> how image sensors should be controlled:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg40861.html>
> 
> These changes currently depend on
> 
> - Integer menu controls [1],
> - Selection IOCTL for subdevs [2] and

Based on Laurent's comments to the subdev selection patches, I drew a
diagram to visualise format / crop / scaling and composition configuration.
It's available here:

<URL:http://www.retiisi.org.uk/v4l2/tmp/format.eps>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
