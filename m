Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54994 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755626Ab0GUNpC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 09:45:02 -0400
Date: Wed, 21 Jul 2010 15:45:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jun Nie <niej0001@gmail.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Is it feasible to add another driver for CCIC?
In-Reply-To: <AANLkTilMPncmtk5OC4pe2Mbi-3bTmp3dxZM2JB5p5u-o@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1007211542550.16933@axis700.grange>
References: <AANLkTilMPncmtk5OC4pe2Mbi-3bTmp3dxZM2JB5p5u-o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Jul 2010, Jun Nie wrote:

> Hi,
>     I am working on CCIC camera controller driver and want to push it
> into kernel. This CCIC IP is similar with IP of cafe_ccic, but with
> lots of change: no I2C bus, embedded in SOC/no PCI, support both
> parallel and CSI interface. So some register definition changes.
>     I just want to confirm that a new driver for SOC CCIC is
> acceptable for community.
>     Thanks!

Well, if there is a well defined common "core" of the both 
implementations, e.g., common register set (or at least most of them), 
then, I think, it would make sense to split the current cafe_ccic, extract 
that core and reuse it... It is always an interesting decision, whether 
two devices are similar enough or not.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
