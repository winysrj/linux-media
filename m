Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:55589 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab0J1TSA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 15:18:00 -0400
Date: Thu, 28 Oct 2010 13:17:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] via-camera: fix OLPC serial port check
Message-ID: <20101028131758.7b929095@bike.lwn.net>
In-Reply-To: <AANLkTim25tO-WSXeu8UN408+794qe5=3XqJc+5hy3aiM@mail.gmail.com>
References: <20101027190228.3C87D9D401B@zog.reactivated.net>
	<20101028130806.66bd5b91@bike.lwn.net>
	<AANLkTim25tO-WSXeu8UN408+794qe5=3XqJc+5hy3aiM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 28 Oct 2010 20:14:35 +0100
Daniel Drake <dsd@laptop.org> wrote:

> I think the compiler might be smart enough to optimize it out.
> When CONFIG_OLPC=n, machine_is_olpc() compiles down to a simple "no".
> Hopefully that then makes all of that code candidate for dead code
> elimination by the compiler.

Ah, yes, good point.  It certainly *should* work that way, anyway...

jon
