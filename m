Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61262 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab0KJV25 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 16:28:57 -0500
Received: by wyb36 with SMTP id 36so1155370wyb.19
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 13:28:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101110222418.6098a92a.ospite@studenti.unina.it>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	<20101110222418.6098a92a.ospite@studenti.unina.it>
Date: Wed, 10 Nov 2010 22:28:54 +0100
Message-ID: <AANLkTinkmeQ-fFcut8cqBav6qXOcQ9c-jFQsqXvgtAfp@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
From: Markus Rechberger <mrechberger@gmail.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> On Wed, 10 Nov 2010 22:14:36 +0100
> Markus Rechberger <mrechberger@gmail.com> wrote:
>
>> On Wed, Nov 10, 2010 at 9:54 PM, Mohamed Ikbel Boulabiar
>> <boulabiar@gmail.com> wrote:
>> > The bounty is already taken by that developer.
>> >
>> > But now, the Kinect thing is supported like a GPL userspace library.
>> > Maybe still need more work to be rewritten as a kernel module.
>> >
>>
>> This should better remain in userspace and interface libv4l/libv4l2 no
>> need to make things more complicated than they have to be.
>
> I can see at least two reasons for a kernel driver:
>  1. performance
>  2. out-of-the-box experience: the casual user who wants to just use
>    kinect as a normal webcam doesn't have to care about installing some
>    library

out of the box experience libusb works everywhere, ARM/MIPS/PPC/etc.
Kerneldrivers are usually not installed with those systems.
Higher backward compatibility as well (shall go down to 2.6.15) with
one compiled driver, relevant endusers do not want to compile believe
me. Developers might want but that's another story.

Markus

>
> If there are arguments against a kernel driver I can't see them yet.
>
> Ciao,
>   Antonio
>
> --
> Antonio Ospite
> http://ao2.it
>
> PGP public key ID: 0x4553B001
>
> A: Because it messes up the order in which people normally read text.
>   See http://en.wikipedia.org/wiki/Posting_style
> Q: Why is top-posting such a bad thing?
>
