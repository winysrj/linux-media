Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 64.244.187.81.in-addr.arpa ([81.187.244.64]
	helo=bandit.ply.me.uk) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dvb@ply.me.uk>) id 1JesGN-0003mn-M0
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 14:35:30 +0100
From: Andy Carter <dvb@ply.me.uk>
To: linux-dvb@linuxtv.org
Date: Thu, 27 Mar 2008 13:35:21 +0000
References: <e40e29dd0803270213r39da40f3h4181589e85ba97b@mail.gmail.com>
	<200803271026.29470.dvb@ply.me.uk>
	<e40e29dd0803270556n15ad6c86i8c47049f2bab845b@mail.gmail.com>
In-Reply-To: <e40e29dd0803270556n15ad6c86i8c47049f2bab845b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803271335.21698.dvb@ply.me.uk>
Subject: Re: [linux-dvb] Recommendations for a DVB-T card for 2.6.24
Reply-To: dvb@ply.me.uk
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

On Thursday 27 March 2008 12:56:41 Eamonn Sullivan wrote:
> On Thu, Mar 27, 2008 at 10:26 AM, Andy Carter <dvb@ply.me.uk> wrote:
> > On Thursday 27 March 2008 10:14:07 Eamonn Sullivan wrote:
> >  > A standard, meaning an earlier version (not the 500)?
> >
> >  Yup, like the 909 on this page
> >
> >  http://www.hauppauge.co.uk/pages/products/prods_digital-t.html
> >
> >  These are standard PCI not the PCI/usb used by Nova T500 and similar
>
> I think the issue with this one, if I understand the reviews
> correctly, is that it lacks any on-board amplifier. Given that the
> Nova-T 500 is already receiving a much weaker signal than I get with a
> standard freeview box (is that a driver issue?), I think this could be
> a problem.

That's certainly true with my old setup with a 4 year old PCI card which 
required an aerial amp to function at all well - albeit on a standard antenna 
and standard coax drop lead. 

The Nova T500 does provide much better reception here, amp turned down 
considerably and noticeably less glitches and artefacts.

> I'm getting the impression that there aren't a whole lot of choices
> out there for DVB-T. I suppose I could also just use an older version
> of the Linux kernel, but unlike others here, the Nova-T 500 wasn't
> working very reliably for me under Ubuntu 7.10 either. It worked for
> maybe a day. I had a cron task to reboot the machine in the middle of
> the night, which was an ugly hack around that problem, and at least it
> would record most programs. But the remote wouldn't last longer than a
> few hours...

Not ideal :(

Incidentally if Phil Pemberton is reading this, my stable system is using an 
Intel usb chipset.

Andy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
