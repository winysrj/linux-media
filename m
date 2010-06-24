Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FXT3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 15:29:08 -0400
Received: by bwz7 with SMTP id 7so365227bwz.19
        for <linux-media@vger.kernel.org>; Thu, 24 Jun 2010 12:29:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim4ZxnPGxJZJPf3UdhFBhZoSfxdfx6MzJb3Y3Qp@mail.gmail.com>
References: <AANLkTim4ZxnPGxJZJPf3UdhFBhZoSfxdfx6MzJb3Y3Qp@mail.gmail.com>
Date: Thu, 24 Jun 2010 21:29:07 +0200
Message-ID: <AANLkTikun4SyEVINPVltA8tC03Nlm8iU0qVVTM-zIWaK@mail.gmail.com>
Subject: Re: update for util/scan/dvb-t/fr-Brest + ask
From: Christoph Pfister <christophpfister@gmail.com>
To: Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/6/17 Johann Ollivier Lapeyre <johann.ollivierlapeyre@gmail.com>:
> Hi,
>
> Last week, the France/Bretagne removed analog frequencies and changed
> DVB frequencies. Severals files has to changes (Rennes, Brest, ...),
> here is the one i made & tested for util/scan/dvb-t/fr-Brest :
>
> # Brest - France
> # Emetteur du Roch Tredudon
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 546000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 578000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 586000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 618000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 650000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 770000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
>
> ( frequencies with TV Channels).

Committed, thanks.

> But perhaps you could include all channel to be ready to futurs
> changes, i don't know. All frequencies:

In this case you could just use autoscan.

Christoph


> # Brest - France
> # Emetteur du Roch Tredudon
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 466000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 474000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 482000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 490000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 498000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 506000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 514000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 522000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 530000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 538000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 546000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 554000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 562000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 570000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 578000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 586000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 594000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 602000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 610000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 618000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 626000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 634000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 642000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 650000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 658000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 666000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 674000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 682000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 690000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 698000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 706000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 714000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 722000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 730000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 738000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 746000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 754000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 762000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 770000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
> T 778000000 8MHz AUTO NONE AUTO AUTO AUTO NONE
>
>
> And thanks a lot for your job !
