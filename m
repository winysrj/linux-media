Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38028 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab0D3RwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:52:20 -0400
Received: by bwz19 with SMTP id 19so286161bwz.21
        for <linux-media@vger.kernel.org>; Fri, 30 Apr 2010 10:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j2if20a597a1004020923oadaaac4co9ec6b4094490e88a@mail.gmail.com>
References: <j2if20a597a1004020923oadaaac4co9ec6b4094490e88a@mail.gmail.com>
Date: Thu, 29 Apr 2010 19:32:54 +0200
Message-ID: <p2i19a3b7a81004291032s8f0b453fl58b149896a0c30a1@mail.gmail.com>
Subject: Re: [linux-dvb] Debian Bug#564204: dvb-apps: fr-Nantes should have an
	added offset of 167000 for each value
From: Christoph Pfister <christophpfister@gmail.com>
To: Jeremy Guitton <debotux@gmail.com>
Cc: 564204@bugs.debian.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/4/2 Jeremy Guitton <debotux@gmail.com>:
<snip>
> Like #478020 for fr-Paris, fr-Nantes should have an added offset of
> 167000 for each value. The file should look like that to be able to use
> "scan" on it:
>
> # Nantes - France
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 498167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 506167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 522167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 530167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 658167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> T 802167000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
<snip>

Updated, thanks!

Christoph
