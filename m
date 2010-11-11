Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0KKLH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 06:07:28 -0500
Message-ID: <4CDBCEB6.6020405@redhat.com>
Date: Thu, 11 Nov 2010 12:08:38 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
Subject: Re: Bounty for the first Open Source driver for Kinect
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com> <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
In-Reply-To: <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 11/10/2010 10:14 PM, Markus Rechberger wrote:
> On Wed, Nov 10, 2010 at 9:54 PM, Mohamed Ikbel Boulabiar
> <boulabiar@gmail.com>  wrote:
>> The bounty is already taken by that developer.
>>
>> But now, the Kinect thing is supported like a GPL userspace library.
>> Maybe still need more work to be rewritten as a kernel module.
>>
>
> This should better remain in userspace and interface libv4l/libv4l2 no
> need to make things more complicated than they have to be.
>

As the author and maintainer of libv4l I say no, webcam drivers and
the like belong in kernel space. libv4l is there to add things
like format conversion (de-bayering in this case) which do not belong
in userspace.

Also there is no way to do 100% reliable isoc data handling from
userspace.

Regards,

Hans
