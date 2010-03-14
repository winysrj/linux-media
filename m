Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:12045 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab0CNPGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 11:06:05 -0400
Received: by ey-out-2122.google.com with SMTP id 25so198808eya.19
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 08:06:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197381003041252m7b547e2ehced781c59c1c6edc@mail.gmail.com>
References: <74fd948d1003031535r1785b36dq4cece00f349975af@mail.gmail.com>
	 <829197381003031548n703f0bf9sb44ce3527501c5c0@mail.gmail.com>
	 <74fd948d1003031700h187dbfd0v3f54800e652569b@mail.gmail.com>
	 <829197381003031706g1011f442hcc4be40ae2e79a47@mail.gmail.com>
	 <4B8F347E.2010206@gmail.com>
	 <74fd948d1003040314y2fc911f2k97b1d6fb66bdc0b9@mail.gmail.com>
	 <829197381003041139j7300bc7cg1281aff59e5a60b@mail.gmail.com>
	 <74fd948d1003041244s513dce3s69567cb9dbe31ae1@mail.gmail.com>
	 <829197381003041252m7b547e2ehced781c59c1c6edc@mail.gmail.com>
Date: Sun, 14 Mar 2010 15:06:03 +0000
Message-ID: <74fd948d1003140806tc32b263y634405b60bd10cd0@mail.gmail.com>
Subject: Re: Excessive rc polling interval in dvb_usb_dib0700 causes
	interference with USB soundcard
From: Pedro Ribeiro <pedrib@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 March 2010 20:52, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> On Thu, Mar 4, 2010 at 3:44 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>> I think you are right. I was to quick to blame it. It occurs whether
>> or not the DVB adapter is connected.
>>
>> Once again, thanks.
>>
>> Pedro
>
> Ok, that's great to hear.  I'm putting linux-media back into the CC in
> case anyone else finds this thread in the mailing list archives.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Hi Devin,

after some through investigation I found that your patch solves the
continuous interference.

However, I have a second problem. It is also interference but appears
to be quite random, by which I mean it is not at a fixed interval,
sometimes it happens past 10 seconds, other times past 30 seconds,
other times 2 to 5 seconds.

One thing is sure - it only happens when I'm actually streaming from
the DVB adapter. If I just plug it in, there is no interference. But
when I start vdr (for example) the interference starts.

The DVB adapter and the sound card are not sharing irq's or anything
like that, and there is no system freeze when the interference
happens. I also thought it was either my docking bay or power supply,
but definitely it isn't.

Any idea what can this be?

Thank you for your help,
Pedro
