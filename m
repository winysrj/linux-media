Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZCFKqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 05:46:34 -0500
Date: Fri, 6 Mar 2009 07:46:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Joonyoung Shim <dofmind@gmail.com>
Cc: linux-media@vger.kernel.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Subject: Re: About the radio-si470x driver for I2C interface
Message-ID: <20090306074604.10926b03@pedra.chehab.org>
In-Reply-To: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
References: <4e1455be0903051913x37562436y85eef9cba8b10ab0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009 12:13:05 +0900
Joonyoung Shim <dofmind@gmail.com> wrote:

> Hi all,
> 
> I have worked with Silicon Labs Si4709 chip using the I2C interface.
> There is the radio-si470x driver in linux-kernel, but it uses usb interface.
> 
> First, i made a new file based on radio-si470x.c in driver/media/radio/ for
> si4709 i2c driver and modified it to use i2c interface instead of usb
> interface and could listen to FM radio station.
> 
> I think it can be to join two things together to one file because there isn't
> the difference between the two except for the interface.
> I am considering how to integrate them.
> 
> Please send your opinion.
> 

The proper way is to break radio-si470x into two parts:

	- A i2c adapter driver (similar to what we have on cx88-i2c, for
	  example, plus the radio part of cx88-video);
	- A radio driver (similar to tea5767.c).

This way, the i2c driver can be used on designs that use a different i2c adapter.

Cheers,
Mauro
