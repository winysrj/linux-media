Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43209 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbZCHAjy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 19:39:54 -0500
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903030929160.5059@axis700.grange>
	<87zlg2e94i.fsf@free.fr>
	<Pine.LNX.4.64.0903080003010.6783@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sun, 08 Mar 2009 01:39:42 +0100
Message-ID: <871vt8hmpd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Emn, no. Just looked in CodingStyle - haven't found a word about it. So, I 
> think, applies "keep consistent with the rest of the file." And, you know, 
> someone might call this a matter of taste, but a line like
>
> 	x = y
>
> in a .c file looks unfinished to me, whereas
>
> 	x = y +
>
> clearly has a continuation. That's how I learned to break lines at school, 
> at the Uni,... Ok, never mind, in any case, until this is not in 
> CodingStyle, I will nak all attempts to convert the whole driver to the 
> opposite of what it has ATM. So, I'll drop "3/4" and will request 
> amendments to other affected patches, ok?
OK, no problem.

I'm neither strongly fond of one syntax or the other. I'll amend the other
patches while you're working on the review.

Cheers.

--
Robert
