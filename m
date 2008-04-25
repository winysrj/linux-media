Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 25 Apr 2008 09:50:40 +0200
From: Philipp Kolmann <philipp@kolmann.at>
To: linux-dvb@linuxtv.org
Message-ID: <20080425075040.GA15818@kolmann.at>
References: <20080424181148.GA3898@kolmann.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080424181148.GA3898@kolmann.at>
Cc: manu@linuxtv.org
Subject: Re: [linux-dvb] kernel oops with Terratec Cinergy C
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

Just for the reference. I managed to get the card working yesterday with an
older verion of the mantis drivers. It seems that the dma issue came up with
the CA stuff.

Thanks
Philipp

On Thu, Apr 24, 2008 at 08:11:48PM +0200, Philipp Kolmann wrote:
[...]
> Apr 24 20:06:10 chief kernel: mantis start feed & dma
> Apr 24 20:06:10 chief kernel: BUG: unable to handle kernel paging request at virtual address 08865fff
[...]

-- 
The more I learn about people, the more I like my dog!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
