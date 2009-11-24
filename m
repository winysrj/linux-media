Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsender.it.unideb.hu ([193.6.138.90]:47263 "EHLO
	mailsender.it.unideb.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830AbZKXLLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 06:11:18 -0500
Subject: Re: Video extractor?
From: Levente =?ISO-8859-1?Q?Nov=E1k?= <lnovak@dragon.unideb.hu>
To: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
Cc: Juhana Sadeharju <kouhia@nic.funet.fi>, linux-media@vger.kernel.org
In-Reply-To: <c85228170911231441v233a095fq266753e94e2c6458@mail.gmail.com>
References: <S77688AbZKWPYcKKXeQ/20091123152432Z+8457@nic.funet.fi>
	 <c85228170911231441v233a095fq266753e94e2c6458@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 11:38:12 +0100
Message-Id: <1259059092.20949.12.camel@novak.chem.klte.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009. 11. 23, hétfő keltezéssel 20.41-kor Wellington Terumi Uemura ezt
írta:

> Since I got to know Linux OS (your linux OS brand here) back in 1996
> not much was made so you can switch 100% from windows to linux. Yes,
> today linux is much more easy to handle for a normal user, back in the
> days we had to compile the kernel at the installation process, compile
> your drivers and so on, but even today if you need some specific tools
> in Linux that is trivial in Windows like virtualdub, avisynth (others)
> you don't have it.
> 

There are plenty of good video tools under Linux.

> Make a dual boot installation to use windows based tools to do your basic work.
> 
> 2009/11/23 Juhana Sadeharju <kouhia@nic.funet.fi>:
> >
> > Is there a video editor which can be used to extract pieces
> > of video to file? Two of the editors in Ubuntu failed to load
> > the DVB TS streamfile, Kino converted it to DV format, and slowly.
> > That is bad. And I don't know what DV format is, and how to convert
> > it losslessly back to DVB TS format.

You are using the wrong tool. Kino is for DV (Sony miniDV camcorder
format) only.

> > In any case, I got feeling basic tools are still missing from
> > Linux media software catalogue. I need the tool in my projects.
> >

Have you tried kdenlive, cinelerra, avidemux, gopchop, or dvbcut? (These
latter two are made exactly for cutting out from MPEG-PS or MPEG-TS
streams while maintaining the audio/video sync.) I recommend dvbcut, it
works well for me.

Levente



