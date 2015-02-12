Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42262 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbbBLLug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 06:50:36 -0500
Date: Thu, 12 Feb 2015 09:50:29 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?Q2ltYsWvcmVr?= <david.cimburek@gmail.com>
Cc: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
Message-ID: <20150212095029.018f63df@recife.lan>
In-Reply-To: <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
	<54D9E14A.5090200@iki.fi>
	<e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
	<CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
	<32c10d8cd2303ed9476db1b68924170a@hardeman.nu>
	<CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Feb 2015 17:41:01 +0100
David Cimbůrek <david.cimburek@gmail.com> escreveu:

Please don't top post. I reordered the messages below in order to get some
sanity.

> 
> 2015-02-11 15:40 GMT+01:00 David Härdeman <david@hardeman.nu>:
> > Can you generate some scancodes before and after commit
> > af3a4a9bbeb00df3e42e77240b4cdac5479812f9?
>
> Let me know what exactly do you want me to do (which commands, which
> traces etc.). I'm not very familiar with the Linux media stuff...

As root, you should run:

	# ir-keytable -r

This will print the scancodes and their key associations.

Also, on what architecture are you testing?

Regards,
Mauro
