Return-path: <linux-media-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:49423 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbZBBLzl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 06:55:41 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: video4linux-list@redhat.com
Subject: Re: PV143N watchdog
Date: Mon, 2 Feb 2009 12:45:42 +0100
Cc: Getcho Getchev <ggetchev@constalant.com>,
	linux-media@vger.kernel.org
References: <C528BDC8-8F63-4ED6-AED9-56F0F27C702F@constalant.com>
In-Reply-To: <C528BDC8-8F63-4ED6-AED9-56F0F27C702F@constalant.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021245.45185.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 February 2009 10:34, Getcho Getchev wrote:
> Greetings,
> I am trying to control the PV143N watchdog via bttv driver under linux
> kernel 2.6.24.3.
> According to the specification the watchdog is located at address
> 0x56, subaddress 0x01.
> However when I try to write something (a value of 0, 1 or 2) on that
> address I get NACK result.
> I am using i2c_master_send() function and software bitbanging
> algorithm, implemented in bttv-i2c.c
> At the beginning I suspected the SCL line (the clock for the
> communication must be set at 100 KHz) but when I saw the delay time is
> 5 microseconds I realized the period is 10 microseconds which makes
> 100 KHz. I tried to write the same data on address 0x2B and I
> succeeded (although I do not know what is there on that address) so it

That really sounds like a common i2c miss-understanding.
Linux kernel i2c functions use only the 7bit address part of the i2c address.
So it sounds like your device has address 0x56 for writing and 0x57 for 
reading. (is this correct?)
Now you give i2c_master_send or i2c_transfer the 7bit part, 0x56 >> 1, and 
that is 0x2B.

Regards
Matthias
