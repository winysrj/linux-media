Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41275 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab0BATXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 14:23:48 -0500
Message-ID: <4B672A32.3060606@s5r6.in-berlin.de>
Date: Mon, 01 Feb 2010 20:23:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Douglas Schilling Landgraf <dougsland@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [hg:v4l-dvb] firedtv: do not DMA-map stack addresses
References: <E1NbzwQ-00009q-Tx@mail.linuxtv.org> <4B672345.6070203@s5r6.in-berlin.de> <4B67276D.1020909@redhat.com>
In-Reply-To: <4B67276D.1020909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Hi Stefan,
[...]
> We've replaced our procedures on our trees recently. Until last year,
> I was applying the patches at -hg and then converting to -git.
> 
> This year, we're just doing the reverse:
[...]

Ah, thanks for the heads-up.  This way my worries are unfounded. :-)
-- 
Stefan Richter
-=====-==-=- --=- ----=
http://arcgraph.de/sr/
