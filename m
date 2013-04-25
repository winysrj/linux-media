Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3DYOPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 10:15:45 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6D8DC40BB3
	for <linux-media@vger.kernel.org>; Thu, 25 Apr 2013 16:15:43 +0200 (CEST)
Date: Thu, 25 Apr 2013 16:15:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] soc-camera: common cropping and scaling helpers
Message-ID: <Pine.LNX.4.64.1304251601080.21045@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Recently a VIN soc-camera host driver has been submitted, that was based 
on the sh_mobile_ceu_camera driver and as such it copied some of its 
functions with no or very little change. This patch set extracts those 
functions to make them available for other soc-camera drivers too. Those 
functions deal with optimal cropping and scaling configuration of the host 
and the client. It isn't easy to get this right, so, it is better to have 
these routines centrally to get a better test coverage and not to have to 
fix or extend each driver separately.

The way these patches are organised is to make it simple to follow changes 
and avoid any breakage. The first one modifies the functions in-place, 
preparing them for extraction. The second one really just moves them out 
into a separate file without any further changes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
