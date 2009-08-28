Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40771 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZH1MgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 08:36:09 -0400
Date: Fri, 28 Aug 2009 09:36:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Peter Brouwer <pb.maillists@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?ISO-8859-1?B?U3lyauRs?= =?ISO-8859-1?B?5A==?=
	<syrjala@sci.fi>, Linux Input <linux-input@vger.kernel.org>,
	Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090828093604.424a8eed@pedra.chehab.org>
In-Reply-To: <4A97ADCD.6060200@googlemail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	<20090828004628.06f34d12@pedra.chehab.org>
	<20090828041459.67c1499a@pedra.chehab.org>
	<4A97ADCD.6060200@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Aug 2009 11:13:33 +0100
Peter Brouwer <pb.maillists@googlemail.com> escreveu:

> 
> Would like to add one more dimension to the discussion.
> 
> The situation of having multiple DVB type boards in one system.
> 
> Using one remote would be enough to control the system. So we should have a 
> mechanism/kernel config option, to enable/disable an IR device on a board.
> For multiple boards of the same type, enable the first and disable any 
> subsequently detected boards.

I agree that this feature would be useful, but we shouldn't assume that the
user doesn't expect to have more than one IR working. With USB keyboard/mouse
and computers supporting video cards with multiple heads, it is possible to use
one server to handle several virtual machines with their own keyboard, mouse,
video and IR (in fact, I've already seen similar scenarios on some expositions).

Anyway, for this to happen with all drivers, the better way would be to use a
common IR framework.



Cheers,
Mauro
