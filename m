Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:54560 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZBJJb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 04:31:57 -0500
Received: by bwz5 with SMTP id 5so2389865bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 01:31:55 -0800 (PST)
Date: Tue, 10 Feb 2009 10:31:43 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Christoph Pfister <christophpfister@gmail.com>
cc: Klaus Agnoletti <klaus@agnoletti.dk>, linux-media@vger.kernel.org
Subject: Re: channels.conf file for danish DVB-C provider AFDK
 (www.afdk.tv)
In-Reply-To: <19a3b7a80902090737r156bf86egdf791851a0b1c63d@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0902101024560.1147@ybpnyubfg.ybpnyqbznva>
References: <498E031E.9040503@agnoletti.dk> <498EB8AE.7030706@agnoletti.dk> <19a3b7a80902090737r156bf86egdf791851a0b1c63d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Feb 2009, Christoph Pfister wrote:

> > I sent you the wrong file, it occured to me.. The right one goes here :
> Added, thanks :)

> > C 386000000 6875000 AUTO QAM64

Looking at all the other dvb-c scanfiles, would it not be most
likely that the FEC here would be also NONE, like all others,
regardless of comparable symbol rate or modulation?

I am ignorant about DVB-C practice, and don't have access to
the NIT tables of any providers, so I'm happy to be wrong...


barry bouwsma
