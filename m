Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39332 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZIWMrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2009 08:47:32 -0400
Date: Wed, 23 Sep 2009 09:46:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: PCI bridge driver
Message-ID: <20090923094658.4e58e7d6@pedra.chehab.org>
In-Reply-To: <3192d3cd0909230515v32090f55y2e3a582172420edc@mail.gmail.com>
References: <3192d3cd0909230515v32090f55y2e3a582172420edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Sep 2009 14:15:25 +0200
Christian Gmeiner <christian.gmeiner@gmail.com> escreveu:

> Hi List,
> 
> I have looked at the documentation (v4l2-framework.txt) and have some
> questions. I want to make use
> of the subdevice stuff, but I don't know where to start. The
> subdevices are connected through i2c and the
> components may vary. So is there a good example driver to look at?

If you want to take a look on a PCI driver, I think the better is to take a
look at saa7134 and at cx88 drivers. You can also take a look at vivi driver.
vivi has just the basic stuff for a video driver. However, as it runs without any
associated hardware, you won't find there any call to dev/subdev stuff.



Cheers,
Mauro
