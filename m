Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:47579 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZBJLtU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 06:49:20 -0500
Received: by bwz5 with SMTP id 5so2548097bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 03:49:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0902101024560.1147@ybpnyubfg.ybpnyqbznva>
References: <498E031E.9040503@agnoletti.dk> <498EB8AE.7030706@agnoletti.dk>
	 <19a3b7a80902090737r156bf86egdf791851a0b1c63d@mail.gmail.com>
	 <alpine.DEB.2.01.0902101024560.1147@ybpnyubfg.ybpnyqbznva>
Date: Tue, 10 Feb 2009 12:49:18 +0100
Message-ID: <19a3b7a80902100349k2881715ard4f5d68ccf3fdec8@mail.gmail.com>
Subject: Re: channels.conf file for danish DVB-C provider AFDK (www.afdk.tv)
From: Christoph Pfister <christophpfister@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: Klaus Agnoletti <klaus@agnoletti.dk>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/10 BOUWSMA Barry <freebeer.bouwsma@gmail.com>:
> On Mon, 9 Feb 2009, Christoph Pfister wrote:
>
>> > I sent you the wrong file, it occured to me.. The right one goes here :
>> Added, thanks :)
>
>> > C 386000000 6875000 AUTO QAM64
>
> Looking at all the other dvb-c scanfiles, would it not be most
> likely that the FEC here would be also NONE, like all others,
> regardless of comparable symbol rate or modulation?

Yes; I've fixed this while committing.

> I am ignorant about DVB-C practice, and don't have access to
> the NIT tables of any providers, so I'm happy to be wrong...

EN300429 says that no convolutional coding (= inner fec) shall be used
for dvb-c, so you aren't wrong :)

> barry bouwsma

Christoph
