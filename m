Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46604 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964790Ab1GOGZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 02:25:48 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 57F4D9400DE
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2011 08:25:42 +0200 (CEST)
Date: Fri, 15 Jul 2011 08:27:34 +0200
From: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: Problem building gspca module
Message-ID: <20110715082734.014566fe@tele>
In-Reply-To: <CAOMmEgmG9R1chrJuR2Fh91c5xyJMUdc=rW-yNugE+08sXfutfg@mail.gmail.com>
References: <CAOMmEgmG9R1chrJuR2Fh91c5xyJMUdc=rW-yNugE+08sXfutfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011 00:06:54 -0400
Dave Fine <finerrecliner@gmail.com> wrote:

> I'm trying to build the gspca module and insmod into my current
> running system. I can compile the module, but can't insmod it.
> 
> steps I take to build:
> 
> $ cd /usr/src/linux-source-2.6.38
> $ sudo cp /boot/config-2.6.38-8-generic .config
> $ sudo make oldconfig
> $ sudo make prepare
> $ sudo make modules_prepare
> $ sudo make scripts
> $ sudo make SUBDIRS=drivers/media/video/gspca
> $ cd drivers/media/video/gspca
> $ sudo insmod gspca_main.ko
> $ insmod: error inserting 'gspca_main.ko': -1 Invalid module format
> $ dmesg | tail
> [995219.523934] gspca_main: no symbol version for module_layout
	[snip]
> Does anyone know what I'm doing wrong?

Hi Dave,

You must either
- generate a full kernel,
- or build the video stuff from a linuxtv git repository,
- or get and build the last gspca tarball from my web site.

In the two last cases, the linux headers of your kernel must
be installed (in Debian, these are splitted into three packages
'linux-headers-2.6.38-..' and 'linux-kbuild-2.6.38').

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
