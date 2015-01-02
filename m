Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62825 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbbABLsh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Jan 2015 06:48:37 -0500
Date: Fri, 2 Jan 2015 12:48:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Josh Wu <josh.wu@atmel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 0/2] V4L2: add CCF support to v4l2_clk
Message-ID: <Pine.LNX.4.64.1501021244580.30761@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is an attempt to implement CCF support for v4l2_clk to be able to use 
e.g. DT-based clocks. Beware - completely untested! Josh, could you please 
see, whether you can use this as a starting point?

Thanks
Guennadi
