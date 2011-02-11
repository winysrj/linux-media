Return-path: <mchehab@pedra>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:47972
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758320Ab1BKWqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 17:46:14 -0500
Message-ID: <Sv75ntDxqbVNFwXa@echelon.upsilon.org.uk>
Date: Fri, 11 Feb 2011 22:39:45 +0000
To: linux-media@vger.kernel.org, skandalfo@gmail.com
From: dave cunningham <news004@upsilon.org.uk>
Subject: Re: AF9015 Problem
References: <AANLkTinXYi6edyaQKec=oJ_DLf5AHeqyZd564mUArebt@mail.gmail.com>
 <AANLkTimfae4pU4R3Xk2Hji0syJH22qmC-fyd23OQh3nv@mail.gmail.com>
In-Reply-To: <AANLkTimfae4pU4R3Xk2Hji0syJH22qmC-fyd23OQh3nv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1;format=flowed
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

In message 
<AANLkTimfae4pU4R3Xk2Hji0syJH22qmC-fyd23OQh3nv@mail.gmail.com>, Juan 
Jesús García de Soria Lucena wrote

>El 30/01/2011 14:03, "David Ondracek" <david.ondracek@gmx.de> escribió:
>>
>> Hi there,
>
>Hi.
>
>> I have a problem using my DIGITRADE DVB-T stick, which is marked as 
>>fully supported in the wiki. It works fine for a while, but after some 
>>time it crashes and I have to reboot and disconnect the stick to make 
>>it work again (for a while)
>
>The same thing happens to me with two different af9015 tuner sticks,
>an Avermedia Volar Black and a dual KWorld DVB-T-USB 399U (which
>happens to have other problems too due to its dual nature not being
>completely supported).
>
>In the end, I had to look for a tuner stick with a different chip set
>(and that proved to be a challenge itself due to the apparent
>popularity of af9015 among manufacturers) so that my mythtv rig would
>be dependable.
>

Do you mind me asking what you ended up with?

I've got similar problems with af9015. I have a Tevion stick that works 
with the V4L HG tree and 4.65 firmware but locks up the machine with the 
git tree and/or any other firmware version. I also have a KWorld 399U 
which causes the machine to lock up with any firmware/driver version 
I've tried.

Previous to these I had 3 WT-220U sticks running stable in an Epia 
mythtv backend. I 'upgraded' the backend to an AMD system and all 3 
started locking up the system - hence the move to af9015!

Regards,
-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
