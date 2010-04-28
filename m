Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:56898 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0D1NS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 09:18:57 -0400
Date: Wed, 28 Apr 2010 15:19:01 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: =?UTF-8?B?QW5kcsOp?= Weidemann <Andre.Weidemann@web.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
Message-ID: <20100428151901.377169bb@zombie>
In-Reply-To: <4BD82A16.5020301@web.de>
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
	<4BD7E7A3.2060101@web.de>
	<20100428103303.2fe4c9ea@zombie>
	<4BD82A16.5020301@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Andre,

On Wed, 28 Apr 2010 14:29:10 +0200
André Weidemann <Andre.Weidemann@web.de> wrote:

> 
> How come there is such a high current drain to drive the switch plus
> the LNBs? From what I understand, the switch should only power one
> LNB at a time. Usually the switch plus the LNB should not drain more
> than 300-400mA, or am I wrong here?

This is what I understood as well. It's cheap switch and LNBs so
that may explain it :)

I don't know how I can measure the current being drained tho. I only
found out that increasing the limit made my setup work.

It may be as well that the isl6423 driver doesnt' set the limit
correctly and configures a lower current limit than what is expected.


> 
> > Is there another way to solve this ?
> > Maybe add a module parameter for people who want to override the
> > default ?
> 
> 
> I think this could be done. Nevertheless, the card would still
> operate outside its specification.


Ok I'll work on a patch in that direction. Probably an integer parameter
with multiple possible values allowing to choose the limit or disable
it and add a big fat warning along the way.

Cheers,
  Guy
