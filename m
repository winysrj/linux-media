Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:34108 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbcBDQg7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 11:36:59 -0500
Received: by mail-ig0-f194.google.com with SMTP id ik10so4513907igb.1
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2016 08:36:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2612145d4e46ee78d7e1c38386c43d9c3f597600.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
	<2612145d4e46ee78d7e1c38386c43d9c3f597600.1454600641.git.mchehab@osg.samsung.com>
Date: Thu, 4 Feb 2016 11:36:58 -0500
Message-ID: <CAOcJUbwyu173s5NoAC0tsB1ZNZ9xqy3nuTtXt7AMJEovCGf3Ag@mail.gmail.com>
Subject: Re: [PATCH 6/7] [media] dvb_frontend: pass the props cache to
 get_frontend() as arg
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Jemma Denson <jdenson@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Sergey Kozlov <serjk@netup.ru>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jiri Kosina <jkosina@suse.com>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Fred Richter <frichter@hauppauge.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Abhilash Jindal <klock.android@gmail.com>,
	Peter Griffin <peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 4, 2016 at 10:57 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Instead of using the DTV properties cache directly, pass the get
> frontend data as an argument. For now, everything should remain
> the same, but the next patch will prevent get_frontend to
> affect the global cache.
>
> This is needed because several drivers don't care enough to only
> change the properties if locked. Due to that, calling
> G_PROPERTY before locking on those drivers will make them to
> never lock. Ok, those drivers are crap and should never be
> merged like that, but the core should not rely that the drivers
> would be doing the right thing.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
