Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55200 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755243AbZLHOBV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 09:01:21 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1260070593.3236.6.camel@pc07.localdom.local>
	<20091206065512.GA14651@core.coreip.homeip.net>
	<4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	<9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	<m3skbn6dv1.fsf@intrepid.localdomain>
	<9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
	<4B1D934E.7030103@redhat.com>
	<20091208042340.GC11147@core.coreip.homeip.net>
	<4B1E3F7D.9070806@redhat.com>
Date: Tue, 08 Dec 2009 15:01:25 +0100
In-Reply-To: <4B1E3F7D.9070806@redhat.com> (Mauro Carvalho Chehab's message of
	"Tue, 08 Dec 2009 09:58:53 -0200")
Message-ID: <m34oo1va2y.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> I don't think we need an userspace interface for the in-kernel
> decoders.

Of course we need it, to set (and probably retrieve) scancode-keycode
mappings. This could probably be, ATM, the existing input layer channel.

> All
> it needs is to enable/disable the protocol decoders, imo via sysfs interface.

This isn't IMHO needed at all. The protocol is enabled when at least one
key using it is configured, otherwise it's disabled. We probably need
some "wildcard" as well, to capture decoded scancodes (through the input
layer).
This is BTW pure optimization, the protocol could stay enabled all the
time, only wasting the cycles.
-- 
Krzysztof Halasa
