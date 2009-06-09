Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35790 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752428AbZFIPEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 11:04:51 -0400
Date: Tue, 9 Jun 2009 16:05:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 2/2] se401: Fix coding style
Message-ID: <20090609160522.5e78332b@lxorguk.ukuu.org.uk>
In-Reply-To: <4A2E6F02.6040003@teltonika.lt>
References: <20090609125408.10098.45945.stgit@t61.ukuu.org.uk>
	<20090609125720.10098.88218.stgit@t61.ukuu.org.uk>
	<4A2E6F02.6040003@teltonika.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > -		adr += PAGE_SIZE;
> > -		size -= PAGE_SIZE;
> > +		adr +=  PAGE_SIZE;
> > +		size -=  PAGE_SIZE;
> 
> Why 2 spaces are better here?

Regexps need tweaking a tiny bit I guess. I'll post a follow up patch at
some point when I'm back dealing with ultra-low priority tweaks (although
it does now pass codingstyle like that anyway).

