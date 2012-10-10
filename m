Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab2JJQXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 12:23:23 -0400
Date: Wed, 10 Oct 2012 13:23:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Robert Morell <rmorell@nvidia.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, <rob@ti.com>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20121010132314.7c7ddaa5@redhat.com>
In-Reply-To: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 10 Oct 2012 08:56:32 -0700
Robert Morell <rmorell@nvidia.com> escreveu:

> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> issue, and not really an interface".  The dma-buf infrastructure is
> explicitly intended as an interface between modules/drivers, so it
> should use EXPORT_SYMBOL instead.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

NAK, as already explained at:

http://lists.freedesktop.org/archives/dri-devel/2012-January/018281.html

Regards,
Mauro
