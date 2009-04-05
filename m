Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55971 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZDELsl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 07:48:41 -0400
Date: Sun, 5 Apr 2009 08:47:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Kevin Wells <wells_kevin@yahoo.co.nz>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: tm6010 development repository
Message-ID: <20090405084731.4d67781b@pedra.chehab.org>
In-Reply-To: <49D7FF44.8010705@yahoo.co.nz>
References: <49D32574.1060908@yahoo.co.nz>
	<49D4CDBA.9060802@linuxtv.org>
	<49D7FF44.8010705@yahoo.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Sun, 05 Apr 2009 12:45:56 +1200
Kevin Wells <wells_kevin@yahoo.co.nz> wrote:

> Steven Toth wrote:
> > Kevin Wells wrote:
> >> I've started trying to understand the code in the following repository:
> >>
> >>     http://www.linuxtv.org/hg/~mchehab/tm6010/
> >>
> >> I have a few patches I would like to apply. How should I do this?
> > Submit the patches to the list and I'll try to get some time to create 
> > and maintain a ~stoth/tm6010 tree. I think I can get the nova-s-usb2 
> > running with just a little effort.
> Thanks Steve. Sorry for the slow reply. I'm doing this in my limited 
> spare time.
> 
> Patches to follow. Nothing exciting. Just trying to make the code more 
> robust. Patches are very granular. Let me know if that doesn't work for you.
> 
> Knowing the driver works on the nova-s-usb2 would be encouraging. I'm 
> trying to get it to work on an hvr-900h.

I'll merge those with some patches I have here. hvr-900h analog part is working
with a some troubles on the experimental tree I have here. A good thing to do,
after I merge yours and my patches, is to convert it to the new v4l2 dev/subdev
interface. I suspect that this will solve several bugs we currently have with
the i2c interface of this driver.

I intend to do this later this week, after the end of the merge window. For
now, I still have lots of patches to review, in order to submit for 2.6.30.

-- 

Cheers,
Mauro
