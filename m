Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65233 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbbECQLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 12:11:04 -0400
Received: from axis700.grange ([78.35.82.51]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MHokD-1YqJWl1WRB-003eV6 for
 <linux-media@vger.kernel.org>; Sun, 03 May 2015 18:11:02 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 774FB40BD9
	for <linux-media@vger.kernel.org>; Sun,  3 May 2015 18:11:00 +0200 (CEST)
Date: Sun, 3 May 2015 18:11:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera: opinion poll - future directions
Message-ID: <Pine.LNX.4.64.1505031800140.4237@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Just a quick opinion poll - where and how should the soc-camera framework 
and drivers be heading? Possible (probably not all) directions:

(1) all is good, keep as is. That means keep all drivers, killing them off 
only when it becomes very obvious, that noone wants them, keep developing 
drivers, that are still being used and updating all of them on any API 
updates. Keep me as maintainer, which means slow patch processing rate and 
no active participation in new developments - at hardware, soc-camera or 
V4L levels.

(2) we want more! I.e. some contributors are planning to either add new 
drivers to it or significantly develop existing ones, see significant 
benefit in it. In this case it might become necessary to replace me with 
someone, who can be more active in this area.

(3) slowly phase out. Try to either deprecate and remove soc-camera 
drivers one by one or move them out to become independent V4L2 host or 
subdevice drivers, but keep updating while still there.

(4) basically as (3) but even more aggressively - get rid of it ASAP:)

Opinions? Expecially would be interesting to hear from respective 
host-driver maintainers / developers, sorry, not adding CCs, they probably 
read the list anyway:)

Thanks
Guennadi
