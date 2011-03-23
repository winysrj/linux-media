Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:54461 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1CWKBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 06:01:02 -0400
Date: Wed, 23 Mar 2011 11:00:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: linux-media@vger.kernel.org,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface
In-Reply-To: <201009301335.51643.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1103231056360.6836@axis700.grange>
References: <201009301335.51643.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Janusz

You might want to retest ams-delta with the camera on the current (next or

git://linuxtv.org/media_tree.git staging/for_v2.6.39

) kernel - I suspect, you'll need something similar to

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/30728

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
