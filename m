Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:60351 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbZKPKCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 05:02:22 -0500
From: Julian Scheel <julian@jusst.de>
To: Folnin Vi <folnin@gmail.com>
Subject: Re: Mystique SaTiX DVB-S2 [KNC ONE] - Kernel panic
Date: Mon, 16 Nov 2009 10:51:26 +0100
Cc: linux-media@vger.kernel.org
References: <4AC0EB67.5010002@gmail.com>
In-Reply-To: <4AC0EB67.5010002@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911161051.26650.julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 28. September 2009 18:59:19 schrieb Folnin Vi:
> I am having problems with Mystique SaTiX DVB-S2 card.
> 
> Using the latest drivers from linuxtv.org.
> 
> Every time I use the card kernel panic occurs.
> For example when trying to scan transponder.
> 
> Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
> in: fb40d12f

Have you gained any progress with this problem? - Actually I think this only 
happens when the v4l-dvb is compiled with gcc 4.4 - using gcc 4.3 works around 
it. Can you confirm this?
Besides I am quite clueless what's causing this issue so far.

-Julian
