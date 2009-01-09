Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 9 Jan 2009 00:29:37 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Dahl <mldvb@mortal-soul.de>
Message-ID: <20090109002937.2d336c09@pedra.chehab.org>
In-Reply-To: <200901061940.45790.mldvb@mortal-soul.de>
References: <200810071636.32416.mldvb@mortal-soul.de>
	<20081201185713.7578ffb8@pedra.chehab.org>
	<200901061940.45790.mldvb@mortal-soul.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] bug in locking patch for dvb ca en50221 driver
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

On Tue, 6 Jan 2009 19:40:45 +0100
Matthias Dahl <mldvb@mortal-soul.de> wrote:

> Hi Mauro.
> 
> I am absolutely sorry that it's been ages since my last mail regarding this 
> patch but life intervened in every way possible actually... and still does. 
> To make matters worse, we (luckily) switched to dvb-s, so I am unfortunately 
> no longer able make further tests if time would permit. :-(
> 
> I have used this patch on my machine for weeks after my last post and haven't 
> had any trouble with it. Still there seems to be a hard to hit race condition 
> now which would need further testing. Nevertheless IMHO the patch is a real 
> improvement to the situation because before one could frequently run into 
> issues... and now things work just fine most of the time.

Ok. I've added the patch on my queue for 2.6.29.

Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
