Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab0DEIog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Apr 2010 04:44:36 -0400
Message-ID: <4BB9A2E1.5020903@redhat.com>
Date: Mon, 05 Apr 2010 10:44:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: rath <mailings@web150.mis07.de>
CC: linux-media@vger.kernel.org
Subject: Re: update gspca driver in linux source tree
References: <2A74AB3078F34BB484457496310C528B@pcvirus>
In-Reply-To: <2A74AB3078F34BB484457496310C528B@pcvirus>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/04/2010 08:47 PM, rath wrote:
> Hi,
>
> I have a 2.6.29 kernel for my embedded ARM system. I need an newer gspca
> driver, so I downloaded the gspca driver from
> http://linuxtv.org/hg/~hgoede/gspca/ an copied the content of the linux
> folder to my 2.6.29 source tree and tried to cross compile it. But I get
> the error "drivers/media/IR/irfunctions.c:27:20: error: compat.h: No
> such file or directory". Where can I find the missing file and where I
> have to put it in my linux tree?
>
> Do you have some other ideas to cross compile the gspca driver?
>

The hg v4l-dvb trees are meant for out of tree compilation (this means your
v4l subsystem must be compiled modular).

You will want to not use my tree, but use the latest generic tree:
hg clone http://linuxtv.org/hg/v4l-dvb/
Then simply compile that tree (this will need the headers of your 2.6.29 kernel
in the usual place):
cd v4l-dvb
make menuconfig
make
sudo make install

And then reboot, now you will be using your 2.9.29 kernel with a fully
up2date v4l-dvb subsystem.

Regards,

Hans
