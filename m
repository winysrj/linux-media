Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZKWPxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 10:53:17 -0500
Message-ID: <4B0AAFCF.9080407@infradead.org>
Date: Mon, 23 Nov 2009 13:52:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "David T. L. Wong" <davidtlwong@gmail.com>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: [PATCH] AltoBeam ATBM8830 GB20600-2006(DMB-TH) demodulator
References: <4AE58D54.3060906@gmail.com>
In-Reply-To: <4AE58D54.3060906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David T. L. Wong wrote:
> Hi,
> 
>   This patch adds support for Maxim MAX2165 silicon tuner.
> 
>   It is tested on Mygica X8558Pro, which has MAX2165, ATBM8830 and CX23885

Applied, thanks.

Please submit a patch to fix this warning:

/home/v4l/master/v4l/atbm8830.c:166: warning: 'set_agc_config' defined but not used

Cheers,
Mauro.
