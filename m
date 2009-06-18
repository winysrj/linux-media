Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45732 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753874AbZFRKKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 06:10:44 -0400
Date: Thu, 18 Jun 2009 12:10:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: mx31moboard MT9T031 camera support
In-Reply-To: <4A3A0E41.5020208@epfl.ch>
Message-ID: <Pine.LNX.4.64.0906181200050.5779@axis700.grange>
References: <4A39FE96.4010004@epfl.ch> <Pine.LNX.4.64.0906181054280.5779@axis700.grange>
 <4A3A0E41.5020208@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Jun 2009, Valentin Longchamp wrote:

> The sensor chips both are mt9t031 so they have the same i2c address (I have
> looked at the datasheet, and I don't think this can be changed). So I cannot
> use them both at the same time.

Right, but I think, there are some i2c ICs, that allow for address 
translations. Don't remember what they are called, some multiplexers or 
some such.

> Now you talk about the .power() callback, I could use it so that the
> multiplexer is managed by it, using a similar mechanism as in mach-migor. If
> this could allow me one different /dev/video nod for each camera (that of
> course cannot be used at the same time), it would simplify a lot of things for
> my users. I will give it a try (hoping that this also works at driver
> registering ... we will see).

Don't think it would work, at least not with the current stack. With the 
new stack video devices are registered at host-driver registration time, 
after i2c devices are registered. It wouldn't work with the old stack 
either.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
