Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:59006 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHOnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 09:43:23 -0500
Received: by mail-oi0-f45.google.com with SMTP id a141so3422266oig.4
        for <linux-media@vger.kernel.org>; Mon, 08 Dec 2014 06:43:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyi87PSAkHGpMAxz2Y0k6Nryh0EWYemDMEB=NvG+=qygg@mail.gmail.com>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
	<20141201072028.6466a2b3@recife.lan>
	<CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
	<20141201105235.5cacf881@recife.lan>
	<CAGoCfiyi87PSAkHGpMAxz2Y0k6Nryh0EWYemDMEB=NvG+=qygg@mail.gmail.com>
Date: Mon, 8 Dec 2014 15:43:22 +0100
Message-ID: <CA+QJwyinOqqP6a30NK_t3qrxgytH_DGmk_FKFSp0Si8d=gsY6A@mail.gmail.com>
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

It would probably be the least confusing to users if the updated
firmware was simply named "dvb-fe-xc4000-1.4.2.fw", as it is a
fixed/more complete version built from the same Xceive 1.4 source
files.
