Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaHFLHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 07:07:53 -0400
Message-ID: <1407323269.3372.69.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH RESEND 00/15] CODA patches for v3.17
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	kernel@pengutronix.de
Date: Wed, 06 Aug 2014 13:07:49 +0200
In-Reply-To: <0d9001cfb15e$a38f8d90$eaaea8b0$%debski@samsung.com>
References: <1407258020-12078-1-git-send-email-p.zabel@pengutronix.de>
	 <0d9001cfb15e$a38f8d90$eaaea8b0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Am Mittwoch, den 06.08.2014, 12:10 +0200 schrieb Kamil Debski:
> As for warnings, I think it could be corrected in another patch. But
> please do that ASAP. Also it would be really good to correct warnings/error
> in remaining files.

Thanks, I've just sent a patch to address most of those. A few 81-long
lines ending in slashes or semicolons as well as the long codec lists
remain.

regards
Philipp

