Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57806 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaHKNWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 09:22:13 -0400
Date: Mon, 11 Aug 2014 06:58:37 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] [media] ov7670: Include media/v4l2-image-sizes.h
Message-ID: <20140811065837.36a8572a@lwn.net>
In-Reply-To: <1407563920.5172.0.camel@phoenix>
References: <1407563920.5172.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 09 Aug 2014 13:58:40 +0800
Axel Lin <axel.lin@ingics.com> wrote:

> So we can remove the same defines in the driver code.

I always wanted a file like that (but, obviously, was too lazy to actually
create it).

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
