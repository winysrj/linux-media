Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZC0KEc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:04:32 -0400
Date: Fri, 27 Mar 2009 07:04:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] CXUSB D680 DMB using unified lgs8gxx driver
Message-ID: <20090327070424.1ea257c9@pedra.chehab.org>
In-Reply-To: <15ed362e0903170856g17e5fa47i9fb3ac927c2d25a5@mail.gmail.com>
References: <15ed362e0903170856g17e5fa47i9fb3ac927c2d25a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Mar 2009 23:56:57 +0800
David Wong <davidtlwong@gmail.com> wrote:

> This patch replace the use of lgs8gl5 driver by unified lgs8gxx driver, for
> CXUSB D680 DMB (MagicPro ProHDTV)
> 
> David T.L. Wong

Patch is ok. However, as it depends on the previous one, I'll mark it as RFC. When you submit back the previous patch (plus the API patch), re-submit the other patches on this series.

Also, since those patches are dependent, please number they at the subject, as:

[PATCH 01/05] 
...
[PATCH 05/05] 

This allows us to be sure about the proper patch order to apply.

Cheers,
Mauro
