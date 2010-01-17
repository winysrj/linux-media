Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:53799 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab0AQXxk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 18:53:40 -0500
Subject: Re: [PATCH] http://mercurial.intuxication.org/hg/v4l-dvb-commits
From: hermann pitton <hermann-pitton@arcor.de>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Mauro Chehab <mchehab@infradead.org>,
	JD Louw <jd.louw@mweb.co.za>
In-Reply-To: <201001180106.30373.liplianin@me.by>
References: <201001180106.30373.liplianin@me.by>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 00:52:47 +0100
Message-Id: <1263772367.3182.34.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 18.01.2010, 01:06 +0200 schrieb Igor M. Liplianin:
> Mauro,
> 
> Please pull from http://mercurial.intuxication.org/hg/v4l-dvb-commits
> 
> for the following 5 changesets:
> 
> 01/05: Add Support for DVBWorld DVB-S2 PCI 2004D card
> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=199213295c11
> 
> 02/05: Compro S350 GPIO change
> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=84347195a02c
> 
> 03/05: dm1105: connect splitted else-if statements
> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=cd9e72ee99c4
> 
> 04/05: dm1105: use dm1105_dev & dev instead of dm1105dvb
> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=5cb9c8978917
> 
> 05/05: dm1105: use macro for read/write registers
> http://mercurial.intuxication.org/hg/v4l-dvb-commits?cmd=changeset;node=6ed71bd9d32b
> 
> 
>  dvb/dm1105/Kconfig            |    1 
>  dvb/dm1105/dm1105.c           |  539 +++++++++++++++++++++---------------------
>  video/saa7134/saa7134-cards.c |    4 
>  3 files changed, 285 insertions(+), 259 deletions(-)
> 
> Thanks,
> Igor
> 

Igor,

What does that one pin more high on your 02/05 exactly?

Given that we still have boards, pulling all pins high "for fun" and
then work somehow.

It is very wrong to proceed in such a way further.

I would disable such stuff next day and did say so previously.

The last we need are more undocumented gpio pins.

Cheers,
Hermann






