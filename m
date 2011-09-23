Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ird.yahoo.com ([212.82.108.235]:24595 "HELO
	nm4.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752231Ab1IWJaU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 05:30:20 -0400
Message-ID: <4E7C51A7.9020209@yahoo.com>
Date: Fri, 23 Sep 2011 10:30:15 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Stuart Morris <stuart_morris@talk21.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx PCTV 290e patches
References: <1316767965.1148.YahooMailClassic@web86705.mail.ird.yahoo.com>
In-Reply-To: <1316767965.1148.YahooMailClassic@web86705.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stuart,

On 23/09/11 09:52, Stuart Morris wrote:
> I have a PCTV 290e and have been watching closely the updates to the Linux media
> tree for this device. Thanks for addressing the issues with the 290e driver, I am
> now able to use my 290e for watching UK FreeviewHD with a good degree of success.

No problems, although I think Mauro has been working on the locking problem as 
well :-).

> I have a question regarding some patches you requested a while back that have
> yet to be applied to the media tree.
> These patches are:
> http://www.spinics.net/lists/linux-media/msg36799.html
> http://www.spinics.net/lists/linux-media/msg36818.html

Yes, I have noticed this. My advice would be to apply the first patch that 
remove the em28xx_remove_from_devlist() function (and the race condition that it 
creates), but not the second patch because I don't think it's compatible with 
Mauro's work.

My other patches have *slowly* been added to the queue for 3.2; I am still 
waiting to see if this patch will join the others before resubmitting it.

Cheers,
Chris
