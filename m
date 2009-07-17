Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:37733 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZGQD5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 23:57:44 -0400
Received: by pxi15 with SMTP id 15so363559pxi.33
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 20:57:44 -0700 (PDT)
Subject: Re: AVerMedia AVerTV GO 007 FM, no radio sound (with routing
 enabled)
From: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Laszlo Kustan <lkustan@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <1247797282.3187.47.camel@pc07.localdom.local>
References: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
	 <1247794346.3921.22.camel@AcerAspire4710>
	 <1247797282.3187.47.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 10:57:38 +0700
Message-Id: <1247803058.26678.2.camel@AcerAspire4710>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
So, should we add an option for this card? For example:
modprobe saa7134 card=57 radioontv
Regards

