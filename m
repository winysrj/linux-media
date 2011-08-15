Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwmtas01p.mx.bigpond.com ([61.9.189.137]:23004 "EHLO
	nschwmtas01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633Ab1HONXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 09:23:43 -0400
From: Declan Mullen <declan.mullen@bigpond.com>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
Date: Mon, 15 Aug 2011 23:23:39 +1000
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201108150923.44824.declan.mullen@bigpond.com> <201108152232.46744.declan.mullen@bigpond.com> <CALzAhNW2iZA7f=hj+Kao055T-z5C-z4sArX7OE=JHU1DiyRx2Q@mail.gmail.com>
In-Reply-To: <CALzAhNW2iZA7f=hj+Kao055T-z5C-z4sArX7OE=JHU1DiyRx2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108152323.40265.declan.mullen@bigpond.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, August 15, 2011 11:04:03 pm Steven Toth wrote:
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

No worries. Many thanks for the clarification.

BTW, given that I only need the card's DVB-T functionality (don't need 
analog,...) could I get that by using ubuntu 10.10's existing driver and one 
of its card types  1to 8 ? If so, which card type would you recommend ?

Thanks,
Declan
