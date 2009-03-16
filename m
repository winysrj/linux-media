Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:17303 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZCPSc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:32:58 -0400
Received: by fk-out-0910.google.com with SMTP id f33so1488593fkf.5
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 11:32:54 -0700 (PDT)
Message-ID: <49BE9B50.5050506@gmail.com>
Date: Mon, 16 Mar 2009 19:32:48 +0100
From: Benjamin Zores <benjamin.zores@gmail.com>
Reply-To: benjamin.zores@gmail.com
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: Benjamin Zores <benjamin.zores@gmail.com>,
	linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

BOUWSMA Barry wrote:

> First, every frequency is given an offset from the nominal centre
> frequency of the 8MHz envelope.  I am aware this is common in the
> UK where the switchover is happening gradually so as not to
> interfere with adjacent analogue services, and I also know that
> last I checked, the number of french analogue services I could
> receive weakly had dropped, but at least one was still visible.

These were discovered through w_scan application.

> +T 482167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> 
> I have some recent german Bundesnetzagentur (BNetzA) data, and
> this lists the Nordheim frequencies as
> TVDRStrasbourg                    22   482.000KT
> that is, no offset.

I've read on some page from linuxtv wiki that most of transponders files
needed to be added a 167k offset to work.
Honnestly, it works fine with or without this offset for me.

> +T 570167000 8MHz 2/3 NONE QAM16 8k 1/32 NONE
> 
> This frequency looks very suspicious, as it is (without
> the offset) in use with different parameters by a Single-
> Frequency Network along the Hoch- and Oberrhein, including
> a non-directional 50kW tower at the Totenkopf, Vogtsburg/
> Kaiserstuhl, and somewhat closer at Baden Baden Fremserberg,
> which should blast well into much of the Alsace.  Certainly,
> when I was within walking distance of the Totenkopf but
> within the Rhein valley, I had no problems receiving the
> analogue french broadcasts with a simple indoor antenna.
> These may have been from Colmar, much closer.

I do receive both French and German channels.
So obviously, some come from Nordheim antenna while others
are likely to come from Germany but I don't know how to differenciate these.

I have some table frequency list here:
http://www.tvnt.net/V2/pages/342/medias/pro-bo-doc-tk-frequences_tnt.pdf

See the "Canal" array, page 20 for "Strasbourg".
I don't know how to determine transponders frequencies from this list.

Ben
