Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Pedro Aguilar <paguilar@junkerhq.net>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <4852AA43.2070401@linuxtv.org>
References: <BLU138-W23877FC9494783EB764EF9B8AD0@phx.gbl>
	<1213306648l.7615l.1l@manu-laptop>
	<BLU138-W2192CC104E6C0B94581EF2B8AC0@phx.gbl>
	<4852AA43.2070401@linuxtv.org>
Date: Tue, 17 Jun 2008 23:42:19 +0200
Message-Id: <1213738939.3038.33.camel@uxmal>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re :  LinuxDVB for STi7109
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

Hi,

In that site you will only find their development framework (compiler
and friends), rootfs, kernel, u-boot and the few open source drivers
they support (like the one for DirectFB).

Their proprietary STAPI drivers (more than 20: i2c, frontends, demux,
display layers, blitter...) are only available to unfortunate customers
via their FTP site.

In the DVB case, they use a different design architecture (a heritage
from their OS21 operating system), so their DVB core and drivers are
different to the Linux DVB.

Regards,
-- 
Pedro Aguilar

On Fri, 2008-06-13 at 13:11 -0400, Steven Toth wrote:
> Mark H wrote:
> >  > Well if they run linux I dont see how they can provide a proprietary
> >  > implementation... I guess the shortest to get support on linux is to
> >  > ask them to release the source code!
> > I know there are many controversial discussions with respect to closed 
> > source
> > projects for Linux. The fact is that ST Microelectronics has implemented 
> > kernel
> > modules with a proprietary interface (STAPI) for the DVB and is not 
> > willing to
> > disclose the interface details to open source projects. On the other 
> > hand STM
> > provides STLinux distribution for boards based on STi7109 & Co. This 
> > distribution
> > contains open source drivers only the output part of the system (V4Land 
> > ALSA).
> > 
> > A copy of the chip datasheet is available on the web. Though, its 
> > legality is questionnable.
> > 
> > There have been some questions about the API two years ago so I was 
> > wondering
> > whether anybody has started working on an implementation.
> 
> Mark,
> 
> Do ST have a public site that I can download the STi7109 Linux 
> toolchain, tree and associated utils from?
> 
> Regards,
> 
> - Steve
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
