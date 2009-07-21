Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:49623 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZGUOYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 10:24:00 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KN400FIXYNTY5O0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 21 Jul 2009 10:23:55 -0400 (EDT)
Date: Tue, 21 Jul 2009 10:23:53 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
In-reply-to: <200907201650.23749.jarod@redhat.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Message-id: <4A65CF79.1040703@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <200907201020.47581.jarod@redhat.com>
 <Pine.LNX.4.58.0907201240490.11911@shell2.speakeasy.net>
 <200907201650.23749.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hrm, okay, I'll double-check that... If its not there, perhaps the card
> isn't quite seated correctly. Or the machine is bunk. Or the card has
> gone belly up. Amusing that it works as much as it does though, if any
> of the above is the case...
>
> Thanks for the info!
>

Jrod,

Yeah. If the pci enable bit for the transport engine is not enabled (thus 
showing up as pci device 8802) then I'm going to be surprised if the risc engine 
runs up at all (or runs perfectly).

I've seen issue like this in the past with various cx88 boards and it invariable 
turn out to be a corrupt eeprom or a badly seated PCI card.

or, no eeprom at all (unlikely on this board).

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
