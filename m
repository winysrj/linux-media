Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59162 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2ACQJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 11:09:11 -0500
Received: by wibhm6 with SMTP id hm6so9210146wib.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 08:09:10 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Jan 2012 17:09:10 +0100
Message-ID: <CAL9G6WVycJpFsCJEWDk_V-RbJ=_1Q42mMJy5cb+tw9MBfke9JA@mail.gmail.com>
Subject: More adapters on v4l
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, I am trying to compile the v4l drivers, I make this way:

mkdir /usr/local/src/dvb
cd /usr/local/src/dvb
git clone git://linuxtv.org/media_build.git
cd media_build
./build

I got this message on the end:

**********************************************************
* Compilation finished. Use 'make install' to install them
**********************************************************

But before the "make" I want to add more adapters changing the
"v4l/scripts/make_kconfig.pl" file to this:

.config:CONFIG_DVB_MAX_ADAPTERS=16

When I execute the "./build" it compile and I can not change the source.

On the s2-liplianin branch I had no problem because I change it before
the "make" this way:

mkdir /usr/local/src/dvb
cd /usr/local/src/dvb
wget http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.zip
unzip s2-liplianin-0b7d3cc65161.zip
cd s2-liplianin-0b7d3cc65161
##change the adapter number###
make
make install

Is possible to do the same with the v4l source?

Thanks and best regards.

-- 
Josu Lazkano
