Return-path: <linux-media-owner@vger.kernel.org>
Received: from web31503.mail.mud.yahoo.com ([68.142.198.132]:49128 "HELO
	web31503.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752173AbZJSG2x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 02:28:53 -0400
Message-ID: <93004.23373.qm@web31503.mail.mud.yahoo.com>
Date: Sun, 18 Oct 2009 23:28:57 -0700 (PDT)
From: Ming-Ching Tiew <mctiew@yahoo.com>
Subject: Re: Gadmei 380 on kernel 2.6.28.4
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Message below :-

> From: Ming-Ching Tiew <mctiew@yahoo.com>
> Subject: Re: Gadmei 380 on kernel 2.6.28.4
> To: linux-media@vger.kernel.org
> Date: Monday, October 12, 2009, 8:31 AM
> I did a dmesg, include please find
> the output. If you see
> carefully, towards the end, there is a USB driver error,
> and my KINGSTON usb thumb drive get disconnected and 
> reconnected again.
> 
> --- On Mon, 10/12/09, mctiew <mctiew@yahoo.com>
> wrote:
> 
> > From: mctiew <mctiew@yahoo.com>
> > Subject: Gadmei 380 on kernel 2.6.28.4
> > To: linux-media@vger.kernel.org
> > Date: Monday, October 12, 2009, 3:32 AM
> > 
> > I am trying to use the gadmei 380 which I bought
> > yesterday.
> > 
> > I am using kernel 2.6.28.4, I downloaded the entire
> > ~dougsland/em28xx
> > and did a make and install. Everything went on
> smoothly.
> > However,
> > when I plug in the gadmei 380 usb device, it seems
> the
> > driver can 
> > get loaded by the usb pnp, but at the same time, one
> of my
> > usb 
> > pendrive will get disconnected. Because that's my
> boot
> > drive 
> > ( I boot off from the usb drive ), that will cause
> problem
> > with 
> > my system.
> > 
> > Anyone has experienced this before ?
> > 
> >

No one is working on this ? Is there a similar device which
I can use as a reference ? I am thinking maybe I need to
modify the usb storage driver to ignore this device much
like this thread ? 

http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg54175.html

Regards.




      
