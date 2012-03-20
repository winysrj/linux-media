Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56079 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2CTNI4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:08:56 -0400
Date: Tue, 20 Mar 2012 07:08:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [Q] ov7670: green line in VGA resolution
Message-ID: <20120320070855.676feeba@dt>
In-Reply-To: <CACKLOr0PU40+fc=YDKq-LcTKGkfXsZT4G52RTB8fzu=8sSqRaw@mail.gmail.com>
References: <CACKLOr28ECqBhTkMsd=6vSOMPZk2DgbRFWZOZXH39omQRP0fcA@mail.gmail.com>
	<20120319114441.5c64574f@dt>
	<CACKLOr0PU40+fc=YDKq-LcTKGkfXsZT4G52RTB8fzu=8sSqRaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Mar 2012 09:42:55 +0100
javier Martin <javier.martin@vista-silicon.com> wrote:

> So, what I understand is that you see the same green line and, due to
> the lack of documentation for the ov7670, you solve it adjusting de
> video window in the Marvell controller driver. Could you confirm this?

I wrote that driver quite a few years ago and do not remember the exact
process.  I do remember, though, that making new modes work generally
involved a lot of tweaking on both sides.

jon


Jonathan Corbet / LWN.net / corbet@lwn.net
