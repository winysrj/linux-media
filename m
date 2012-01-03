Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44237 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2ACQUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 11:20:43 -0500
Received: by wgbds13 with SMTP id ds13so22643206wgb.1
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 08:20:42 -0800 (PST)
Message-ID: <4F032AD7.7090003@gmail.com>
Date: Tue, 03 Jan 2012 17:20:39 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Josu Lazkano <josu.lazkano@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: More adapters on v4l
References: <CAL9G6WVycJpFsCJEWDk_V-RbJ=_1Q42mMJy5cb+tw9MBfke9JA@mail.gmail.com>
In-Reply-To: <CAL9G6WVycJpFsCJEWDk_V-RbJ=_1Q42mMJy5cb+tw9MBfke9JA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 03/01/2012 17:09, Josu Lazkano ha scritto:
> Hello, I am trying to compile the v4l drivers, I make this way:
> 
> mkdir /usr/local/src/dvb
> cd /usr/local/src/dvb
> git clone git://linuxtv.org/media_build.git
> cd media_build
> ./build
> 
> I got this message on the end:
> 
> **********************************************************
> * Compilation finished. Use 'make install' to install them
> **********************************************************
> 
> But before the "make" I want to add more adapters changing the
> "v4l/scripts/make_kconfig.pl" file to this:
> 
> .config:CONFIG_DVB_MAX_ADAPTERS=16
> 
> When I execute the "./build" it compile and I can not change the source.
> 
> On the s2-liplianin branch I had no problem because I change it before
> the "make" this way:
> 
> mkdir /usr/local/src/dvb
> cd /usr/local/src/dvb
> wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
> unzip s2-liplianin-0b7d3cc65161.zip
> cd s2-liplianin-0b7d3cc65161
> ##change the adapter number###
> make
> make install
> 
> Is possible to do the same with the v4l source?
> 
> Thanks and best regards.
> 

Hi Josu,
you can do this way:

git clone git://linuxtv.org/media_build.git
cd media_build
./build
## you can ctrl-C as soon as it starts compiling the drivers, or wait
until the end ##
make menuconfig
## change all the options you like and save ##
cd linux
make
cd ..
make install

Best regards,
Gianluca Gennari
