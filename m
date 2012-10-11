Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35722 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab2JKLdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 07:33:01 -0400
Date: Thu, 11 Oct 2012 12:37:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Robert Morell <rmorell@nvidia.com>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121011123749.28256320@pyramind.ukuu.org.uk>
In-Reply-To: <CAPM=9tzobkzKczMVYpojbwyWCp0wHQmzFfdqJcK1aZMn+XF5iw@mail.gmail.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com>
	<20121010221119.6a623417@redhat.com>
	<CAPM=9tzobkzKczMVYpojbwyWCp0wHQmzFfdqJcK1aZMn+XF5iw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > So, developers implicitly or explicitly copied in this thread that might be
> > considering the usage of dmabuf on proprietary drivers should consider
> > this email as a formal notification of my viewpoint: e. g. that I consider
> > any attempt of using DMABUF or media core/drivers together with proprietary
> > Kernelspace code as a possible GPL infringement.
> 
> Though that does beg the question why you care about this patch :-)

Because my legal advice is to object and remind people who suggest
otherwise. There are specific reasons to do so around estoppel and
willful infringement.

It's not a case of objections anyway - if the _GPL matters then it's a
licensing change so you need the approval of everyone whose code is
involved. At that point I think Nvidia are starting in the wrong place
and need to start with a collection of vendors corporate legal contacts
and then work down the call tree involved.

Alan
