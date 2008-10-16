Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+33b1dba9250cee9600f2+1880+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KqGvt-0001ZB-Bf
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 02:41:41 +0200
Date: Wed, 15 Oct 2008 22:41:28 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Manu Abraham <abraham.manu@gmail.com>
Message-ID: <20081015224128.5320eaee@pedra.chehab.org>
In-Reply-To: <48F525CD.70801@gmail.com>
References: <48F525CD.70801@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] STB0899 update  (TT S2 3200)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Manu,

On Wed, 15 Oct 2008 03:05:49 +0400
Manu Abraham <abraham.manu@gmail.com> wrote:

> hi all,
> 
> can you please verify whether the stb0899 update for TT S2 3200 alone
> for now
> 
> http://jusst.de/hg/v4l-dvb-test

Not tested, but, on a source code inspection, it seems fine. I think there are
some spaces for a few cleanups but nothing serious.

You should send a pull request. Having this at the merged tree will allow
more people to test.


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
