Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53626 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab0KKMt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 07:49:59 -0500
Received: by wyb28 with SMTP id 28so654062wyb.19
        for <linux-media@vger.kernel.org>; Thu, 11 Nov 2010 04:49:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDBCEB6.6020405@redhat.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	<4CDBCEB6.6020405@redhat.com>
Date: Thu, 11 Nov 2010 13:49:57 +0100
Message-ID: <AANLkTi=c9ryV4r7mq14gGouf0-64no98tC7M6pH5BKRF@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
From: Markus Rechberger <mrechberger@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 12:08 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 11/10/2010 10:14 PM, Markus Rechberger wrote:
>>
>> On Wed, Nov 10, 2010 at 9:54 PM, Mohamed Ikbel Boulabiar
>> <boulabiar@gmail.com>  wrote:
>>>
>>> The bounty is already taken by that developer.
>>>
>>> But now, the Kinect thing is supported like a GPL userspace library.
>>> Maybe still need more work to be rewritten as a kernel module.
>>>
>>
>> This should better remain in userspace and interface libv4l/libv4l2 no
>> need to make things more complicated than they have to be.
>>
>
> As the author and maintainer of libv4l I say no, webcam drivers and
> the like belong in kernel space. libv4l is there to add things
> like format conversion (de-bayering in this case) which do not belong
> in userspace.
>
> Also there is no way to do 100% reliable isoc data handling from
> userspace.
>

That's just your opinion we have 100% reliable isoc data handling in
userspace, transferring 21 Mbyte/sec without any problem. And the
driver works from 2.6.15 on - without recompiling.
We're just about to release a new device in a few days, kernelsupport
is absolutely not interesting since most distributions would not ship
support for those devices at time of product release.

Best Regards,
Markus
