Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64192 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZK2RuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 12:50:05 -0500
MIME-Version: 1.0
In-Reply-To: <1259515703.3284.11.camel@maxim-laptop>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org> <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sun, 29 Nov 2009 09:49:51 -0800
Message-ID: <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Walls <awalls@radix.net>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 9:28 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> This has zero advantages besides good developer feeling that "My system
> has one less daemon..."

Surely it's clear that having an unnecessary daemon is introducing
another point of failure? Reducing complexity is not just its own
reward in a 'Developer Feel Good' way.

If decoding can *only* be sanely handled in user-space, that's one
thing. If it can be handled in kernel, then that would be better.
