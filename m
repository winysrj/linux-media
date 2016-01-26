Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62975 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966008AbcAZOkV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:40:21 -0500
Date: Tue, 26 Jan 2016 15:39:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>, Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH 12/13] atmel-isi: use union for the fbd (frame buffer
 descriptor)
In-Reply-To: <CAJe_HAdtFCmYKeCgfs9FeE80ckH3+WRfejmc_WOxdxZEntgL8A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1601261538550.28816@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-8-git-send-email-rainyfeeling@gmail.com>
 <Pine.LNX.4.64.1601241931430.16570@axis700.grange>
 <CAJe_HAeTWqaqFHPbLGzbTKV6s2xDxf+Dg8DFc6HAqs03RJFh3g@mail.gmail.com>
 <Pine.LNX.4.64.1601261509120.28816@axis700.grange>
 <CAJe_HAdtFCmYKeCgfs9FeE80ckH3+WRfejmc_WOxdxZEntgL8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Jan 2016, Josh Wu wrote:

> Ok, so for this serial patch, I will drop the abstract interface
> relevant patches, and keep the refactor patch in v2. Thanks.

Yes, please, drop the last 2 patches, and, preferably, the "polling 
instead of IRQ" one too.

Thanks
Guennadi
