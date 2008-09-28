Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Sun, 28 Sep 2008 01:45:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andreas Oberritter <obi@linuxtv.org>
Message-ID: <20080928014548.5d9493e7@mchehab.chehab.org>
In-Reply-To: <48DCEBD1.9010003@linuxtv.org>
References: <200809261129.07494.mldvb@mortal-soul.de>
	<48DCEBD1.9010003@linuxtv.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] implement proper locking in the dvb ca
 en50221 driver
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

On Fri, 26 Sep 2008 16:04:01 +0200
Andreas Oberritter <obi@linuxtv.org> wrote:

> Hello Matthias,
> 
> Matthias Dahl wrote:
> > Since Oliver regrettably resigned from maintaining the dvb-ttpci subtree, I am 
> > resending this patch which hopefully gets applied to the main tree. It fixes 
> > a long standing issue with the ci device getting in an semi-undefined state 
> > where the application needs to be restarted for the ci device to work again. 
> > 
> > Attached you'll find the patch for the dvb ca en50221 driver which fixes all 
> > reported problems without introducing new ones. The patched driver has been 
> > working for a few weeks now without any sign of trouble. I also got one user 
> > reporting that at least nothing broke and that he hopes this fixes his issues 
> > as well. (so far it looks good for him) 
> 
> you should CC Mauro for all patches which are not going to be applied
> through another person.
> 
> Mauro, please pick up the patch from Matthias' email. This patch
> probably needs a wider audience for testing. So I think it's best to
> apply it on v4l-dvb now and send it to Linus once the next merge window
> opens.

OK, I'll apply it right now.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
