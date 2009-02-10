Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay-pt1.poste.it ([62.241.4.164]:49387 "EHLO
	relay-pt1.poste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbZBJO2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 09:28:15 -0500
Received: from nico2.od.loc (93.63.225.36) by relay-pt1.poste.it (7.3.122) (authenticated as Nicola.Sabbi@poste.it)
        id 4990D21200005E8A for linux-media@vger.kernel.org; Tue, 10 Feb 2009 15:07:43 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] mt352 no more working after suspend to disk
Date: Tue, 10 Feb 2009 15:07:39 +0100
References: <200902091233.26086.Nicola.Sabbi@poste.it> <1234217761.2790.15.camel@pc10.localdom.local> <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
In-Reply-To: <c74595dc0902100439j66981bd7tc68b4a3d177abbe3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101507.39610.Nicola.Sabbi@poste.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 February 2009 13:39:09 Alex Betis wrote:
> I've tried to configure my system for suspends and here are my
> conclusions, maybe it will be helpful:
>
> Make sure no applications are using drivers that generally make
> problems after suspend, that means you have to stop/kill them
> before suspending. I use pm-utils script to stop application before
> suspend and start applications after that.
> Make sure you reload the drivers after resume. pm-utils has a
> feature to unload modules before suspend and reload them after
> resume automatically, check the SUSPEND_MODULES configuration. That
> method works fine for my DVB-S drivers, but don't work for my WiFi
> card, so I had to reload the driver after resume in my script.
>
> Hope it helps.
>

it's very useful, thanks a lot
