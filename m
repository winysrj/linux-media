Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49518 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZLDHZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 02:25:40 -0500
Received: by ewy19 with SMTP id 19so2451666ewy.1
        for <linux-media@vger.kernel.org>; Thu, 03 Dec 2009 23:25:46 -0800 (PST)
Date: Fri, 4 Dec 2009 08:25:38 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Justin Hornsby <justin0hornsby@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Fwd: DVB-APPS patch for uk-WinterHill
In-Reply-To: <751357790912030731g5b09bac8w322f4c1754c3d87d@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0912040752330.16617@ybpnyubfg.ybpnyqbznva>
References: <751357790912030639l6ddcb4bar486fdea6b9aa1a8e@mail.gmail.com> <751357790912030731g5b09bac8w322f4c1754c3d87d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 3 Dec 2009, Justin Hornsby wrote:

> Since 02 Dec 2009 the UK WinterHill transmitter site has been
> broadcasting on different frequencies & in a different mode with
> different modulation.  Channels have been re-arranged to occupy five
> multiplexes and the original BBC 'B' mux is now broadcasting DVB-T2
> for high definition services (which of course cannot yet be tuned by
> mere mortals). The 'WinterHill B' transmitter stopped broadcasting on
> 02 Dec.
> 
> The attached file is a patch to reflect these changes.

> +T 746000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +T 770000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +T 778000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +T 794000000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> +T 801833000 8MHz 2/3 NONE QAM64 8k 1/32 NONE

While the DVB-T2 multiplex (MUX B) cannot be tuned by existing
DVB-T-only devices, and I don't know if the dvb-apps are being
prepared for DVB-T2 (there don't appear to be any of the
known DVB-S2 transponders listed in a couple positions), the
modulation parameters, for future reference, are probably
something like

+# T2 738000000 8MHz 2/3 NONE QAM256 32k 1/128 NONE	#E54 DVB-T2 HD MUX B

There may need to be additional details specified, I'm no expert.
These values are, of course, unconfirmed.

The same would be true for Crystal Palace at 10kW, but on channel
E31, or 554000000, no offset.


barry bouwsma
