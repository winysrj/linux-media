Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52460 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757189Ab0EKSm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 14:42:28 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media/IR: Add missing include file to rc-map.c
Date: Tue, 11 May 2010 20:42:14 +0200
Cc: linuxppc-dev@ozlabs.org,
	"David =?iso-8859-1?q?H=E4rdeman?=" <david@hardeman.nu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-sh@vger.kernel.org, linux-mips@linux-mips.org,
	linux-m68k@lists.linux-m68k.org
References: <201005051720.22617.PeterHuewe@gmx.de>
In-Reply-To: <201005051720.22617.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005112042.14889.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch 05 Mai 2010 17:20:21 schrieb Peter H�we:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch adds a missing include linux/delay.h to prevent
> build failures[1-5]
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
Any updates on this patch?
Issue still exists with today's linux-next tree

Thanks,
Peter
