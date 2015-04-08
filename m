Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57742 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753363AbbDHWGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 18:06:52 -0400
Date: Thu, 9 Apr 2015 01:06:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	s.nawrocki@samsung.com
Subject: Re: [PATCH v3 1/4] v4l: of: Remove the head field in struct
 v4l2_of_endpoint
Message-ID: <20150408220616.GW20756@valkosipuli.retiisi.org.uk>
References: <1428361053-20411-1-git-send-email-sakari.ailus@iki.fi>
 <1428361053-20411-2-git-send-email-sakari.ailus@iki.fi>
 <2590752.PorL0aNYep@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2590752.PorL0aNYep@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Apr 07, 2015 at 01:11:34PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 07 April 2015 01:57:29 Sakari Ailus wrote:
> > The field is unused. Remove it.
> 
> Do you know what the field was added for in the first place ?

Frankly I have to admit I have no idea. It's part of the original patch
which adds V4L2 OF support:

---
commit 99fd133f907afdb430942d8d2ae53faa438adfe8
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Wed Sep 26 05:24:03 2012 -0300

    [media] Add a V4L2 OF parser
    
    Add a V4L2 OF parser, implementing bindings documented in
    Documentation/devicetree/bindings/media/video-interfaces.txt.
    [s.nawrocki@samsung.com: various corrections and improvements
    since the initial version]
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

It looks like the intent has been that the field is used in order to keep a
list of structs of this kind, but no-one is using it for that purpose at the
moment.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
