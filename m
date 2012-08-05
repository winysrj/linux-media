Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2HEOgS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 10:36:18 -0400
Message-ID: <501E84D6.1040402@redhat.com>
Date: Sun, 05 Aug 2012 11:36:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] lmedm04 v2.05 conversion to dvb-usb-v2
References: <1344175824.18047.7.camel@router7789>
In-Reply-To: <1344175824.18047.7.camel@router7789>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-08-2012 11:10, Malcolm Priestley escreveu:
> Conversion of lmedm04 to dvb-usb-v2
> 
> functional changes are that callbacks have been moved to fe_ioctl_override.

Don't do that: fe_ioctl_override has a broken design and only handles DVBv3
ioctl's. So, if userspace is using DVBv5, this will cause a regression.

Antti,

IMO, the best thing to do is to either remove fe_ioctl_override or to print
a warning when a driver calls it, in order to warn developers that they're
using a legacy callback that could cause the driver to not work properly.

Regards,
Mauro

