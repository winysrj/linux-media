Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8897 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaIGFoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Sep 2014 01:44:11 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBI00BDCNXLS700@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 07 Sep 2014 01:44:09 -0400 (EDT)
Received: from recife.lan ([105.144.134.222])
 by ussync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NBI008V5NXII260@ussync2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 07 Sep 2014 01:44:09 -0400 (EDT)
Date: Sun, 07 Sep 2014 02:44:05 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: linux-media@vger.kernel.org
Subject: Re: [ANNOUNCE] libdvbv5 API initial documentation
Message-id: <20140907024405.2db69ea6.m.chehab@samsung.com>
In-reply-to: <20140907023532.3efa11cd.m.chehab@samsung.com>
References: <20140907023532.3efa11cd.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 Sep 2014 02:35:32 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Hi,
> 
> We're about to release a new version for the v4l-utils, with the libdvbv5
> API improvements. To help developers to understand and use the library,
> I did an effort to document the major functionalities available at the
> library. Not everything is there yet, but it should cover already the
> functionality that most applications would use on it.
> 
> It is still a draft, as we might change some things before the launch
> of version 1.4.0 of v4l-utils.
> 
> So, feel free to take a look and review.
> 
> The document is available at:
> 	http://linuxtv.org/docs/libdvbv5/dvb-demux_8h.html

Hmm... Actually, the main page is at:
	http://linuxtv.org/docs/libdvbv5/index.html

Ah, provided that doxygen is installed, the documentation can be
generated from the v4l-utils on several formats, including man pages.

In order to do that, you need to run (from the latest v4l-utils git
tree main branch):

	$ autoreconf -vfi
	$ ./configure --enable-doxygen-man
(to enable manpage format, if desired)

To generate the doxygen docs, run:

	$ make doxygen-run

Have fun!
Mauro
