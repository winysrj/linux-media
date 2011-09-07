Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1IGRy1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 13:54:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id DF38218B03B
	for <linux-media@vger.kernel.org>; Wed,  7 Sep 2011 17:13:03 +0200 (CEST)
Date: Wed, 7 Sep 2011 17:13:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] soc-camera: add .s_power() subdevice calls
Message-ID: <Pine.LNX.4.64.1109071706550.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently soc-camera supports using regulators and platform callbacks for 
client (sensor, decoder,...) power management. These patches also call 
driver own .s_power() methods in the same scope.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
