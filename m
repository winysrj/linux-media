Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:45689 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZEVQgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 12:36:17 -0400
Received: by yx-out-2324.google.com with SMTP id 3so1084687yxj.1
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 09:36:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380905220828i2b8cf7e4h6f067b996fd72fab@mail.gmail.com>
References: <1243003530.24983.8.camel@pc67246619>
	 <829197380905220828i2b8cf7e4h6f067b996fd72fab@mail.gmail.com>
Date: Fri, 22 May 2009 18:36:17 +0200
Message-ID: <d9def9db0905220936r6b37c7ferd7cefec0afc18ff0@mail.gmail.com>
Subject: Re: Review of the Linux driver for the TerraTec Cinergy HTC USB XS HD
	stick
From: Markus Rechberger <mrechberger@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Ad Denissen <ad.denissen@hccnet.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 22, 2009 at 5:28 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Fri, May 22, 2009 at 10:45 AM, Ad Denissen <ad.denissen@hccnet.nl> wrote:
>> Hi Markus,
>>
>> I have a TerraTec Cinergy HTC USB XS HD stick and more than 10 years of
>> experience with Linux (drivers).
>>
>> This USB stick works fine under Windows, but I need it under Linux
>> for my MythTV experiments in DVB-C mode.
>>
>> Can I help you in the cleanup of the Linux driver for this device?
>>
>> Kind regards,
>>
>> Ad Denissen
>
> Hello Ad,
>
> The TerraTec Cinergy HTC USB XS HD makes use of the Micronas drx-k
> demodulator.  There is currently no driver at all for this device in
> the mainline Linux kernel.  As a result, getting the device to work in
> the mainline kernel is much more than "cleanup".
>
> Markus's support for the drx-k uses his closed source product, and
> therefore is not eligible for inclusion in the Linux kernel.  You may
> wish to contact him though if you are interested in a commercial
> closed source solution.
>

You still mistake that the important drivers are not implemented in
Kernelspace, because
of that there will never be a _requirement_ to merge the chipdrivers
in order to get it work.
For example DVB-C/T, all control commands are sent to the frontend
device node all those
commands are intercepted at userlevel while still being compatible
with legacy applications like
kaffeine or dvbscan.

regards,
Markus
