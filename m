Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:41381 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648Ab2HXQVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:21:25 -0400
Date: Fri, 24 Aug 2012 18:21:25 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Detlev Zundel <dzu@denx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other
 register settings
Message-ID: <20120824182125.4d19ed64@wker>
In-Reply-To: <Pine.LNX.4.64.1208241527370.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241227140.20710@axis700.grange>
	<m2pq6g5tm3.fsf@lamuella.denx.de>
	<Pine.LNX.4.64.1208241527370.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 24 Aug 2012 15:35:59 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> Below I asked to provide details about how you have to change this 
> register value: toggle dynamically at run-time or just set once at 
> initialisation? Even if toggle: are this certain moments, related to 
> standard camera activities (e.g., starting and stopping streaming, 
> changing geometry etc.) or you have to set this absolutely asynchronously 
> at moments of time, that only your application knows about?

Every time the sensor is reset, it resets this register. Without setting
the register after sensor reset to the needed value I only get garbage data
from the sensor. Since the possibility to reset the sensor is provided on
the hardware and also used, the register has to be set after each sensor
reset. Only the instance controlling the reset gpio pin "knows" the time,
when the register should be initialized again, so it is asynchronously and
not related to the standard camera activities. But since the stuff is _not_
documented, I can only speculate. Maybe it can be set to different values
to achieve different things, currently I do not know.

Thanks,

Anatolij
