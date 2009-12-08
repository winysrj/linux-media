Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50844 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966628AbZLHWdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 17:33:55 -0500
Date: 08 Dec 2009 23:27:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: dmitry.torokhov@gmail.com
Cc: awalls@radix.net
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: jonsmirl@gmail.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BEVi1jXHqgB@lirc>
In-Reply-To: <20091207075100.GB24958@core.coreip.homeip.net>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

on 06 Dec 09 at 23:51, Dmitry Torokhov wrote:
[...]
>>> I suppose we could add MSC_SCAN_END event so that we can transmit
>>> "scancodes" of arbitrary length. You'd get several MSC_SCAN followed by
>>> MSC_SCAN_END marker. If you don't get MSC_SCAN_END assume the code is 32
>>> bit.
>>
>> And I set a timeout to know that no MSC_SCAN_END will arrive? This is
>> broken design IMHO.
>>

> EV_SYN signals the end of state transmission.

>> Furthermore lircd needs to know the length of the scan code in bits, not
>> as a multiple of 32.

> I really do not think that LIRCD is the type of application that should
> be using evdev interface, but rather other way around.

Well, all I'm asking is that lircd can keep using the LIRC interface for  
getting the scan codes. ;-)

Christoph
