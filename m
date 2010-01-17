Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32707.mail.mud.yahoo.com ([68.142.207.251]:39302 "HELO
	web32707.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750851Ab0AQHFd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 02:05:33 -0500
Message-ID: <245243.78544.qm@web32707.mail.mud.yahoo.com>
Date: Sat, 16 Jan 2010 23:05:32 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <802509.22940.qm@web32703.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin, 

> > I'm actually not really concerned about it's
> interaction
> > with a demod.
> >  I'm more worried about other products that have
> > saa711[345] that use
> > a bridge other than em28xx.  The introduction of
> power
> > management
> > could always expose bugs in those bridges (I had this
> > problem in
> > several different cases where I had to fix problems
> in
> > other drivers
> > because of the introduction of power management).
> > 

I retested my device and tried several different GPIO sequences but so far every time I change between the Analog and digital interface, the SAA7113 needs to be reinitialized.  I tried leaving both the digital and analog interfaces enabled by setting the GPIO to 7c but then the LG demod does not initialize.  

Either way it looks like I will have to reinitialize the device after switching between interfaces.  

Other than that do you want me to remove the suspend GPIO?  Since I don't have the equipment to measure the power, I don't know for a fact if the device really has been put in a suspend state or not.  

Thanks,
Franklin Meng


      
