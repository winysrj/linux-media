Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52710 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750783AbZCGXLG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 18:11:06 -0500
Date: Sun, 8 Mar 2009 00:11:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: ospite@studenti.unina.it, mike@compulab.co.il,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] pxa_camera: Redesign DMA handling
In-Reply-To: <87zlg2e94i.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0903080003010.6783@axis700.grange>
References: <1236021422-8074-1-git-send-email-robert.jarzmik@free.fr>
 <Pine.LNX.4.64.0903030929160.5059@axis700.grange> <87zlg2e94i.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Mar 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > 	x = y
> > 		| z;
> >
> > to
> >
> > 	x = y |
> > 		z;
> >
> > just to make consistent with the rest of the driver.
> May I do it the other way (change all other occurences) ? I was corrected on
> other drivers to use the first form as the coding style, so can I reformat
> pxa_camera to abide by this rule ?

Emn, no. Just looked in CodingStyle - haven't found a word about it. So, I 
think, applies "keep consistent with the rest of the file." And, you know, 
someone might call this a matter of taste, but a line like

	x = y

in a .c file looks unfinished to me, whereas

	x = y +

clearly has a continuation. That's how I learned to break lines at school, 
at the Uni,... Ok, never mind, in any case, until this is not in 
CodingStyle, I will nak all attempts to convert the whole driver to the 
opposite of what it has ATM. So, I'll drop "3/4" and will request 
amendments to other affected patches, ok?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
