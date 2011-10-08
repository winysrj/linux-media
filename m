Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46702 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab1JHOGf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Oct 2011 10:06:35 -0400
Message-ID: <4E9058E8.1070902@iki.fi>
Date: Sat, 08 Oct 2011 17:06:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Josu Lazkano <josu.lazkano@gmail.com>,
	Jason Hecker <jwhecker@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>	 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>	 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>	 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>	 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>	 <4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>	 <CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>	 <CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com> <4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
In-Reply-To: <4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have been following that discussion and hoping you would finally find 
out the reason.

But I want to point out few things;
* .set_frontend() is called only when channel changed
* .set_params() is called only when channel changed
* there is no I2C traffic for tuner after channel changed
* there is I2C traffic to tuner only when channel is changed

Since generally changes to .set_frontend() will not have effect in 
normal use, when both devices are already streaming. Only in case of 
lock is missed and re-tune initialized or channel changed.

regards
Antti


-- 
http://palosaari.fi/
