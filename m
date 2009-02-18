Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45556 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZBRTqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 14:46:48 -0500
Date: Wed, 18 Feb 2009 20:44:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Manu <eallaud@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Re : TT 3650
Message-ID: <20090218204455.19b867a0@free.fr>
In-Reply-To: <1234961317.5755.0@manu-laptop>
References: <20090218092217.232120@gmx.net>
	<20090218103353.64bf6400@free.fr>
	<1234961317.5755.0@manu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 08:48:37 -0400
Manu <eallaud@gmail.com> wrote:

> > I have such a USB device. It works fine without any patch with the
> > last
> > version of Igor M. Liplianin's repository:
> > 
> > 	http://mercurial.intuxication.org/hg/s2-liplianin/  
> 
> Hmm do you mean that you can lock any DVB-S2 transponder with it?

Yes. I use it to look at FTA channels on AB3 5°W:

- France 24 (12674.00 H - DVB-S2 - QPSK) is good.

- I can also get the transponder 11636.00 V (DVB Newtec - QPSK), but not
  the transponder 11139.00 V (DVB Newtec - 8PSK turbo) 

- For some time, there were clear channels (M6 and W9) in the
  transponder 11471.00 V (DVB-S2 - 8PSK). Both were fine.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
