Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbZC0LSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 07:18:40 -0400
Date: Fri, 27 Mar 2009 08:18:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: linux-media@vger.kernel.org
Cc: no_bs@web.de, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Patch: IR-support for Tevii s460
Message-ID: <20090327081831.380db0a3@pedra.chehab.org>
In-Reply-To: <1619240981@web.de>
References: <1619240981@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Mar 2009 20:02:40 +0100
Bernd Strauﬂ <no_bs@web.de> wrote:

> The remote control which comes with this card doesn't work out of the box.
> This patch changes that. Works with LIRC and /dev/input/eventX.

Why people insist on sending patches to the legacy list? If you don't send the
patch to linux-media@vger.kernel.org, it is likely that nobody will catch.
Patchwork doesn't handle patches on this list.

Cheers,
Mauro
