Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51000 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbcFXL2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 07:28:52 -0400
Date: Fri, 24 Jun 2016 13:28:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/3] uvcvideo: a cosmetic fix and 2 new features
Message-ID: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

The first patch in the series fixes a warning, introduced by a recent 
framework change. Maybe you already have a similar one in your queue, drop 
this one then, please.

Patch 2/3 implements support for asynchronous controls, using V4L2 events.

Patch 3/3 adds a metadata device node to enable streaming of private 
payoad header to the user, based on your recent patch series. As everybody 
was agreeing, I didn't use patch 2 from the series, adding a new metadata 
video device type, using the GRABBER type instead. The additional video 
node is so added unconditionally in this patch, which I find superfluous 
and confusing for the user, because most cameras will not have any private 
data in the payload header, so, those nodes will be useless. I'm open to 
suggestions to make this node conditional on something - on a quirk flag? 
Unfortunately you can only find out, whether a camera has additional data 
in the header, when you receive the first frame.

Thanks
Guennadi
