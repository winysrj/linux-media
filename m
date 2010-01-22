Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:52089 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab0AVAfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 19:35:42 -0500
Subject: Re: [PATCH] [RFC] support for fly dvb duo on medion laptop
From: hermann pitton <hermann-pitton@arcor.de>
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
Cc: linux-media@vger.kernel.org, jpnews13@free.fr
In-Reply-To: <4B53FCF2.7000303@gmail.com>
References: <4B53FCF2.7000303@gmail.com>
Content-Type: text/plain
Date: Fri, 22 Jan 2010 01:24:36 +0100
Message-Id: <1264119876.31090.14.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Am Montag, den 18.01.2010, 07:17 +0100 schrieb tomlohave@gmail.com:
> Hi list,
> 
> this patch add support for lifeview fly dvb duo (hybrid card) on medion 
> laptop
> 
> what works : dvb and analogic tv
> not tested :  svideo, composite, radio (i am not the owner of this card)
> 
> this card uses gpio 22 for the mode switch between analogic and dvb
> 
> gpio settings  should change when  svideo , composite an radio will be 
> tested
> 
> 
> Cheers,
> Thomas
> 
> Signed-off-by : Thomas Genty <tomlohave@gmail.com>

Thomas,

if at all, the special on that card should be, and why it did take so
long, that this so called "Duo" has only a single hybrid tuner against
all other "DUOs" previously with dual tuners IMHO.

For what, within the current functions now, you need 
.i2c_gate      = 0x4b ?

Please provide output with i2c_debug=1, already previously asked for,
to get a better idea about this hardware.

Cheers,
Hermann






