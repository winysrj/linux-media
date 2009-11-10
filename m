Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54201 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753001AbZKJJjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 04:39:04 -0500
Date: Tue, 10 Nov 2009 10:39:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] ezx: Add camera support for A780 and A910 EZX
 phones
In-Reply-To: <20091110102950.497af1fb.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911101037280.5074@axis700.grange>
References: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
 <1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
 <Pine.LNX.4.64.0911050040160.4837@axis700.grange>
 <20091105234429.ef855e2d.ospite@studenti.unina.it>
 <Pine.LNX.4.64.0911061419220.4389@axis700.grange>
 <20091106182910.a3b48c41.ospite@studenti.unina.it>
 <20091110102950.497af1fb.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Nov 2009, Antonio Ospite wrote:

> Ping.
> 
> Guennadi, did you see the patch below? Or I should completely remove
> the .init() callback like you said in another message?
> As I said, my humble preference would be to keep GPIOs setup local to
> the driver somehow, but you just tell me what to do :)

Yes, please make GPIO config static and remove .init.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
