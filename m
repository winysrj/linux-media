Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38807.mail.mud.yahoo.com ([209.191.125.98])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1L2l7q-0004EN-QL
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 12:21:40 +0100
Date: Wed, 19 Nov 2008 03:21:04 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0811191109450.6408@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Message-ID: <696408.29237.qm@web38807.mail.mud.yahoo.com>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH 4/5] Kconfig and Makefile update
Reply-To: urishk@yahoo.com
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


--- On Wed, 11/19/08, BOUWSMA Barry <freebeer.bouwsma@gmail.com> wrote:

> From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
> Subject: Re: [linux-dvb] [PATCH 4/5] Kconfig and Makefile update
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "Linux-dvb" <linux-dvb@linuxtv.org>
> Date: Wednesday, November 19, 2008, 12:26 PM
> On Wed, 19 Nov 2008, Uri Shkolnik wrote:
> 
> > This patch provides the following:
> [...]
> 
> Thanks for these; parts 1, 3, and 4 have made it intact
> to me (haven't checked elsewhere) -- oops, part 2 has
> just
> trickled in; will wait for part 5 Real Soon Now
> 
> However, I do have an item of concern:
> 
> 
> > +	Further documentation on this driver can be found on
> the WWW at http://www.siano-ms.com/
> 
> Can you provide a more direct link to a developer or
> download or technical page, as what I see consists of
> press releases and similar marketing, with no links to
> anything I could use with these patches...
> 
> 
> Here's the complete list of links I get from the above
> page:
> 
>                    List Page (Lynx Version 2.8.7dev.9),
> help
> 
>    References in http://www.siano-ms.com/
> 
>     Visible links:
>     1.
> javascript:MM_openBrWindow('on-the-go.html','Siano','toolbar=yes,wi
>        dth=450,height=400')
>     2.
> javascript:MM_openBrWindow('in-your-car.html','Siano','toolbar=yes,
>        width=450,height=400')
>     3.
> javascript:MM_openBrWindow('at-your-home-office.html','Siano','tool
>        bar=yes,width=450,height=400')
>     4. http://www.siano-ms.com/news171108.html
>     5. http://www.siano-ms.com/news061108.html
>     6. http://www.siano-ms.com/news120908.html
>     7. http://www.siano-ms.com/news120908-a.html
>     8. http://www.siano-ms.com/news110908-a.html
>     9. http://www.siano-ms.com/news110908.html
>    10. http://www.siano-ms.com/news130808.html
>    11. http://www.siano-ms.com/news171108.html
>    12.
> javascript:MM_openBrWindow('termsandconditions.html','','scrollbars
>        =yes,resizable=yes,width=400,height=350')
> 
>     Hidden links:
>    13. http://www.siano-ms.com/#Axel
>    14. http://www.siano-ms.com/#Cyberlink
>    15. http://www.siano-ms.com/news.html
> 
> 
> If, however, any needed code would appear in other
> patches -- such as the source for smschar.o, then
> ignore this; but if there is in fact a developer page
> under siano-ms.com, you might see if it can be made
> more obvious -- I think at least one other person has
> posted here being unable to find it.
> 
> 
> thanks!
> barry bouwsma

Hi Barry,

Patch 2/5 awaits moderator approval. (little big patch that deals with SPI interface, hope you'll get it soon)

You can use me as focal point at Siano for technical papers and other documentation, please note that some papers require NDA (not all, but some)

smschar is part of the Siano subsystem, and I hope I'll release is later today. (The S2 / DVB API v5 will have to wait a little longer, I'm simply overloaded).

Regards,

Uri


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
