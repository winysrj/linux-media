Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59289 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcBQCde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 21:33:34 -0500
Date: Wed, 17 Feb 2016 02:33:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] atmel-isi: fix IS_ERR_VALUE usage
Message-ID: <20160217023328.GI17997@ZenIV.linux.org.uk>
References: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
 <1455546925-22119-5-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1455546925-22119-5-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 15, 2016 at 03:35:22PM +0100, Andrzej Hajda wrote:
> IS_ERR_VALUE macro should be used only with unsigned long type.
> For signed types comparison 'ret < 0' should be used.
> 
> The patch follows conclusion from discussion on LKML [1][2].

ACK
