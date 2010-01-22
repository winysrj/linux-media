Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0AVUd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 15:33:28 -0500
Message-ID: <4B5A0B92.1020404@infradead.org>
Date: Fri, 22 Jan 2010 18:33:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, JD Louw <jd.louw@mweb.co.za>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] http://mercurial.intuxication.org/hg/v4l-dvb-commits
References: <201001180106.30373.liplianin@me.by>
In-Reply-To: <201001180106.30373.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin wrote:
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

applied on -git, thanks.
