Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbZJ0KXz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 06:23:55 -0400
Date: Tue, 27 Oct 2009 08:23:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Massimo Del Fedele <max@veneto.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Hint request for driver change
Message-ID: <20091027082320.408afe1b@pedra.chehab.org>
In-Reply-To: <4AE57DD5.8030706@veneto.com>
References: <4AE57DD5.8030706@veneto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Oct 2009 11:45:41 +0100
Massimo Del Fedele <max@veneto.com> escreveu:

> Hi,
> 
> I'm trying to support the analog part of Pinnacle PCTV310e, which is an
> ULI M9207 based card; by now I added the support for the digital side
> patching the M920x driver; in order to add the analog part the driver
> should be almost completely rewritten, and it'll take more source files,
> so it should have a separate folder.
> Shall I make a new driver (with different name, as m920x-new) or simply
> remove old one and add the new ?

It is better to not rename it, to avoid confusion.
> 
> Ciao
> 
> Max
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
