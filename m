Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246]:43755 "HELO
	web32702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754284Ab0AQTCq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 14:02:46 -0500
Message-ID: <87348.88308.qm@web32702.mail.mud.yahoo.com>
Date: Sun, 17 Jan 2010 11:02:44 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <829197381001170828t33b63c0ayf9b26472f702dd90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OK.. I guess that was a misunderstanding on my part.  I will split up the patch and re submit.  

Thanks,
Franklin

--- On Sun, 1/17/10, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> Subject: Re: Kworld 315U and SAA7113?
> To: "Franklin Meng" <fmeng2002@yahoo.com>
> Cc: linux-media@vger.kernel.org
> Date: Sunday, January 17, 2010, 8:28 AM
> On Sun, Jan 17, 2010 at 2:05 AM,
> Franklin Meng <fmeng2002@yahoo.com>
> wrote:
> > I retested my device and tried several different GPIO
> sequences but so far every time I change between the Analog
> and digital interface, the SAA7113 needs to be
> reinitialized.  I tried leaving both the digital and analog
> interfaces enabled by setting the GPIO to 7c but then the LG
> demod does not initialize.
> >
> > Either way it looks like I will have to reinitialize
> the device after switching between interfaces.
> >
> > Other than that do you want me to remove the suspend
> GPIO?  Since I don't have the equipment to measure the
> power, I don't know for a fact if the device really has been
> put in a suspend state or not.
> 
> Hello Franklin,
> 
> Just to be clear, I'm not proposing that you remove the
> suspend logic.
>  I was suggesting that you should be breaking the change
> into three
> separate patches, so that if a problem arises we can
> isolate whether
> it is a result of the power management changes. 
> Having a separate
> patch is especially valuable because you are touching other
> drivers
> which are shared by other products.
> 
> Cheers,
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> 


      
