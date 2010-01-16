Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62133 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0APP7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 10:59:21 -0500
Received: by bwz27 with SMTP id 27so1246352bwz.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 07:59:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262869311.16785.5.camel@benoit-desktop>
References: <1262869311.16785.5.camel@benoit-desktop>
Date: Sat, 16 Jan 2010 16:59:20 +0100
Message-ID: <19a3b7a81001160759y682389f2v21f2742678e4f3cc@mail.gmail.com>
Subject: Re: New init DVB-T file for fr-Saint-Jorioz-1 (Saint-Germain /
	Talloire)]
From: Christoph Pfister <christophpfister@gmail.com>
To: =?UTF-8?Q?Beno=C3=AEt_Pourre?= <benoit.pourre@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2010/1/7 Benoît Pourre <benoit.pourre@gmail.com>:
> Hello,
>
> Here is my complete init dvb file for the new location fr-Saint-Jorioz-1
> (Saint-Germain / Talloire).
>
> Best regards.
>
> Benoît

> T       -10 8MHz AUTO NONE    QAM64   8k 1/32 NONE

^ this is nonsense (not your fault)

> T 490000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO	# F
> T 514000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO	# F
> T 538000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO	# F
> T 714000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO	# F
> T 738000000 8MHz AUTO AUTO     AUTO AUTO AUTO AUTO

^ transponders with all values set to AUTO are not very useful, sorry
(people using this file might as well use auto scan)

Christoph
