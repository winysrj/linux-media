Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40206 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1AaIQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 03:16:29 -0500
Received: by iwn9 with SMTP id 9so5126554iwn.19
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 00:16:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinXYi6edyaQKec=oJ_DLf5AHeqyZd564mUArebt@mail.gmail.com>
References: <AANLkTinXYi6edyaQKec=oJ_DLf5AHeqyZd564mUArebt@mail.gmail.com>
Date: Mon, 31 Jan 2011 09:16:26 +0100
Message-ID: <AANLkTimfae4pU4R3Xk2Hji0syJH22qmC-fyd23OQh3nv@mail.gmail.com>
Subject: Re: AF9015 Problem
From: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

El 30/01/2011 14:03, "David Ondracek" <david.ondracek@gmx.de> escribió:
>
> Hi there,

Hi.

> I have a problem using my DIGITRADE DVB-T stick, which is marked as fully supported in the wiki. It works fine for a while, but after some time it crashes and I have to reboot and disconnect the stick to make it work again (for a while)

The same thing happens to me with two different af9015 tuner sticks,
an Avermedia Volar Black and a dual KWorld DVB-T-USB 399U (which
happens to have other problems too due to its dual nature not being
completely supported).

In the end, I had to look for a tuner stick with a different chip set
(and that proved to be a challenge itself due to the apparent
popularity of af9015 among manufacturers) so that my mythtv rig would
be dependable.

> by looking at the dmesg, I found out a strange thing: an af9013 (yes, THREE at the end) device is recognized and registred also.

This is normal. It's a part of the device. An older chip model
(demodulator) that got integrated into the more modern af9015 (USB
bridge plus demodulator in the same package).

> is anyone running this device stable and/or have an idea what i could do to get rid of the problem?

As I said, I'm unable to do so either. I guess it happens to
everybody, but not many people seems to be using it for an intensive
PVR setup on Linux. If it's that way, perhaps we should edit the
linuxtv wiki pages to include a big fat warning for prospective
buyers.

Best regards,
   Juan Jesús.



--
:wq
