Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:47385 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab0DZWI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 18:08:57 -0400
Subject: Re: Kworld Plus TV Hybrid PCI (DVB-T 210SE)
From: hermann pitton <hermann-pitton@arcor.de>
To: 0123peter@gmail.com
Cc: linux-media@vger.kernel.org
In-Reply-To: <dabga7-50k.ln1@psd.motzarella.org>
References: <4B94CF9B.3060000@gmail.com>
	 <1268777563.5120.57.camel@pc07.localdom.local>
	 <0h2e77-gjl.ln1@psd.motzarella.org>
	 <1269298611.5158.20.camel@pc07.localdom.local>
	 <0uh687-4c1.ln1@psd.motzarella.org>
	 <1269895933.3176.12.camel@pc07.localdom.local>
	 <iou897-qu3.ln1@psd.motzarella.org>
	 <1271302350.3184.16.camel@pc07.localdom.local>
	 <g1hj97-b2a.ln1@psd.motzarella.org>
	 <1271375445.12504.69.camel@pc07.localdom.local>
	 <dabga7-50k.ln1@psd.motzarella.org>
Content-Type: text/plain
Date: Tue, 27 Apr 2010 00:04:34 +0200
Message-Id: <1272319474.4246.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 26.04.2010, 21:51 +1000 schrieb 0123peter@gmail.com:

[snip]
> >> >> > 
> >> >> > If it is a additional new regression, then mercurial bisect can find the
> >> >> > patch in question fairly quick.
> >> >> 
> >> >> That sounds like something that I should be able to do, if only 
> >> >> I'd read the instructions.  
> >> > 
> >> > It is totally up to you and all others with that hardware.
> >> 
> >> Can you provide a like for where to start reading?
> > 
> > README.patches.  
> > 
> >      Part III - Best Practices
> > 	1. Community best practices
> > 	2. Mercurial specific procedures
> > 	3. Knowing about newer patches committed at the development repositories
> > 	4. Patch submission from the community
> > 	5. Identifying regressions with Mercurial
> 
> I have not found the file README.patches.  
> 

Peter, for that one.

"yum", or whatever, "install mercurial".

"hg clone http://linuxtv.org/hg/v4l-dvb"
"cd v4l-dvb"
"less README.patches"

Cheers,
Hermann


