Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43420 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0I0EIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 00:08:43 -0400
Received: by ywh1 with SMTP id 1so1414044ywh.19
        for <linux-media@vger.kernel.org>; Sun, 26 Sep 2010 21:08:43 -0700 (PDT)
Message-ID: <4CA018C4.9000507@gmail.com>
Date: Mon, 27 Sep 2010 01:08:36 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: "Ole W. Saastad" <olewsaa@online.no>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Trouble building v4l-dvb
References: <1284493110.1801.57.camel@sofia> <4C924EB8.9070500@hoogenraad.net> <4C93364C.3040606@hoogenraad.net> <4C934806.7050503@gmail.com> <4C934C10.2060801@hoogenraad.net> <4C93800B.8070902@gmail.com> <4C9F7267.7000707@hoogenraad.net>
In-Reply-To: <4C9F7267.7000707@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-09-2010 13:18, Jan Hoogenraad escreveu:
> On
> Linux 2.6.28-19-generic
> the problem is tackled already:
> DVB_FIREDTV_IEEE1394: Requires at least kernel 2.6.30
> 
> On newer linux versions (I have tried Linux 2.6.32-24-generic) the problem is NOT that the modules dma is not present, it is just that the required header files are not present in
> /usr/include
> 
> Another location mighte have been:
> ls -l /usr/src/linux-headers-2.6.28-19-generic/include/config/ieee1394

This is the right place is whatever pointed on your kernel source alias, like:

$ ls -la /lib/modules/2.6.35+/source
lrwxrwxrwx. 1 root root 23 Set 26 21:51 /lib/modules/2.6.35+/source -> /home/v4l/v4l/patchwork


> 
> but that only contains:
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 dv1394.h
> drwxr-xr-x 3 root root 4096 2010-06-15 20:12 eth1394
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 eth1394.h
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 ohci1394.h
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 pcilynx.h
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 rawio.h
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 sbp2.h
> -rw-r--r-- 1 root root    0 2010-09-16 18:25 video1394.h
> 
> Can you indicate where following files  should be located ?
> dma.h
> csr1212.h
> highlevel.h

All of them are at the same place:

/lib/modules/2.6.35+/source/drivers/ieee1394/dma.h
/lib/modules/2.6.35+/source/drivers/ieee1394/csr1212.h
/lib/modules/2.6.35+/source/drivers/ieee1394/highlevel.h

> 
> In that case checking if the dma.h file is present might be the best way forward.
> 
> I'll also file an ubuntu bug once I know what is missing where.
> I could not find an entry in launchpad on this issue yet.

This is probably the best thing. A check for dma.h may also work. If you want,
do a patch for it and submit to Douglas.

Cheers,
Mauro
