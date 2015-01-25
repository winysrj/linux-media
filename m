Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56842 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbAYRem (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 12:34:42 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so5432740wgh.13
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 09:34:41 -0800 (PST)
From: Federico Vaga <federico.vaga@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@mocean-labs.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 00/15] [media] adv7180: Add support for more chip variants
Date: Sun, 25 Jan 2015 18:34:39 +0100
Message-ID: <1627028.v5bB76TxKR@localhost.localdomain>
In-Reply-To: <1422028354-31891-1-git-send-email-lars@metafoo.de>
References: <1422028354-31891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 January 2015 16:52:19 Lars-Peter Clausen wrote:
> Changes from v1:
> 	* Reserved custom user control range for the fast switch control
> 	* Dropped the free-run mode control patch for now. The controls
> should probably be standardized first, but that is going to be a
> different patch series.
> 
> Original cover letter below:
> 
> The adv7180 is part of a larger family of chips which all implement
> different features from a feature superset. This patch series step
> by step extends the current adv7180 with features from the superset
> that are currently not supported and gradually adding support for
> more variations of the chip.
> 
> The first half of this series contains fixes and cleanups while the
> second half adds new features and support for new chips

I don't have any more the hardware to test the patches but everything 
seems fine to me. My 2 cents acked-by to the whole set of patches:

Acked-by: Federico Vaga <federico.vaga@gmail.com>

-- 
Federico Vaga
