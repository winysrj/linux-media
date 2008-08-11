Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: hermann pitton <hermann-pitton@arcor.de>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <489EED7B.9030905@linuxtv.org>
References: <ee0ad0230808100543g1578d37bqbae9b32def5a9f7f@mail.gmail.com>
	<489EED7B.9030905@linuxtv.org>
Date: Tue, 12 Aug 2008 00:52:34 +0200
Message-Id: <1218495154.2676.84.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVT-1000S Support Development Assistance Offer
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

Hi Steve,

Am Sonntag, den 10.08.2008, 09:30 -0400 schrieb Steven Toth:
> Damien Morrissey wrote:
> > Dear all,
> > I have recently purchased a DTV-1000S before realising it was not 
> > supported (for the price I took a punt). However, the card seems good 
> > under Windows and I would like to use it with MythTV under linux.
> > 
> > If anyone out there is working on a driver for this card and I can be of 
> > any assistance, please let me know. I run mythbuntu with mythtv 0.21+fixes.
> 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg27620.html
> 
> saa7130 + tda18271 + tda10048.
> 
> The kernel has support for all of these, so you need to talk with the 
> saa7130 maintainer. With PCI and GPIO details it's possible to make this 
> work.
> 
> If you haven't done so already, please take some decent close-up 
> pictures and ensure the wiki at linuxtv.org is up to date.
> 
> - Steve

looking it up again, I remember what made me especially annoyed on
Leadtek in this case and that we took already a first run on it.

http://www.leadtek.com/eng/support/download.asp?downlineid=207&downline=WINFAST%20DTV1000%20S

Claiming to have copyrights to defend on Philips/NXP readable .inf files
seems to be totally out of any feasible horizon, especially after what
we have seen going on in Taiwan sometimes.

For the analog side, we don't need them at all and I strongly guess it
is the same for the rest.

Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
