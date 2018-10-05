Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbeJEW34 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 18:29:56 -0400
Date: Fri, 5 Oct 2018 12:30:37 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stefan =?UTF-8?B?QnLDvG5z?= <stefan.bruens@rwth-aachen.de>
Subject: Re: [PATCH RESEND] Revert "media: dvbsky: use just one mutex for
 serializing device R/W ops"
Message-ID: <20181005123037.64b9f24c@coco.lan>
In-Reply-To: <4333a303-c06b-e641-20de-7b51058e0287@googlemail.com>
References: <d0042374-b508-7cb2-cb93-5f4a1951ec95@googlemail.com>
        <b39aa816886da2b57ecdfad85f06b4940bcb5d02.1538749539.git.mchehab+samsung@kernel.org>
        <4333a303-c06b-e641-20de-7b51058e0287@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 5 Oct 2018 16:34:28 +0200
Oliver Freyermuth <o.freyermuth@googlemail.com> escreveu:

> Dear Mauro,
> 
> thanks! Just to clarify, the issue I described in https://bugzilla.kernel.org/show_bug.cgi?id=199323
> was on an Intel x86_64 system, with an onboard USB Controller handled by the standard xhci driver,
> so this does not affect RPi alone. 

That's weird... I tested such patch here before applying (and it was
tested by someone else, as far as I know), and it worked fine.

Perhaps the x86 bug is related to some recent changes at the USB
subsystem. Dunno.

Anyway, patch revert applied upstream.

Regards,
Mauro
