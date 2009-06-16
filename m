Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120AbZFPTFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 15:05:07 -0400
Date: Tue, 16 Jun 2009 16:05:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>,
	Timothy Lee <timothy.lee@siriushk.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [Resend] cxusb, d680 dmbth use unified lgs8gxx code
 instead  of lgs8gl5
Message-ID: <20090616160502.43cdb689@pedra.chehab.org>
In-Reply-To: <15ed362e0906101016g13b81df6h1282e3bd410928b2@mail.gmail.com>
References: <15ed362e0906101016g13b81df6h1282e3bd410928b2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Thu, 11 Jun 2009 01:16:13 +0800
David Wong <davidtlwong@gmail.com> escreveu:

> Use unified lgs8gxx frontend instead of reverse engineered lgs8gl5 frontend.
> After this patch, lgs8gl5 frontend could be mark as deprecated.
> Future development should base on unified lgs8gxx frontend.
> 
> Signed-off-by: David T.L. Wong <davidtlwong <at> gmail.com>

Your patch makes sense. Have you tested it with the Magic-Pro DMB-TH usb stick? 

Michael and Timothy,

Can you check if the new frontend module works with the currently supported
devices?



Cheers,
Mauro
