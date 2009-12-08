Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:49592 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbZLHN5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 08:57:15 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
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
Date: Tue, 08 Dec 2009 14:57:15 +0100
In-Reply-To: <20091208042340.GC11147@core.coreip.homeip.net> (Dmitry
	Torokhov's message of "Mon, 7 Dec 2009 20:23:40 -0800")
Message-ID: <m38wddva9w.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> Why woudl we want to do this? Quite often there is a need for "observer"
> that maybe does not act on data but allows capturing it. Single-user
> inetrfaces are PITA.

Lircd can work as a multiplexer. IMHO single-open lirc interface is ok,
though we obviously need simultaneous operation of in-kernel decoders.
-- 
Krzysztof Halasa
