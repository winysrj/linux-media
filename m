Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:41221 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbZK3UHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 15:07:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: kevin granade <kevin.granade@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>, Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop>
	<2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	<1259537732.5231.11.camel@palomino.walls.org>
	<4B13B2FA.4050600@redhat.com>
	<1259585852.3093.31.camel@palomino.walls.org>
	<4B13C799.4060906@redhat.com>
	<7004b08e0911300814tb474f96s42ec56ca2e43cf7a@mail.gmail.com>
Date: Mon, 30 Nov 2009 21:07:20 +0100
In-Reply-To: <7004b08e0911300814tb474f96s42ec56ca2e43cf7a@mail.gmail.com>
	(kevin granade's message of "Mon, 30 Nov 2009 10:14:19 -0600")
Message-ID: <m3einfvksn.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kevin granade <kevin.granade@gmail.com> writes:

> This idea of the in-kernel decoding being disabled when the raw API is
> opened worries me.

I don't think we need to disable the in-kernel decoding automatically.
That would be rather unfortunate.
-- 
Krzysztof Halasa
