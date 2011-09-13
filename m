Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab1IMQG7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 12:06:59 -0400
Message-ID: <4E6F7FA0.6030106@redhat.com>
Date: Tue, 13 Sep 2011 13:06:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lukas Sukdol <lukas.sukdol@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Fwd: V4L2 driver EM28xx
References: <CAJ+hA-xLWGZN7CQOv6=NrXw5pVU1HUmeXXfXkLtb54hbK6-jHQ@mail.gmail.com> <CAJ+hA-xw2RzgwSz-9CbgyXYYJLPVJYWCjRDVAT0MQNuAbxzTng@mail.gmail.com> <CAJ+hA-zM00RDSSFW++kSqN5HRsTMfZFXqDNYxDv=QSxe+hoOJw@mail.gmail.com>
In-Reply-To: <CAJ+hA-zM00RDSSFW++kSqN5HRsTMfZFXqDNYxDv=QSxe+hoOJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-09-2011 18:56, Lukas Sukdol escreveu:
> Hello,
> I can't get working USB DVR Box (4 video channels / 2 audio) with the
> EM2860 chip.
> The USB device is recognized, but it doesn't work with any of 77 cards
> in the list...
> I'm using Fedora 14 (2.6.35.14-96.fc14.i686).
> 
> See details in attached dmesg log file.
> 
> Link to card (TE-3104AE): http://www.tungson.cn/en/product_info.asp?InfoID=164
> 
> Is this card (or will be) supported by EM28xx driver?

Only if someone with the hardware adds support for it ;)

It shouldn't be that hard to add support for it: all you need to do is to
capture the USB logs from the original driver and use the existing parsers
for em28xx to discover what it does to select between the 4 video inputs
and the 2 audio inputs. It probably uses some GPIO's to select them.

Linuxtv wiki pages explain how to do it at the developer's section. You should
search there for the USB sniffing pages.

Good luck,
Mauro
