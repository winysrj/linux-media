Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab1IMWTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 18:19:43 -0400
Received: by wyh22 with SMTP id 22so1039397wyh.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 15:19:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfixms4uG_3mbT8+pwfzBUsHoJf-P6U_Em-znP2NEzPwsXg@mail.gmail.com>
References: <4E68EE98.90201@iki.fi>
	<4E69EE5E.8080605@rd.bbc.co.uk>
	<4E6FC41A.5030803@iki.fi>
	<1315949644.10987.25.camel@ares>
	<CALzAhNWKAL-RNZzzE84-Jp=1JtCba+sZZneryC+-40_5Tm8ovw@mail.gmail.com>
	<CAGoCfixms4uG_3mbT8+pwfzBUsHoJf-P6U_Em-znP2NEzPwsXg@mail.gmail.com>
Date: Tue, 13 Sep 2011 18:19:42 -0400
Message-ID: <CALzAhNXd5+Zewzd3EfbqsLJKT_SyVjANLoZYk3zpOyQEy93krA@mail.gmail.com>
Subject: Re: recursive locking problem
From: Steven Toth <stoth@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Steve Kerrison <steve@stevekerrison.com>,
	Antti Palosaari <crope@iki.fi>,
	David Waring <davidjw@rd.bbc.co.uk>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I would take Steven Toth's explanation as more authoritative than mine
> any day of the week.  It's possible that I may have been misinformed
> regarding the rationale for why the gate is required.

In general, complete bus isolation lowers noise levels, whether
through RF coupling or needless interrupt servicing related. Either
rationale is valid and varies between designs.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
