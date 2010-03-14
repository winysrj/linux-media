Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:60488 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab0CNEKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 23:10:07 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135  
	variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Daro <ghost-rider@aster.pl>
Cc: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <4B9C4C13.1010801@aster.pl>
References: <E1Nl2po-000877-Di@services.gcu-squad.org>
	 <20100312103835.79b26455@hyperion.delvare>  <4B9C4C13.1010801@aster.pl>
Content-Type: text/plain
Date: Sun, 14 Mar 2010 06:08:47 +0100
Message-Id: <1268543327.3228.32.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 14.03.2010, 03:38 +0100 schrieb Daro:
> Hi Jean,
> 
> I am back and ready to go :)
> As I am not much experienced Linux user I would apprieciate some more 
> details:
> 
> I have few linux kernels installed; which one should I test or it does 
> not matter?
> 2.6.31-14-generic
> 2.6.31-16-generic
> 2.6.31-17-generic
> 2.6.31-19-generic
> 2.6.31-20-generic
> 
> and one I compiled myself
> 2.6.32.2
> 
> I assume that to proceed with a test I should patch the certain version 
> of kernel and compile it or could it be done other way?
> 
> Best regards
> Daro
> 
> 
> 
> W dniu 12.03.2010 10:38, Jean Delvare pisze:
> > Hi Daro,
> >
> > On Fri, 26 Feb 2010 17:19:38 +0100, Daro wrote:
> >    
> >> I did not forget I had offered to test the patch however I am now on vacation skiing so I will get back to you as soon I am back home.
> >>      
> > Are you back home by now? We are still waiting for your test results.
> > We can't push the patch upstream without it, and if it takes too long,
> > I'll probably just discard the patch and move to other tasks.
> >
> >    


Hi Daro,

thanks for being back on it.

Damned jokes aside, and not made. Sorry, let know if you have any
problems to get Jeans patch stuff applied.

Jean's review is good and valuable and we might to have to come back to
it, if stuff with the same PCI subsystem and different remotes is
validated to be out. (The LNA hell is even much more burning ;)

It very much looks like that is already the case.

It is a little confusing these days, "patch" p0, p1, hg or git patches.

I let it to Jean, how to test best for now, but will help to prepare you
with stuff you can test easily under any conditions.

Cheers,
Hermann







