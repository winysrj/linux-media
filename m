Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0e7636a4d0cb1b228670+1905+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KzeLE-0007Jh-0j
	for linux-dvb@linuxtv.org; Mon, 10 Nov 2008 22:30:36 +0100
Date: Mon, 10 Nov 2008 18:16:43 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@tut.by>
Message-ID: <20081110181643.55f49a5a@pedra.chehab.org>
In-Reply-To: <200811091726.25428.liplianin@tut.by>
References: <200811091726.25428.liplianin@tut.by>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 3/3] cx88-dvb: Add new cards.
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

On Sun, 9 Nov 2008 17:26:25 +0200
"Igor M. Liplianin" <liplianin@tut.by> wrote:

> Add support for Prof 6200 DVB-S PCI card
> 
> From: Igor M. Liplianin <liplianin@me.by>
> 
> Add support for Prof 6200 DVB-S PCI card
> The card based on stv0299 or stv0288 demodulators.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>


Ok, I've applied the 3 patches. Please, prefer to send the patch as inline,
since this makes easier for people to review and comment. Also, on your patch,
you have the same comment as on the body of the email. This may cause troubles,
since the commit script may try to merge both comments and SOB's.



Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
