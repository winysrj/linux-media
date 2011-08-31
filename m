Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51526 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HaNxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:53:40 -0400
Date: Wed, 31 Aug 2011 15:53:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH 0/6] Capture menu reorganization
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1108311551500.8429@axis700.grange>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Wed, 31 Aug 2011, Hans Verkuil wrote:

> I think this is how I would reorganize the capture menu. IMHO it's much easier
> to navigate, and should be even better once the soc-camera sensor drivers can
> be moved to the other sensors.
> 
> For the radio adapters a similar change would be needed (all the ISA drivers
> in particular should be grouped in a submenu).

Thanks for tackling this. A general note: I really think, sorting entries 
inside categories alphabetically would help.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
