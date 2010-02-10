Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:17610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab0BJVYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 16:24:35 -0500
Received: by fg-out-1718.google.com with SMTP id e21so27888fga.1
        for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 13:24:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com>
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com>
	 <f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com>
	 <f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com>
	 <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
	 <4B731A10.9000108@redhat.com>
	 <829197381002101255x2af2776ftd1c7a7d32584946@mail.gmail.com>
	 <f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com>
Date: Wed, 10 Feb 2010 16:24:33 -0500
Message-ID: <829197381002101324i600c0fbdtdae2b5fac4b84f35@mail.gmail.com>
Subject: Re: Want to help in MSI TV VOX USB 2.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 10, 2010 at 4:10 PM, Carlos Jenkins
<carlos.jenkins.perez@gmail.com> wrote:
> 2010/2/10 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> On Wed, Feb 10, 2010 at 3:41 PM, Mauro Carvalho Chehab
>> Does the device even have a tuner?  I had assumed all the em2862
> It's a em2820 to be exact.
>
>> reference designs just did s-video and composite capture.
>
> This device has S-Video, Composite and TVTuner.
> This is the device:
> http://www.msi.com/uploads/Image/product_img/other/multimedia/vox_view.jpg
>
>>This one is a bit different than the others though, since it has a tvp5150 as
>> opposed to a saa7113.
>
> It has a saa7114H, I'm sure, I opened it and looked at the chips :P

Sorry about that.  I'm actually working a couple of different em28xx
issues this morning, and got yours confused with the other issue.

Well, if it actually has a tuner, then it is unlikely that any
existing board profile is going to help (ruling out the ability to
just use a "card=").  Do you know what tuner it contains?  Can you
provide some hi-res photos of the internals of the device?

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
