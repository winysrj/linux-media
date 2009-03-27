Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33923 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZC0KHS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:07:18 -0400
Date: Fri, 27 Mar 2009 07:07:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove stream pipe draining code for CXUSB D680 DMB
Message-ID: <20090327070711.14dab3c9@pedra.chehab.org>
In-Reply-To: <15ed362e0903170900y6a71cb71oc65768367a8cfd14@mail.gmail.com>
References: <15ed362e0903170900y6a71cb71oc65768367a8cfd14@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Mar 2009 00:00:10 +0800
David Wong <davidtlwong@gmail.com> wrote:

> CXUSB D680 DMB pipe draining code found to be problematic for new
> kernels (eg. kernel 2.6.27 @ Ubuntu 8.10)

Could you please provide a clearer description? Why is it problematic? Also,
please don't test against a distro-patched kernel, but against vanilla kernel.
Since the patch will appear after 2.6.29, you should test using 2.6.29.

Cheers,
Mauro
