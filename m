Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:49276 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZGVQGG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 12:06:06 -0400
Received: by gxk9 with SMTP id 9so494350gxk.13
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 09:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A673638.2090001@kernellabs.com>
References: <200907201020.47581.jarod@redhat.com>
	 <200907201650.23749.jarod@redhat.com>
	 <4A65CF79.1040703@kernellabs.com>
	 <200907212135.47557.jarod@redhat.com>
	 <20090722114806.39c8c1ea.bhepple@promptu.com>
	 <4A673638.2090001@kernellabs.com>
Date: Wed, 22 Jul 2009 12:06:05 -0400
Message-ID: <829197380907220906q1bfacf45nad4a6e5b45230c3c@mail.gmail.com>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Cc: Bob Hepple <bhepple@promptu.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 22, 2009 at 11:54 AM, Steven Toth<stoth@kernellabs.com> wrote:
> On 7/21/09 9:48 PM, Bob Hepple wrote:
>>
>> On Tue, 21 Jul 2009 21:35:47 -0400
>> Jarod Wilson<jarod@redhat.com>  wrote:
>>
>>> So its either I have *two* machines with bad, but only slightly bad,
>>> and in the same way, PCI slots which seem to work fine with any other
>>> card I have (uh, unlikely),
>>
>> ... not unlikely if the two machines are similar - many motherboards
>> have borked PCI slots in one way or another - design faults or
>> idiosyncratic interpretation of the PCI standard.  I've seen it with
>> HP, Compaq, Digital m/bs just to name big names, smaller mfrs also get
>> it wrong. Sometimes just using another slot helps. Sometimes you need
>> to try a totally different motherboard.
>>
>> Maybe wrong to 'blame' the m/b mfr - it could just as easily be an
>> out-of-spec or creatively interpreted PCI standard on the card.
>
> My guess is that the eeprom was trashed.

I hate to be the one to make this observation, but since this card is
specifically targeted at the Linux market, has anyone considered
reaching out to the vendor to ask for help?

If their card really is broken in current kernels, I would think a
company that specializes in selling Linux tuner products would be
interested in such.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
