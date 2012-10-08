Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:54144 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2JHTX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 15:23:59 -0400
Message-ID: <1349724224.2142.11.camel@exos>
Subject: [git:v4l-dvb/for_v3.7] [media] ds3000: add module parameter to
 force firmware upload
From: =?ISO-8859-1?Q?R=E9mi?= Cardona <remi@gentoo.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Date: Mon, 08 Oct 2012 21:23:44 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

There's indeed a conflict since (as far as I can tell) only patch #6 of
a 7 patch series was applied.

The entire patch series is:
 - http://patchwork.linuxtv.org/patch/14752/
 - http://patchwork.linuxtv.org/patch/14749/
 - http://patchwork.linuxtv.org/patch/14753/
 - http://patchwork.linuxtv.org/patch/14750/
 - http://patchwork.linuxtv.org/patch/14751/
 - http://patchwork.linuxtv.org/patch/14747/ (which is somewhat applied)
 - http://patchwork.linuxtv.org/patch/14748/

Maybe it would be safer to revert patch #6 to cleanly reapply the entire
series?

As for the "force firmware load" patch, the reason for that patch was
that some cards report already having a firmware (despite having been
powered off for a while) when in fact they don't. Reloading the ds3000
module with this new option allows those cards to work properly. Out of
the thousand S470/471 cards we have in production, only a tiny fraction
require this option. That's why I didn't change the default behavior.

Cheers,

Rémi Cardona

