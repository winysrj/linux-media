Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:35168 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbZCVA6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 20:58:03 -0400
Subject: Re: [linux-dvb] Chances to see multifrontend code extended to
	saa7134 cards
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <200903201638.09018.roa@libero.it>
References: <200903201638.09018.roa@libero.it>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 01:50:42 +0100
Message-Id: <1237683042.10150.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 20.03.2009, 16:38 +0100 schrieb ROASCIO Paolo: 
> Hello, are there plans to extend multifrontend support to other cards, eg. 
> flydvb trio?
> 
> I'm trying to do so (feling hvr3000 code), but with no success :(
> 
> In the saa7134-dvb.c code there is a FIXME about this topic
> 
> Regards and thank for your great work.
> 
> Roascio Paolo
> 

yes, all agreed that it would be a nice feature to have,
but it did not happen yet.

There is at least a pending patch from Mirek, which allows to select the
frontend per card on insmod with multiple multi frontend cards in the
machine.

http://www.spinics.net/lists/linux-dvb/msg30505.html

A more recent and signed version of this patch is around.

For dynamic frontend switching there was also an early attempt by Eddie
based on Steven's code, but AFAIK there is no working solution yet.

Cheers,
Hermann
 

