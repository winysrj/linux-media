Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZIVEyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 00:54:11 -0400
Date: Tue, 22 Sep 2009 01:53:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: liu.yaojin@zte.com.cn
Cc: linux-media@vger.kernel.org
Subject: Re: how to develop driver for cy7c68013(fx2 lp)?
Message-ID: <20090922015333.2fe70e98@pedra.chehab.org>
In-Reply-To: <OF1131EA10.F93A7B58-ON48257639.000F4B37-48257639.000FA4BF@zte.com.cn>
References: <OF1131EA10.F93A7B58-ON48257639.000F4B37-48257639.000FA4BF@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Liu,

Em Tue, 22 Sep 2009 10:47:18 +0800
liu.yaojin@zte.com.cn escreveu:

> hi,all:
>   i have a cmmb usb card,based on fx2 lp.my kernel version is 2.6.24.7.i 
> already read some source in /driver/usb/misc and 
> /driver/media/dvb/dvb-usb, and still have no idea how to write the driver 
> .could you show me how to do it?
> maybe i just want to read/write cy7c68013 corrently,and not need v4l2 api 
> :)
> thanks.

If the driver will support just digital TV, you don't need V4L2 API, just DVB
API. The latest version of the API's are at:

	http://linuxtv.org/downloads/v4l-dvb-apis/

In order to start, you need first to understand the API. Then, you'll need to
get one driver as an example (for example, cxusb.c - if the device is USB). 

If the driver also supports analog TV, then the better is to use a driver that
supports both API's, like em28xx



Cheers,
Mauro
