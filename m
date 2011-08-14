Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42257 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1HNNT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 09:19:57 -0400
Received: by wyg24 with SMTP id 24so3015513wyg.19
        for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 06:19:56 -0700 (PDT)
Subject: Re: TerraTec T6 Dual Tuner Stick initial support available
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
In-Reply-To: <4E47B0E9.2030801@iki.fi>
References: <201108140930.07873.hfvogt@gmx.net>  <4E47B0E9.2030801@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Aug 2011 14:19:46 +0100
Message-ID: <1313327986.2744.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-08-14 at 14:26 +0300, Antti Palosaari wrote:
> On 08/14/2011 10:30 AM, Hans-Frieder Vogt wrote:
> > just wanted to inform you that I got the TerraTec Dual DVB-T Stick working 
> > using a slightly patched driver from Afatech. Please see the wiki entry
> > http://www.linuxtv.org/wiki/index.php/TerraTec_T6_Dual_DVB-T_Stick
> > Currently both tuners work, but the remote doesn't.
> > 
> > This driver is only supposed to be a temporary solution until I have 
> > integrated the bits into Antti's af9035 driver, see
> > http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
> > dvb-af9035.patch
> > http://openee.googlecode.com/svn-history/r137/trunk/recipes/v4l-dvb/files/v4l-
> > dvb-af9033.patch
> 
> Situation of my AF9035 & AF9033 driver is and have been years totally
> frozen, I given it up since I never got permission from ITE to push it
> Kernel and firmware distribution. Thus I left it. I have had in mind to
> write out all vendor code (not much code I think) to get rid of
> copyrights and do what I want - but never had enough time.
> 
> Due to that I am not going to work my AF9035 + AF9033 unless something
> changes dramatically at least now when there is other drivers.
The situation has not got any better by ITE submitting a clearly Windows
patched driver earlier this month, which does not work in dual mode, at
least with IT9137 it doesn't.

I wrote a driver for the IT9137, but have lost interest to develop it
any further.

Regards

Malcolm 

