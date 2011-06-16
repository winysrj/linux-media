Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1FPHHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 03:07:03 -0400
Message-ID: <4DF9AB93.1040903@gmail.com>
Date: Thu, 16 Jun 2011 09:06:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: DVB_NET help message is useless
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've just updated to 3.0-rc and saw CONFIG_DVB_NET. Hmm, let's see
what's that by asking with '?'. And I got this crap:
================
CONFIG_DVB_NET:

The DVB network support in the DVB core can
optionally be disabled if this
option is set to N.

If unsure say Y.
================
Why do you think this help message is useful? It's clear to
everybody that if one eventually disables it it will be disabled. The
help message should mention _what_ the network support is.

I would send a patch, but I really have no idea what's that good for.

thanks,
-- 
js
