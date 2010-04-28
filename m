Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34344 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0D1Hpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 03:45:41 -0400
Received: from smtp07.web.de  ( [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 1777E15F20D2F
	for <linux-media@vger.kernel.org>; Wed, 28 Apr 2010 09:45:40 +0200 (CEST)
Received: from [80.88.20.160] (helo=[127.0.0.1])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #4)
	id 1O71xj-0005Mt-00
	for linux-media@vger.kernel.org; Wed, 28 Apr 2010 09:45:40 +0200
Message-ID: <4BD7E7A3.2060101@web.de>
Date: Wed, 28 Apr 2010 09:45:39 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
In-Reply-To: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Guy,
On 11.04.2010 23:18, Guy Martin wrote:

>
> Hi linux-media,
>
> The following patch increases the current limit for the isl6423 chip
> on the TT S2-1600 card. This allows DiSEqC to work with more complex
> and current demanding configurations.
>
> Signed-off-by: Guy Martin<gmsoft@tuxicoman.be>




I am sorry for the late reply.
I advise not to pull this change into the kernel sources.
The card has only been testet with the a maximum current of 515mA.
Anything above is outside the specification for this card.

Kind Regards
  André
