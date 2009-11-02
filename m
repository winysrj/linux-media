Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:40737 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbZKBPO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 10:14:29 -0500
Received: by gxk4 with SMTP id 4so4263645gxk.8
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 07:14:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000001ca5bc4$10493030$9b65a8c0@Sensysserver.local>
References: <000001ca5bc4$10493030$9b65a8c0@Sensysserver.local>
Date: Mon, 2 Nov 2009 16:14:32 +0100
Message-ID: <c4e36d110911020714s16d5599h14b30ce99181a042@mail.gmail.com>
Subject: Re: [linux-dvb] NOVA-TD exeriences?
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/11/2 Magnus Hörlin <magnus@alefors.se>:
> Hi. I would be happy to hear if anyone has tried both the NOVA-TD and the
> NOVA-T. The NOVA-T has always worked perfectly here but I would like to know
> if the -TD will do the job of two NOVA-T's. And there also seems to be a new
> version out with two small antenna connectors instead of the previous
> configuration. Anyone tried it? Does it come with an antenna adaptor cable?
> http://www.hauppauge.de/de/pics/novatdstick_top.jpg
> Thankful for any info.

Well I've this usb stick with these two small connectors - and it runs
just fine.

Though I think there is some problem with suspend/resume recently
(2.6.32-rc5)  and it needs some inspection.

But it works just fine for dual dvb-t viewing.

And yes - it contains two small antennas with small connectors and
one adapter for normal antenna - i.e. 1 antenna input goes to 2 small
antenna connectors.


Zdenek
