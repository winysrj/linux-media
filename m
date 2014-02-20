Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29227 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaBTJ0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 04:26:17 -0500
Date: Thu, 20 Feb 2014 12:25:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stv090x: remove indent levels
Message-ID: <20140220092559.GX26722@mwanda>
References: <20140206092800.GB31780@elgon.mountain>
 <CAHFNz9LMU0X2YsqniY+6VOS_mM-jUfAvP2sF5MFNdwWWwEVgsw@mail.gmail.com>
 <20140218085651.GL26722@mwanda>
 <CAHFNz9LUP4UVROk5RWW_-=LQ5=gC8__zD67aLxNq7bHUMgipCQ@mail.gmail.com>
 <20140219074455.GQ26722@mwanda>
 <CAHFNz9K=0TRLDq1q=2+sYknSw6CeGreeEWPSZbfYvsxUNLXJeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHFNz9K=0TRLDq1q=2+sYknSw6CeGreeEWPSZbfYvsxUNLXJeA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys, what Manu is saying is purest nonsense.  The "lock" variable is a
stack variable, it's not a "demodulator Read-modify-Write register".
The implications of changing "if (!lock)" to "if (lock)" are simple and
obvious.

He's not reviewing patches, he's just NAKing them.  It's not helpful.

regards,
dan carpenter

