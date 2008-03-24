Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1Jdm8f-0004sa-6a
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 13:51:00 +0100
From: Jonas Anden <jonas@anden.nu>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <1206352930.7699.2.camel@acropora>
References: <1206139910.12138.34.camel@youkaida> <47E77895.8000708@ivor.org>
	<1206352930.7699.2.camel@acropora>
Date: Mon, 24 Mar 2008 13:49:30 +0100
Message-Id: <1206362971.5058.4.camel@anden.nu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-T-500 disconnects - They are back!
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

A wild guess (bash me on the head if I'm wrong), but when you switched
kernel, did you do 'make distclean' in your v4l-dvb directory? Unless
you do, the code will keep compiling (and installing) for the previous
kernel, and your new kernel will only use the stock drivers. That would
explain why you're seeing disconnects again. I made that mistake once...

  // J

On Mon, 2008-03-24 at 10:02 +0000, Nicolas Will wrote:
> On Mon, 2008-03-24 at 09:47 +0000, Ivor Hewitt wrote:
> > 
> > Nicolas Will wrote:
> > > Guys,
> > >
> > > I have upgraded my system to the new Ubuntu (8.04 Hardy), using
> > 2.6.24,
> > > 64-bit.
> > >   
> > Just thought I'd add, in case anyone was wondering, that I'm still
> > not 
> > having any problems with vanilla 2.6.22.19 and current v4l-dvb tree.
> > MythTV multirec with eit scanning enabled.
> > One or two I2C read failed a day in the kernel log, and an occasional 
> > I2C write failed.
> 
> That was exactly my situation before upgrading my system, which brought
> the new kernel version.
> 
> Now, with 2.6.24, the disconnects are back with a vengeance, just as it
> was nearly a year ago.
> 
> I hope that the logs provided will help shed a light on this.
> 
> If not, I'm ready to turn debug on on all I can, even if it means
> generating gigs of logs.
> 
> Nico
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
