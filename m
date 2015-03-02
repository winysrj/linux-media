Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbCBKs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 05:48:59 -0500
Date: Mon, 2 Mar 2015 07:48:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: SMS / DVB / media_graph issue - tip fails to compile
Message-ID: <20150302074855.2a62ece1@recife.lan>
In-Reply-To: <CALzAhNVnmCFTM6ymqVJJrcwCfw35N1-ejLmWibMjo6EDEj0uog@mail.gmail.com>
References: <CALzAhNVnmCFTM6ymqVJJrcwCfw35N1-ejLmWibMjo6EDEj0uog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 1 Mar 2015 14:09:53 -0500
Steven Toth <stoth@kernellabs.com> escreveu:

> Someone broke tip.

The quick solution is to enable MEDIA_CONTROLLER_DVB.

Hans sent already a fix patch, but I think that the best is to solve
it on a different way.

I'll be preparing a patch for it latter, likely today.

> 
>   CC [M]  drivers/media/common/siano/smsdvb-main.o
> drivers/media/common/siano/smsdvb-main.c: In function
> ‘smsdvb_media_device_unregister’:
> drivers/media/common/siano/smsdvb-main.c:614:27: warning: unused
> variable ‘coredev’ [-Wunused-variable]
>   struct smscore_device_t *coredev = client->coredev;
>                            ^
> 
> drivers/media/common/siano/smsdvb-main.c: In function ‘smsdvb_hotplug’:
> drivers/media/common/siano/smsdvb-main.c:1188:32: error: ‘struct
> smscore_device_t’ has no member named ‘media_dev’
>   dvb_create_media_graph(coredev->media_dev);
>                                 ^
> 
> make[4]: *** [drivers/media/common/siano/smsdvb-main.o] Error 1
> make[3]: *** [drivers/media/common/siano] Error 2
> make[2]: *** [drivers/media/common] Error 2
> 
