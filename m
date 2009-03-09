Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZCIXWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 19:22:54 -0400
Date: Mon, 9 Mar 2009 20:20:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: Joonyoung Shim <dofmind@gmail.com>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com
Subject: Re: About the radio-si470x driver for I2C interface
Message-ID: <20090309202015.14c78009@pedra.chehab.org>
In-Reply-To: <200903092333.38819.tobias.lorenz@gmx.net>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
	<20090306074604.10926b03@pedra.chehab.org>
	<200903092333.38819.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Mar 2009 23:33:38 +0100
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi,
> 
> > The proper way is to break radio-si470x into two parts:
> > 
> > 	- A i2c adapter driver (similar to what we have on cx88-i2c, for
> > 	  example, plus the radio part of cx88-video);
> > 	- A radio driver (similar to tea5767.c).
> > 
> > This way, the i2c driver can be used on designs that use a different i2c adapter.
> 
> yes, this is why I already capsulated most of the USB functionality into own functions. I awaited that somewhen the si470x is used in the "usual" way by i2c.
> 
> I'm not sure, if we should split the driver into three files (generic/common, usb, i2c) or just implement the new functionality within the same file using macros/defines.

It is better to split. It will provide more flexibility.

Cheers,
Mauro
