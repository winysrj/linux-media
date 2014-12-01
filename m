Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41173 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbaLAOPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 09:15:19 -0500
Received: by mail-qa0-f50.google.com with SMTP id w8so7326071qac.9
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 06:15:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201105235.5cacf881@recife.lan>
References: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
	<20141201072028.6466a2b3@recife.lan>
	<CA+QJwyh-3YL1UCR7Q1d3jy8z49YM2yqNp_WmiD3zXLRzEuC-Uw@mail.gmail.com>
	<20141201105235.5cacf881@recife.lan>
Date: Mon, 1 Dec 2014 09:15:18 -0500
Message-ID: <CAGoCfiyi87PSAkHGpMAxz2Y0k6Nryh0EWYemDMEB=NvG+=qygg@mail.gmail.com>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: =?UTF-8?B?SXN0dsOhbiwgVmFyZ2E=?= <istvan_v@mailbox.hu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> My understanding is that it covers that specific firmware file.

In this case the license was actually against the header file.  I was
responsible for generating the binary blob based on the header files
in the Xceive sources (and got the appropriate permission).  There
should be no licensing issue generating a second blob that includes
the analog standards (I just never got around to it because I didn't
analog support and hence couldn't test the result).

If somebody wants to send me an updated blob, I'm happy to host a copy
at kernellabs.com alongside the file that is currently there (please
make sure it has a different filename though).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
