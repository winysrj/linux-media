Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36912 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbBWJHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 04:07:54 -0500
Received: by wesw55 with SMTP id w55so16658369wes.4
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 01:07:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1278760656379117910@unknownmsgid>
References: <002401d04ea1$e5cf1780$b16d4680$@gmail.com>
	<54EA4BB8.2080106@iki.fi>
	<20150222185503.41cbcb1a@recife.lan>
	<1278760656379117910@unknownmsgid>
Date: Mon, 23 Feb 2015 20:07:52 +1100
Message-ID: <CAEsFdVMvrKLtg-AWAeRkQy6_rko8qiu1eZvsMB=hFyYc0XX_gg@mail.gmail.com>
Subject: Re: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45) using media_build
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Gert-Jan van der Stroom <gjstroom@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/23/15, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
> I saw this too, while working with Antti on adding support for
> another rtl* device.
>

I should add how I triggered this
 - build --main-git, make install, halt
 - cold-boot, check modules loaded ok, check /dev/dvb/adapter* exist
 - try to tune with dvb-apps 'scan' and adapter0/tuner0. This is where
the oops occurred.

Vince
