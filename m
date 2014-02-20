Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f48.google.com ([209.85.213.48]:60744 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaBTMvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 07:51:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140220092559.GX26722@mwanda>
References: <20140206092800.GB31780@elgon.mountain>
	<CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
	<20140218085651.GL26722@mwanda>
	<CAHFNz9LUP4UVROk5RWW_-=LQ5=gC8__zD67aLxNq7bHUMgipCQ@mail.gmail.com>
	<20140219074455.GQ26722@mwanda>
	<CAHFNz9K=0TRLDq1q=2+sYknSw6CeGreeEWPSZbfYvsxUNLXJeA@mail.gmail.com>
	<20140220092559.GX26722@mwanda>
Date: Thu, 20 Feb 2014 18:15:53 +0530
Message-ID: <CAHFNz9KfeWxYQDB7ykzXBQsLBYwD9zOoUT5vrNfLXFnBU9ZVxw@mail.gmail.com>
Subject: Re: [patch] [media] stv090x: remove indent levels
From: Manu Abraham <abraham.manu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 20, 2014 at 2:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Guys, what Manu is saying is purest nonsense.  The "lock" variable is a
> stack variable, it's not a "demodulator Read-modify-Write register".
> The implications of changing "if (!lock)" to "if (lock)" are simple and
> obvious.

Sorry, you mistook. By demodulator Read-modify-Write register,
I do really mean a register on the demodulator. If you do miss
a read when flipping a logic, it does indeed make a large difference.


>
> He's not reviewing patches, he's just NAKing them.  It's not helpful.
>

Uh !?

I said "Ok, will have a look at it later, the second lock test might
be superfluous,
which will fix your static checker as well."

Where's the NAK in there ?

Just said that, I prefer a simplified version, rather than that logic flip.

Regards,

Manu
