Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:40243 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLAPat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 10:30:49 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so7465078oif.7
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 07:30:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyi87PSAkHGpMAxz2Y0k6Nryh0EWYemDMEB=NvG+=qygg@mail.gmail.com>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
	<20141201072028.6466a2b3@recife.lan>
	<CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
	<20141201105235.5cacf881@recife.lan>
	<CAGoCfiyi87PSAkHGpMAxz2Y0k6Nryh0EWYemDMEB=NvG+=qygg@mail.gmail.com>
Date: Mon, 1 Dec 2014 16:30:47 +0100
Message-ID: <CA+QJwyiZ4J_rz=HVkS6z7v1SMD1viZOP7TZRcGJmZDgGPXne_Q@mail.gmail.com>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
From: =?UTF-8?B?SXN0dsOhbiwgVmFyZ2E=?= <istvan_v@mailbox.hu>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-12-01 15:15 GMT+01:00 Devin Heitmueller <dheitmueller@kernellabs.com>:

> If somebody wants to send me an updated blob, I'm happy to host a copy
> at kernellabs.com alongside the file that is currently there (please
> make sure it has a different filename though).

My firmware package is available here:
  http://juropnet.hu/~istvan_v/xc4000_firmware.tar.gz
The only relevant files are build_fw.c and the two original headers from Xceive
(xc4000_*.h). Although other programs for extracting the firmware from the
Windows drivers are also included, they are no longer needed.

To compile build_fw.c on current kernels without errors, the include path to
tuner-xc2028-types.h needs to be fixed at line 11. Other than that, it should
work without problems. It takes one optional command line argument, which
is the name of the output file.
