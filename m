Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34744 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbcFIPYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 11:24:55 -0400
Date: Thu, 9 Jun 2016 12:24:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
Message-ID: <20160609122449.5cfc16cc@recife.lan>
In-Reply-To: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akihiro,

Em Thu, 09 Jun 2016 21:49:33 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> Hi,
> excuse me for taking up a very old post again,
> but I'd like to know the status of the patch:
>   https://patchwork.linuxtv.org/patch/27922/
> , which provides helper code for defining/loading i2c DVB subdev drivers.
> 
> Was it rejected and 

It was not rejected. It is just that I didn't have time yet to think
about that, and Antti has a different view. 

The thing is that, whatever we do, it should work fine on drivers that
also exposes the tuner via V4L2. One of the reasons is that devices
that also allow the usage for SDR use the V4L2 core for the SDR part.

> each i2c demod/tuner drivers should provide its own version of "attach" code?

Antti took this path, but I don't like it. Lots of duplicated and complex
stuff. Also, some static analyzers refuse to check it (like smatch),
due to its complexity.

> Or is it acceptable (with some modifications) ?

I guess we should discuss a way of doing it that will be acceptable
on existing drivers. Perhaps you should try to do such change for
an hybrid driver like em28xx or cx231xx. There are a few ISDB-T
devices using them. Not sure how easy would be to find one of those
in Japan, though.

> 
> Although not many drivers currently use i2c binding model (and use dvb_attach()),
> but I expect that coming DVB subdev drivers will have a similar attach code,
> including module request/ref-counting, device creation,
> (re-)using i2c_board_info.platformdata to pass around both config parameters
> and the resulting i2c_client* & dvb_frontend*.
> 
> Since I have a plan to split out demod/tuner drivers from pci/pt1 dvb-usb/friio
> integrated drivers (because those share the tc90522 demod driver with pt3, and
> friio also shares the bridge chip with gl861),
> it would be nice if I can use the helper code,
> instead of re-iterating similar "attach" code.

Yeah, sure.

---

An unrelated thing:

I'm now helping to to maintain Kaffeine upstream. I recently added
support for both ISDB-T and DVB-T2. It would be nice if you could
add support there for ISDB-S too.

You can find the kaffeine repository at kde.org. I'm also keeping
an updated copy at linuxtv.org:
	git://anongit.kde.org/kaffeine	(official repo)
	https://git.linuxtv.org/mchehab/kaffeine.git/
	

-- 
Thanks,
Mauro
