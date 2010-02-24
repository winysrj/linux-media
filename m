Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753844Ab0BXIfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 03:35:53 -0500
Date: Wed, 24 Feb 2010 09:35:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: failing videobuf_iolock() in multiple drivers - wrong error processing?
Message-ID: <Pine.LNX.4.64.1002240928430.4741@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looking at .buf_prepare() videobuf_queue_ops methods I cannot understand, 
why if videobuf_iolock() fails they all call some internal buffer freeing 
function, that, among others, also calls some nideobuf-specific free 
function... Is this really needed, if yes - why?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
