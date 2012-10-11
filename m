Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35695 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2JKLZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 07:25:43 -0400
Date: Thu, 11 Oct 2012 12:30:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dave Airlie <airlied@gmail.com>,
	Robert Morell <rmorell@nvidia.com>,
	linaro-mm-sig@lists.linaro.org, rob@ti.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121011123008.4dfa6941@pyramind.ukuu.org.uk>
In-Reply-To: <201210110920.12560.hverkuil@xs4all.nl>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com>
	<20121010221119.6a623417@redhat.com>
	<201210110920.12560.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> As long as dmabuf uses EXPORT_SYMBOL_GPL that is definitely correct. Does your
> statement also hold if dmabuf would use EXPORT_SYMBOL? (Just asking)

Yes. The GPL talks about derivative works (as does copyright law).

Alan
