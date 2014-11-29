Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54381 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaK2Nnk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 08:43:40 -0500
Received: by mail-pd0-f181.google.com with SMTP id v10so2796986pde.12
        for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 05:43:39 -0800 (PST)
Message-ID: <5479CD87.6060608@gmail.com>
Date: Sat, 29 Nov 2014 22:43:35 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: David Liontooth <lionteeth@cogweb.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ISDB caption support
References: <5478D31E.5000402@cogweb.net> <CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com> <547934E1.3050609@cogweb.net>
In-Reply-To: <547934E1.3050609@cogweb.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I realize captions is an application-layer function, and intend to work
> with the CCExtractor team. Do any other applications already have ISDB
> caption support?

there's a mplayer patch for subtitle support:
https://github.com/0p1pp1/mplayer/commit/6debc831d34cad98d1b251920fbdb48f74a880df

It translates subtitle stream PES to ASS, but is is for ISDB-T/Japan.
Subtitling in ISDB-T depends heavily on the control sequences
of the original character encoding (ARIB STD-B24),
so I'm afraid that (at least) PES format is very different in ISDB-Tb. 

regards,
akihiro
