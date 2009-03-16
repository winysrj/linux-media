Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:45539 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958AbZCPOnU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 10:43:20 -0400
Message-ID: <49BE657E.7040109@cam.ac.uk>
Date: Mon, 16 Mar 2009 14:43:10 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: RFC: ov7670 soc-camera driver
References: <49BD3669.1070409@cam.ac.uk> <20090315162338.3be11fec@bike.lwn.net>
In-Reply-To: <20090315162338.3be11fec@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonathan Corbet wrote:
> On Sun, 15 Mar 2009 17:10:01 +0000
> Jonathan Cameron <jic23@cam.ac.uk> wrote:
> 
>> The primary control on this chip related to shutter rate is actualy
>> the frame rate. There are rather complex (and largerly undocumented)
>> interactions between this setting and the auto brightness controls
>> etc. Anyone have any suggestions on a better way of specifying this?
> 
> Welcome to the world of the ov7670!  My conclusion, after working with
> this sensor, is that is consists of something like 150 analog tweakers
> disguised as digital registers.  Everything interacts with everything
> else, many of the settings are completely undocumented, and that's not
> to mention the weird multiplexor at 0x79.  It's hard to make this thing
> work if you don't have a blessed set of settings from OmniVision.
Hmm... And the grape vine / rumour says that they get most of their
'magic' values from customers who tweak the chips enough to get something
working.

Thanks for all the good work you put in.  Only other useful info was
the tinyos driver and that was a port of yours in the first place ;)

I'm particularly fond of the apparently obvious registers that won't
take a write unless something else is in a particular state.
> 
>> Clearly this driver shares considerable portions of code with
>> Jonathan Corbet's driver (in tree). It would be complex to combine
>> the two drivers, but perhaps people feel this would be worthwhile?
> 
> I think it's necessary, really.  Having two drivers for the same device
> seems like a bad idea.  As Hans noted, he's already put quite a bit of
> work into generalizing the ov7670 driver; I think it would be best to
> work with him to get a driver that works for everybody.
That sounds like a good plan.  Now all we need is some time ;)

Jonathan
