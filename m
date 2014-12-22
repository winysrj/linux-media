Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:50411 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaLVOMf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Dec 2014 09:12:35 -0500
Received: by mail-yh0-f52.google.com with SMTP id z6so2292683yhz.25
        for <linux-media@vger.kernel.org>; Mon, 22 Dec 2014 06:12:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54982454.6040306@iki.fi>
References: <1419191964-29833-1-git-send-email-zzam@gentoo.org>
	<54972866.3030101@gentoo.org>
	<20141222112550.5f5e80c7@concha.lan.sisa.samsung.com>
	<54981E79.5090601@gentoo.org>
	<54982454.6040306@iki.fi>
Date: Mon, 22 Dec 2014 09:12:34 -0500
Message-ID: <CALzAhNWnJCwKGp5kc278TH1T=hsk=d3eji6zdgjdpzm_0oYBjg@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Split Hauppauge WinTV Starburst from HVR4400
 card entry
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> In my understanding Starburst is HVR-4400, but only satellite tuner is
> installed to PCB - whilst terrestrial/cable is left out.

I went back through my engineering notes from my Hauppauge engineering
days, this statement is correct.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
