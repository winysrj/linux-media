Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab0G1RKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:10:04 -0400
Message-ID: <4C506472.3080506@redhat.com>
Date: Wed, 28 Jul 2010 14:10:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 8/9] IR: Add ENE input driver.
References: <1280330051-27732-1-git-send-email-maximlevitsky@gmail.com> <1280330051-27732-9-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1280330051-27732-9-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 12:14, Maxim Levitsky escreveu:
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Please, instead of patch 9/9, do a patch moving ENE driver from staging into 
drivers/media/IR, and then a patch porting it into rc-core. This will allow us
to better understand what were done to convert it to rc-core, being an example
for others that may work on porting the other drivers to rc-core.

Cheers,
Mauro.

