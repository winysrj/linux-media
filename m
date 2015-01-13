Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54596 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbbAMQfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 11:35:15 -0500
Message-ID: <54B5493C.5030102@iki.fi>
Date: Tue, 13 Jan 2015 18:35:08 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 1/7] tuner-core: properly initialize media controller
 subdev
References: <cover.1420315245.git.mchehab@osg.samsung.com>	<4ff2de5fce002a6f6f87993440f45e0f198c57cb.1420315245.git.mchehab@osg.samsung.com>	<3223125.oELRrvBOf4@avalon> <20150111122553.76394653@recife.lan>
In-Reply-To: <20150111122553.76394653@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/11/2015 04:25 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 11 Jan 2015 16:02:41 +0200
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

>> I'm not too familiar with tuners, do they all have a single output only and no
>> input ?
>
> They have an input: the antenna connector. However, I don't see any need
> to map it for most tuners, as there's generally just one input, hardwired
> into the tuner chip.
>
> There are some hardware with 2 antenna connectors, but for different
> functions (FM and TV). They're selected automatically when the V4L2
> driver switches between FM and TV.
>
> In any case, the tuner-core doesn't provide any way to select the
> antenna input.
>
> So, if a driver would need to select the input, it would either need
> to not use tuner-core or some patch will be required to add such
> functionality inside tuner-core.

Tuner has antenna as a input and output is intermediate frequency or 
baseband (IF/BB (zero-IF)).

I think most modern silicon tuners actually has more than one physical 
antenna inputs - but those are left unused or same physical antenna 
connector is wired to all those inputs.

Sooner or later there will be receiver having multiple antenna 
connectors which are selectable by software. So let it be at least 
option easy to add later.

regards
Antti

-- 
http://palosaari.fi/
