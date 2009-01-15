Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:45766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZAOPoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 10:44:01 -0500
Received: by fg-out-1718.google.com with SMTP id 19so583209fgg.17
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2009 07:43:59 -0800 (PST)
Message-ID: <68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
Date: Thu, 15 Jan 2009 16:43:59 +0100
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: Catimimi <catimimi@libertysurf.fr>
Subject: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
Cc: linux-dvb@linuxtv.org, Linux-media <linux-media@vger.kernel.org>
In-Reply-To: <496DB023.3090402@libertysurf.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>
	 <496DB023.3090402@libertysurf.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 14, 2009 at 10:28 AM, Catimimi <catimimi@libertysurf.fr> wrote:
> try without the ".ko", i.e. instead, use:
>
> modprobe saa716x_hybrid
>
> OK, shame on me, it works but nothing happens.

Of course ;-) The PCI ID of the card is not listed. I happen to have
the same card, you can add the ID to the list but note that the
frontend is not there yet... so the module will load, will print some
something... and that's it.
I have a couple of patches queued and I plan to do some
experimentation in the weekend though ;)

Luca
