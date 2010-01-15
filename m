Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32703.mail.mud.yahoo.com ([68.142.207.247]:46613 "HELO
	web32703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750695Ab0AODDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 22:03:54 -0500
Message-ID: <802509.22940.qm@web32703.mail.mud.yahoo.com>
Date: Thu, 14 Jan 2010 19:03:52 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: CityK <cityk@rogers.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <829197381001141409i6b666e78t175aadf31fd93b68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Actually I was a bit short sighted here.  I was referring to devices in the em28xx tree.  

In the case of the SAA7113 device, there really is no power saving feature unless a hardware pin is pulled down (or up I don't remember).  The pin will basically reset the device.  

>From my testing it seems like the power on defaults don't fully enable the device which is why I added the reinitialization to the s_power routine.  

Thanks,
Franklin Meng

--- On Thu, 1/14/10, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> Subject: Re: Kworld 315U and SAA7113?
> To: "CityK" <cityk@rogers.com>
> Cc: "Franklin Meng" <fmeng2002@yahoo.com>, linux-media@vger.kernel.org
> Date: Thursday, January 14, 2010, 2:09 PM
> On Thu, Jan 14, 2010 at 5:00 PM,
> CityK <cityk@rogers.com>
> wrote:
> > Franklin Meng wrote:
> >> As far as I can tell, the Kworld 315U is the only
> board that uses this combination of parts..  Thomson tuner,
> LG demod, and SAA7113.  I don't think any other device has
> used the SAA7113 together with a digital demod.  Most
> products seem to only have the SAA711X on an analog only
> board.  Since I don't have any other USB adapters with the
> SAA chip I was unable to do any further testing on the SAA
> code changes.
> >>
> >
> > IIRC, a couple of the Sasem/OnAir devices use a
> saa7113 together with a
> > digital demod. I seem to also recall something else,
> though maybe I'm
> > mistaken.
> 
> I'm actually not really concerned about it's interaction
> with a demod.
>  I'm more worried about other products that have
> saa711[345] that use
> a bridge other than em28xx.  The introduction of power
> management
> could always expose bugs in those bridges (I had this
> problem in
> several different cases where I had to fix problems in
> other drivers
> because of the introduction of power management).
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


      
