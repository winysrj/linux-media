Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:62909 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZJIIVp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 04:21:45 -0400
Received: by ewy4 with SMTP id 4so398509ewy.37
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 01:21:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACEED7D.10302@koala.ie>
References: <4ACDF829.3010500@xfce.org>
	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>
	 <4ACDFED9.30606@xfce.org>
	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>
	 <4ACE2D5B.4080603@xfce.org>
	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>
	 <d9def9db0910080946r445ac0efs421cb3bd2972a0d8@mail.gmail.com>
	 <4ACEED7D.10302@koala.ie>
Date: Fri, 9 Oct 2009 10:21:07 +0200
Message-ID: <d9def9db0910090121i76571d0o4778aa14026b4b9d@mail.gmail.com>
Subject: Re: Hauppage WinTV-HVR-900H
From: Markus Rechberger <mrechberger@gmail.com>
To: Simon Kenyon <simon@koala.ie>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 9, 2009 at 9:59 AM, Simon Kenyon <simon@koala.ie> wrote:
> Markus Rechberger wrote:
>>
>> Aside of that we also fully support Linux
>>
>> http://support.sundtek.de/index.php/topic,4.0.html
>>
>> http://support.sundtek.de/index.php/topic,7.0.html
>>
>> We also use to report bugs to Distributors in order to improve general
>> Multimedia Support.
>> Customers also get dedicated support as far as needed in order to get
>> everything work properly (if needed).
>>
>> Best Regards,
>> Markus
>>
>
> binary driver for very expensive and unavailable hardware

Available from 20th Oct on so in 11 days. There are not many
competitive devices (none) available for
linux which deliver such support. On the other side it's not kernel
based either, it's entirely in userspace.
It's also  entirely supported by all participating companies.
The driver is using the same components as the Windows driver.
There's no way to crash the kernel with that driver, and it works from
2.6.15 kernelseries on
without having to fiddle around.
In any case it's up to the customer if he wants an easy installation
or a complicated one,
similar devices for Mac are available at a higher price.
Even though when drivers are officially in the kernel still not all
distributions are shipping all the kernel drivers
especially the firmware isn't shipped with most distributions either.
We do have customers who are not comfortable with having to compile
kernelmodules and just want
to have it work.
Another positive side effect every system can use the same driver,
updates are easily possible for everyone
(unlike kernel drivers for such devices which have to be recompiled
for every system).
The installation of it usually takes below 10 seconds on any system we
tested (Ubuntu, Redhat, Suse, Sidux,
Gentoo, Acer One Netbook, Arch Linux)

Best Regards,
Markus
