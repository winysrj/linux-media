Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:57716 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbGEQow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jul 2015 12:44:52 -0400
Date: Sun, 5 Jul 2015 18:44:49 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Peter Fassberg <pf@leissner.se>
Cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
Message-ID: <20150705184449.0017f114@lappi3.parrot.biz>
In-Reply-To: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sat, 4 Jul 2015 13:07:17 +0200 (SST)
Peter Fassberg <pf@leissner.se> wrote:

> Hi all!
> 
> I'm trying to get PCTV TripleStick 292e working in a Raspberry Pi B+
> environment.
> 
> I have no problem getting DVB-T to work, but I can't tune to any
> DVB-T2 channels. I have tried with three different kernels: 3.18.11,
> 3.18.16 and 4.0.6.  Same problem.  I also cloned the media_build
> under 4.0.6 to no avail.
> 
> The same physical stick works perfectly with DVB-T2 in an Intel
> platform using kernel 3.16.0.

Your Intel platform is 64bit. I don't know the TripleStick nor the SI or
the EM28xx-driver but _maybe_ there is a problem with it on 32-bit
platforms. A long shot, I know, but you'll never know.

--
Patrick.
