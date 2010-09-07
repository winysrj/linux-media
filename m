Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.230]:55821 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab0IGTOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Sep 2010 15:14:51 -0400
Date: Tue, 7 Sep 2010 22:12:07 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Jean-Francois Moine <moinejf@free.fr>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Illuminators and status LED controls
Message-ID: <20100907191207.GA10360@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <20100906201105.4029d7e7@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100906201105.4029d7e7@tele>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On Mon, Sep 06, 2010 at 08:11:05PM +0200, ext Jean-Francois Moine wrote:
> Hi,
> 
> This new proposal cancels the previous 'LED control' patch.
> 
> Cheers.
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/

Apologies if this has been already discussed but,
doesn't this patch duplicates the same feature present
nowadays under include/linux/leds.h ??

I mean, if you want to control leds, I think we already have that API, no?

BR,

---
Eduardo Valentin
