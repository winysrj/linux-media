Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:37636 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbbD3Q54 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 12:57:56 -0400
Date: Thu, 30 Apr 2015 10:59:10 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 08/27] ov7670: check read error also for REG_AECHH on
 ov7670_s_exp()
Message-ID: <20150430105910.1c12af50@lwn.net>
In-Reply-To: <ff849563e43277ddf2cf83309963c74ca4428f7d.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
	<ff849563e43277ddf2cf83309963c74ca4428f7d.1430348725.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Apr 2015 20:05:53 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> ov7670_s_exp() checks read error for 2 registers: REG_COM1
> and REG_COM8. But, although it uses the value latter, it
> doesn't check errors on REG_AECHH read. Yet, as it is doing
> a bitmask operation there, the read operation should succeed.
> 
> So, fix the code to also check if this succeeded.
> 
> This fixes this smatch report:
> 	drivers/media/i2c/ov7670.c:1366 ov7670_s_exp() warn: inconsistent indenting

That's why I like programming in Python...:)

Silly mistake, good fix.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
