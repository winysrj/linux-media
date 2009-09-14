Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37857 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752632AbZINOpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 10:45:43 -0400
Date: Mon, 14 Sep 2009 16:45:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
In-Reply-To: <200909141635.24286.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909141643160.4359@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
 <200909131843.18007.marek.vasut@gmail.com> <Pine.LNX.4.64.0909132030530.9668@axis700.grange>
 <200909141635.24286.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, you were faster than I:-) If you agree, I can just remove those two 
RGB formats myself, changing your comment to a TODO, and modify the 
comment next to msleep(150) (if you could tell me what value didn't work, 
that would be appreciated) and push it out.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
