Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:55206 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab3KEQHr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 11:07:47 -0500
Date: Tue, 5 Nov 2013 09:07:46 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: lbyang@marvell.com
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: marvell-ccic: drop resource free in driver
 remove
Message-ID: <20131105090746.771d136d@lwn.net>
In-Reply-To: <1383621668.10562.5.camel@younglee-desktop>
References: <1383621668.10562.5.camel@younglee-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Nov 2013 11:21:08 +0800
lbyang <lbyang@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> Date: Tue, 5 Nov 2013 10:18:15 +0800
> Subject: [PATCH] marvell-ccic: drop resource free in driver remove
> 
> The mmp-driver is using devm_* to allocate the resource. The old
> resource release methods are not appropriate here.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
