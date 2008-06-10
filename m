Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1K6DTJ-0003uI-A9
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 01:41:50 +0200
From: Andy Walls <awalls@radix.net>
To: Andreas <linuxdreas@launchnet.com>
In-Reply-To: <200806101419.09700.linuxdreas@launchnet.com>
References: <de8cad4d0806101321x659cdec7n77714ba6e69cb563@mail.gmail.com>
	<484EE2EC.40501@linuxtv.org>
	<200806101419.09700.linuxdreas@launchnet.com>
Date: Tue, 10 Jun 2008 19:42:03 -0400
Message-Id: <1213141323.3196.33.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 multiple cards question
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

On Tue, 2008-06-10 at 14:19 -0700, Andreas wrote:
> Am Dienstag, 10. Juni 2008 13:24:12 schrieb Steven Toth:
> > Brandon Jenkins wrote:
> > > Greetings,
> > >
> > > I currently have 3 HVR-1600 cards installed in my system. I am able to
> > > get analog signal on all 3, but the ATSC scanning does not return any
> > > data on the third card. I have swapped cables with a known working
> > > card, but this does not resolve the issue.
> > >
> > > 2 of the cards are brand new, dmesg output seems to indicate no
> > > issues. Does anyone know if there is an issue with 3 HD tuners? Is
> > > there a method of trouble shooting I should follow?
> >
> > Remove the two working cards and test the failing card, report back.
> 
> I don't know if it would help in this case, but it is generally a good idea 
> to change PCI slots as well.



Change one variable at a time.  Either change PCI slots and retest or
remove two cards and retest.  Don't do both before retesting, as you
won't know which action "fixed" the problem, if the symptoms go away.

-Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
