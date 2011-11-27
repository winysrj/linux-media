Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40312 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1K0FPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 00:15:34 -0500
Received: by iage36 with SMTP id e36so6915501iag.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 21:15:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4ED0FF05.4020700@iki.fi>
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
	<4ED0FF05.4020700@iki.fi>
Date: Sun, 27 Nov 2011 16:15:34 +1100
Message-ID: <CAATJ+ftPupHNYJK7Vcbxsduut6d1KiG7BH864Wd=ja_kL5E14A@mail.gmail.com>
Subject: Re: Status of RTL283xU support?
From: Jason Hecker <jwhecker@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Maik Zumstrull <maik@zumstrull.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> latest news on that seems to be that you were working on cleaning up
>> the code of the Realtek-provided GPL driver, with the goal of
>> eventually getting it into mainline.

Ah, does the Realtek branch have support for DAB(+) and FM?  In
Windows the chip can do DAB+ and FM as well as DVB-T.  The problem I
think is that the DAB and FM demodulation has to be done in software
so the driver would only tune the chip and provide the digitised
baseband signal.  If this could be done then throwing the data stream
into something like OpenDAB's demodulator should work.
