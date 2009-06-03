Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46485 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZFCF7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 01:59:16 -0400
Received: by ewy24 with SMTP id 24so9349382ewy.37
        for <linux-media@vger.kernel.org>; Tue, 02 Jun 2009 22:59:17 -0700 (PDT)
Date: Wed, 3 Jun 2009 07:58:13 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: "Soeren D. Schulze" <soeren.d.schulze@gmx.de>
cc: linux-media@vger.kernel.org
Subject: Re: Aspect ratio change does not take effect (DVB-S)
In-Reply-To: <4A259071.3070500@gmx.de>
Message-ID: <alpine.DEB.2.01.0906030752150.5194@ybpnyubfg.ybpnyqbznva>
References: <4A259071.3070500@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moin Sören,

On Tue, 2 Jun 2009, Soeren D. Schulze wrote:

> right now, but there seems to be a little bug:  When watching the TV
> stream using and szap and mplayer, changes in the aspect ratio of the TV
> program do not take effect until mplayer is restarted.  This used to
> work with the former device!

This should be an issue with `mplayer' -- the aspect ratio is
simply part of the datastream sent as an MPEG transport stream
as encoded by the broadcaster.

`mplayer' is known to have this issue with the option `-vc mpeg12'
while in recent mplayer, the default is `-vc ffmpeg12' where this
aspect ratio switching works properly.  Try adding that latter
option and see if it works as expected.


barry bouwsma
