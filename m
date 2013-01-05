Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab3AENbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jan 2013 08:31:13 -0500
Date: Sat, 5 Jan 2013 11:30:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Patrice Chotard <patrice.chotard@sfr.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Patrice Chotard <patricechotard@free.fr>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] ngene: fix commit
 36a495a336c3fbbb2f4eeed2a94ab6d5be19d186
Message-ID: <20130105113025.7fb2b267@redhat.com>
In-Reply-To: <50E7F4C9.6050607@sfr.fr>
References: <1357358802-17296-1-git-send-email-mchehab@redhat.com>
	<50E7F4C9.6050607@sfr.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 05 Jan 2013 10:39:21 +0100
Patrice Chotard <patrice.chotard@sfr.fr> escreveu:

> Hi Mauro,
> 
> Yes, i confirm that without this patch, tuner_attach_dtt7520x() callback
> was never called, so no tuning was possible.

Thanks for double-checking. Not sure why the original patch got truncated.
Maybe due to some bad conflict solving, or maybe patchwork mangled the
original patch. That sometimes happen when one hunk description has more
than 80-cols and the email got word-wrapped.

Regards,
Mauro
