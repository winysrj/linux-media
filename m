Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:25957 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA2Kcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 05:32:31 -0500
Received: by fg-out-1718.google.com with SMTP id 13so913616fge.17
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2009 02:32:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
	 <497A27F7.8020201@to-st.de>
	 <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>
	 <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
	 <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
	 <497EC855.7050301@to-st.de>
	 <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>
	 <497EF972.6090207@to-st.de>
	 <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
Date: Thu, 29 Jan 2009 11:32:29 +0100
Message-ID: <19a3b7a80901290232p3b2dd1a1y42f7276dedfebf43@mail.gmail.com>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-media@vger.kernel.org
Cc: Tobias Stoeber <tobi@to-st.de>,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/1/27 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
<snip>
> I intend to take Christoph's files and massage them to add
> bits of info, reviewing the info by hand, adding missing info
> and generally trying to come up with something like the BW
> file I created.
>
> But I want feedback about that file too, rather than to have
> my changes be rejected after I've done the review and work.
<snip>

I don't mind adding those further bits. They need to be after the main
block in the file, so that they don't get overwritten when those files
are updated e.g. because of a new pdf. They shouldn't be too
excessive, but for example I prefer if you add the Leipzip transponder
to the de-whatever file instead of creating a new de-Leipzig file, so
this point shouldn't cause trouble to you. People don't have to scan
every day, so it doesn't hurt if the scan time is increased by some
seconds.

Thanks,

Christoph

<snip>
