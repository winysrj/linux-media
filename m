Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JdlgQ-0008Tg-N0
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 13:21:49 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id 4ABB3D88130
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 13:20:40 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <47E77895.8000708@ivor.org>
References: <1206139910.12138.34.camel@youkaida> <47E77895.8000708@ivor.org>
Date: Mon, 24 Mar 2008 12:20:39 +0000
Message-Id: <1206361239.7699.7.camel@acropora>
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

The more I look at logs, the more I believe that the i2c errors are not
the root of the problem.

They are just a consequence of something failing somewhere else.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
