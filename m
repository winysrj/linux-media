Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JdjXB-0001oM-Sw
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 11:04:08 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id F313DD8812A
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 11:02:20 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <47E77895.8000708@ivor.org>
References: <1206139910.12138.34.camel@youkaida> <47E77895.8000708@ivor.org>
Date: Mon, 24 Mar 2008 10:02:10 +0000
Message-Id: <1206352930.7699.2.camel@acropora>
Mime-Version: 1.0
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

On Mon, 2008-03-24 at 09:47 +0000, Ivor Hewitt wrote:
> 
> Nicolas Will wrote:
> > Guys,
> >
> > I have upgraded my system to the new Ubuntu (8.04 Hardy), using
> 2.6.24,
> > 64-bit.
> >   
> Just thought I'd add, in case anyone was wondering, that I'm still
> not 
> having any problems with vanilla 2.6.22.19 and current v4l-dvb tree.
> MythTV multirec with eit scanning enabled.
> One or two I2C read failed a day in the kernel log, and an occasional 
> I2C write failed.

That was exactly my situation before upgrading my system, which brought
the new kernel version.

Now, with 2.6.24, the disconnects are back with a vengeance, just as it
was nearly a year ago.

I hope that the logs provided will help shed a light on this.

If not, I'm ready to turn debug on on all I can, even if it means
generating gigs of logs.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
