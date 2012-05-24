Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:53128 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757483Ab2EXS0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 14:26:07 -0400
Message-ID: <4FBE7D3C.3080403@gmx.de>
Date: Thu, 24 May 2012 20:26:04 +0200
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] stv090x: Fix typo in register macros
References: <4F4BEAAB.3000603@gmx.de> <CAHFNz9Lk2YSBAoBvjm-tDNk-rpe77x36S0GGJ306=qPWWYTdDw@mail.gmail.com>
In-Reply-To: <CAHFNz9Lk2YSBAoBvjm-tDNk-rpe77x36S0GGJ306=qPWWYTdDw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 15.05.2012 14:43, schrieb Manu Abraham:
> Hi Andreas,
> 
> Sorry about the late reply.
> 
> Which datasheet revision are you using ? I looked at RevG and found that the
> register ERRCNT22 @ 0xF59D, 0xF39D do have bitfields by name Px_ERR_CNT2
> on Page 227.
> 
> Did you overlook that by some chance ?
> 
> Best Regards,
> Manu

Hi Manu,

I checked the datasheet. You are right, the actual bitfield of register Px_ERRCNT22 is named there Px_ERR_CNT2 but the same name is also used for the bitfields of registers Px_ERRCNT21 and Px_ERRCNT20. I think naming it CNT22 better reflects its actual meaning of being the only a part of the counter value. It also would match the naming of ERRCNT12.

Best regards
Andreas
