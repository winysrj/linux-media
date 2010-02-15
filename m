Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:51140 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab0BOU6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:58:20 -0500
Received: by ewy28 with SMTP id 28so709003ewy.28
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 12:58:19 -0800 (PST)
MIME-Version: 1.0
From: Samuel Cantrell <samuelcantrell@gmail.com>
Date: Mon, 15 Feb 2010 12:57:58 -0800
Message-ID: <310bfb251002151257x7121b20cme3cbe5096decea4b@mail.gmail.com>
Subject: ATI TV Wonder 650 PCI development
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have an ATI TV Wonder 650 PCI card, and have started to work on the
wiki page on LinuxTV.org regarding it. I want to *attempt* to write a
driver for it (more like, take a look at the code and run), and have
printed off some information on the wiki. I need to get pictures up of
the card and lspci output, etc.

Is there anyone else more experienced at writing drivers that could
perhaps help?

http: // www.linuxtv.org / pipermail / linux-dvb / 2007-October /
021228.html says that three pieces of documentation are missing. I've
emailed Samsung regarding the tuner module on the card, as I could not
find it on their website. I checked some of their affiliates as well,
but still had no luck. I've emailed AMD/ATI regarding the card and
technical documentation.

Is it likely that that the tuner module has an XC3028 in it? In the
same linux-dvb message thread noted above, someone speculated that
there is a XC3028. As the v4l tree has XC3028 support, if this is
true, wouldn't that help at least a little bit?

Thanks.

Sam
