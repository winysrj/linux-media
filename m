Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:57197 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbZGEA2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jul 2009 20:28:35 -0400
Subject: Re: Pinnacle PCTV 310i active antenna
From: hermann pitton <hermann-pitton@arcor.de>
To: Martin Konopka <martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <200907011701.43079.martin.konopka@mknetz.de>
References: <200907011701.43079.martin.konopka@mknetz.de>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 02:18:01 +0200
Message-Id: <1246753081.822.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

Am Mittwoch, den 01.07.2009, 17:01 +0200 schrieb Martin Konopka:
> Hi all,
> 
> my Pinnacle 310i is working well with linux, except for the active antenna 
> that is attached to it. I need it in order to watch some weaker channels. Is 
> there any way to activate the antenna power of this card with recent drivers? 
> The Windows software has an option to do that. 

on which kernel you are currently?

We have some reports, that what was assumed to be support for an
additional LNA on it is broken on 2.6.26 and onwards, IIRC.

There are no previous reports for such an active antenna switch for the
310i I do believe, but Gerd had such an option for the earlier 300i.
(card=50)

If you don't have any further details, like gpio settings reported from
DScaler's regspy, you might try to force the use of that card, nothing
won't work, but eventually you get voltage to the antenna. ("modinfo
saa7134-dvb")

Cheers,
Hermann






