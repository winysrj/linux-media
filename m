Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49675 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab2ADUKM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 15:10:12 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] V4L: mt9m111: clean up and fix .s_crop() / .s_fmt()
References: <Pine.LNX.4.64.1112211649070.30646@axis700.grange>
Date: Wed, 04 Jan 2012 21:09:58 +0100
In-Reply-To: <Pine.LNX.4.64.1112211649070.30646@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 21 Dec 2011 16:53:43 +0100 (CET)")
Message-ID: <87d3aznsa1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi all
>
> While working on a context-switching test, I've cleaned up the mt9m111 
> driver a bit and fixed its cropping and scaling functions. These are 
> planned for 3.3.

Hi Guennadi,

I've been on holidays ... so I've not dived into your changes.
>From a quick glance, it looks good. Did you test your changes on real hardware
(I'm thinking of the suspend power cut part) ?

Cheers.

-- 
Robert
