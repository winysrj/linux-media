Return-path: <linux-media-owner@vger.kernel.org>
Received: from nskntqsrv01p.mx.bigpond.com ([61.9.168.231]:39929 "EHLO
	nskntqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352Ab1HQPVg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 11:21:36 -0400
From: Declan Mullen <declan.mullen@bigpond.com>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
Date: Wed, 17 Aug 2011 22:33:53 +1000
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201108150923.44824.declan.mullen@bigpond.com> <201108152232.46744.declan.mullen@bigpond.com> <CALzAhNW2iZA7f=hj+Kao055T-z5C-z4sArX7OE=JHU1DiyRx2Q@mail.gmail.com>
In-Reply-To: <CALzAhNW2iZA7f=hj+Kao055T-z5C-z4sArX7OE=JHU1DiyRx2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108172233.53829.declan.mullen@bigpond.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 15 August 2011 23:04:03 Steven Toth wrote:
> > So how do I get a 8940 edition of a HVR-2200 working with Ubuntu ?
> 
> Hello Declan,
> 
> You'll need to install the entire new kernel and all of its modules,
> you should avoid cherry picking small pieces.
> 
> Incidentally, I've had confirmation from another user that the tree
> works and automatically detects type 9 cards.
> 
> - Steve

Hi Steve

I'm wanting to get the source for a version of the saa7164 driver that 
supports my 8940 revision of the HVR-2200 card. 

I've had a look at the version in "git clone 
git://kernellabs.com/stoth/saa7164-stable.git", but it doesn't seem to support 
the 8940 revision.

Could you please recommend where/how I should get a version of the source that 
does support this card revision. Many thanks.

Eg should I use the source from "git clone git://kernellabs.com/stoth/saa7164-
dev.git" or do you recommend something else that might be more stable ?

Many thanks,
Declan

