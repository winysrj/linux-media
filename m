Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39585 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbdFFT66 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 15:58:58 -0400
Date: Tue, 6 Jun 2017 16:58:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] [PATCH] saa7164: Bug - Double fetch PCIe access
 condition
Message-ID: <20170606165847.3b3cbe19@vento.lan>
In-Reply-To: <CALzAhNX3ncfu09k2ZaZ+5x28uNhy2kSCw4swatU89N+kJ=2PoQ@mail.gmail.com>
References: <CALzAhNX3ncfu09k2ZaZ+5x28uNhy2kSCw4swatU89N+kJ=2PoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Jun 2017 09:19:35 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> Mauro,
> 
> A single commit.
> 
> https://github.com/stoth68000/media-tree/commit/354dd3924a2e43806774953de536257548b5002c
> 
> This pull request addresses the concern raised by Pengfei Wang
> <wpengfeinudt@gmail.com> via
> https://bugzilla.kernel.org/show_bug.cgi?id=195559
> 
> I've tested this patch with two different SAA7164 based cards in both
> analog and digital television modes for US and Europe, no regressions
> were found.
> 
> $ git diff --stat master
>  drivers/media/pci/saa7164/saa7164-bus.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Applied, thanks!

Next time, please either send as a patch or use the command:

	$ git request-pull

As otherwise I may miss it, as patchwork won't get it.

Regards,
Mauro
