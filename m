Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbZAOXUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 18:20:36 -0500
Date: Thu, 15 Jan 2009 21:18:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: aaron@bat.id.au
Cc: linux-media@vger.kernel.org
Subject: Re: kernel soft lockup on boot loading cx2388x based DVB-S card
 (TeVii S420)
Message-ID: <20090115211845.330b6011@pedra.chehab.org>
In-Reply-To: <496F94D5.9060206@bat.id.au>
References: <496F1168.3030007@bat.id.au>
	<9e70b14f0901150325g5c02da7dtba7c3cbbd5987fb2@mail.gmail.com>
	<20090115135558.73f61f1b@pedra.chehab.org>
	<496F94D5.9060206@bat.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 16 Jan 2009 06:56:05 +1100
Aaron Theodore <aaron@bat.id.au> wrote:

> Mauro,
> 
> Thanks for the speedy patch!

You should thanks to Andy. He is the author of this patch ;)

> My system can at least boot now, but has issues loading the frontend.
> DVB: Unable to find symbol stv0299_attach()
> DVB: Unable to find symbol stv0288_attach()

It seems that you didn't compile those two frontends.

Cheers,
Mauro
