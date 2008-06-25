Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from kelvin.aketzu.net ([81.22.244.161] ident=postfix)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <akolehma@aketzu.net>) id 1KBP33-0006YK-35
	for linux-dvb@linuxtv.org; Wed, 25 Jun 2008 09:04:09 +0200
Date: Wed, 25 Jun 2008 10:04:05 +0300
From: Anssi Kolehmainen <anssi@aketzu.net>
To: linux-dvb@linuxtv.org
Message-ID: <20080625070405.GG19557@aketzu.net>
References: <20080623203737.GA19557@aketzu.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080623203737.GA19557@aketzu.net>
Subject: Re: [linux-dvb] Terratec Cinergy C PCI (mantis) doesn't work
	with	CAM
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

On Mon, Jun 23, 2008 at 11:37:37PM +0300, Anssi Kolehmainen wrote:
> I have Terratec Cinergy PCI DVB-C (1822:4e35) with CI addon card. Card
> works fine with latest mantis drivers from http://jusst.de/hg/mantis
> (tip, 7348:0b04be0c088a). Problems start when I plug in Conax CAM and
> load mantis module. Sometimes it just hangs the computer and when it
> works it cannot tune to channels.
> 
> Getting good logs is a bit hard since mantis with verbose=3 hangs
> machine when loading module.
> 
> Any ideas how to debug/fix this? Why en50221 (?) breaks i2c for
> frontend?

After long evening of hacking and testing it seems that reading or
writing from the CAM breaks things. mantis_hif_read_mem() (and others)
seem to be the problematic functions. If I remove calls to those
functions in mantis_ca.c then CAM initialization naturally fails but
card continues to work. Does anybody have mantis docs where those
hif-functions (or rather the GPIF writes/reads) are described?

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
