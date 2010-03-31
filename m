Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36604 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0CaS0c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 14:26:32 -0400
Received: by bwz1 with SMTP id 1so299172bwz.21
        for <linux-media@vger.kernel.org>; Wed, 31 Mar 2010 11:26:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <n2w829197381003311045v8218dcb4o274b20197a58994f@mail.gmail.com>
References: <k2p5ba75e2f1003302211w2a7f4e0cy3fac5da36acc649@mail.gmail.com>
	 <n2w829197381003311045v8218dcb4o274b20197a58994f@mail.gmail.com>
Date: Wed, 31 Mar 2010 14:26:30 -0400
Message-ID: <o2i5ba75e2f1003311126h19314240pf2406a8c827959e8@mail.gmail.com>
Subject: Re: GIGABYTE U8000-RH Analog source support ?
From: =?UTF-8?Q?Fernando_P=2E_Garc=C3=ADa?= <fernando@develcuy.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So it needs 2.5 weeks, how much per hour do you estimate?

Blessings.

On Wed, Mar 31, 2010 at 1:45 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> 2010/3/31 Fernando P. García <fernandoparedesgarcia@gmail.com>:
>> May you elaborate about the "huge undertaking"
>>
>> Fernando.
>
> The issue is the dvb-usb framework on which the dib0700 driver is
> built has absolutely no support for analog.  Adding support for a new
> bridge (both raw video and PCM audio) is on the order of 100 hours of
> work for somebody who knows what they are doing.  It includes adding
> all the V4L2 hooks and ioctls(), reverse engineering the format of the
> delivered video, inserting the video into videobuf, reverse
> engineering how audio is provided by the hardware (and how it is
> controlled), and creating an ALSA driver to handle the audio feed.
>
> Oh, and then you have to debug all the edge cases.
>
> I did it for the au0828 bridge, and I'm in the middle of doing it for
> the ngene bridge.  It's a royal PITA and at this point no developer is
> willing to invest the time/energy to do it for free.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>



-- 
Fernando P. García, http://www.develcuy.com
+51 1 9 8991 7871, Calle Santa Catalina Ancha #377, Cusco - Perú

** Before printing this message, please consider your commitment with
the environment, taking care of it depends on you.
** Antes de imprimir este mensaje piensa en tu compromiso con el medio
ambiente, protegerlo depende de tí.
