Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41145 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab0BASyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 13:54:14 -0500
Message-ID: <4B672345.6070203@s5r6.in-berlin.de>
Date: Mon, 01 Feb 2010 19:53:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [hg:v4l-dvb] firedtv: do not DMA-map stack addresses
References: <E1NbzwQ-00009q-Tx@mail.linuxtv.org>
In-Reply-To: <E1NbzwQ-00009q-Tx@mail.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The patch number 14077 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
[...]
> [dougsland@redhat.com: patch backported to hg tree]

I don't know how you prefer to organize your trees, but:
In this particular case it could have been simpler if you had first
inserted an hg:v4l-dvb only patch which simply reverts the divergence of
firedtv in hg from mainline git.

This divergence was introduced by some kind of hg->git export mistake.
That's not a big issue but it may cause another mistake when the next
hg->git export happens.
-- 
Stefan Richter
-=====-==-=- --=- ----=
http://arcgraph.de/sr/
