Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:45316 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZGVPyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 11:54:41 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KN600G0FXIXAA50@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 22 Jul 2009 11:54:35 -0400 (EDT)
Date: Wed, 22 Jul 2009 11:54:32 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
In-reply-to: <20090722114806.39c8c1ea.bhepple@promptu.com>
To: Bob Hepple <bhepple@promptu.com>
Cc: linux-media@vger.kernel.org
Message-id: <4A673638.2090001@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <200907201020.47581.jarod@redhat.com>
 <200907201650.23749.jarod@redhat.com> <4A65CF79.1040703@kernellabs.com>
 <200907212135.47557.jarod@redhat.com>
 <20090722114806.39c8c1ea.bhepple@promptu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7/21/09 9:48 PM, Bob Hepple wrote:
> On Tue, 21 Jul 2009 21:35:47 -0400
> Jarod Wilson<jarod@redhat.com>  wrote:
>
>> So its either I have *two* machines with bad, but only slightly bad,
>> and in the same way, PCI slots which seem to work fine with any other
>> card I have (uh, unlikely),
>
> ... not unlikely if the two machines are similar - many motherboards
> have borked PCI slots in one way or another - design faults or
> idiosyncratic interpretation of the PCI standard.  I've seen it with
> HP, Compaq, Digital m/bs just to name big names, smaller mfrs also get
> it wrong. Sometimes just using another slot helps. Sometimes you need
> to try a totally different motherboard.
>
> Maybe wrong to 'blame' the m/b mfr - it could just as easily be an
> out-of-spec or creatively interpreted PCI standard on the card.

My guess is that the eeprom was trashed.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
