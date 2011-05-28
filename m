Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:59110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1E1OnU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 10:43:20 -0400
Date: Sat, 28 May 2011 16:43:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Koen Kooi <koen@beagleboard.org>, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	carlighting@yahoo.co.nz
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with
 power managament.
In-Reply-To: <BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105281542200.6780@axis700.grange>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com>
 <F50AF7E4-DCBA-4FC9-971A-ADF01F342FEF@beagleboard.org>
 <BANLkTiksN_+12hdQFOQ9+bS5LBU+QSR4cA@mail.gmail.com>
 <07EF42D6-0587-4F35-8431-E03B9994F9B5@beagleboard.org>
 <BANLkTikon2uw4DWcsXLCnLD1crfbV7HP_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier

On Thu, 26 May 2011, javier Martin wrote:

> I use a patched version of yavta and Mplayer to see video
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)

Are you really using those versions and patches, as described in 
BBxM-MT9P031.txt? I don't think those versions still work with 2.6.39, 
they don't even compile for me. Whereas if I take current HEAD, it builds 
and media-ctl seems to run error-free, but yavta produces no output.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
