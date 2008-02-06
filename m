Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6dd8d47bc3ba92436b7f+1627+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JMYVY-0008VD-Ft
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 01:51:24 +0100
Date: Tue, 5 Feb 2008 22:49:36 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: e9hack <e9hack@googlemail.com>
Message-ID: <20080205224936.1f1fcd45@gaivota>
In-Reply-To: <47A8E6CF.4040507@gmail.com>
References: <47A8E6CF.4040507@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] BUG in changeset 7157?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Tue, 05 Feb 2008 23:44:31 +0100
e9hack <e9hack@googlemail.com> wrote:

> Hi,
> 
> compiling of the current HG tree fails on linux 2.6.24. I think it is a bug in changeset 7157:
> 
> --- a/v4l/compat.h Tue Feb 05 07:37:21 2008 +0000
> +++ b/v4l/compat.h Tue Feb 05 11:21:32 2008 -0200
> @@ -497,6 +497,10 @@ do { \
> #ifndef BIT_MASK
> # define BIT_MASK(nr) (1UL << ((nr) % BITS_PER_LONG))
> # define BIT_WORD(nr) ((nr) / BITS_PER_LONG)
> +
> +#define i2c_verify_client(dev) \
> + ((dev->bus == &i2c_bus_type) ? to_i2c_client(dev) : NULL)
> +
> #endif
> 
> The definition of i2c_verify_client() should not be inside #ifndef BIT_MASK / #endif. The 
> variable i2c_bus_type is only public on 2.6.23.x (maybe also on earlier versions) but not 
> on 2.6.24. The following patch does fix the problem on 2.6.24 for me:

Committed, thanks!

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
