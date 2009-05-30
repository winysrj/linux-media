Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34354 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZE3Joc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 May 2009 05:44:32 -0400
Received: by bwz22 with SMTP id 22so6567004bwz.37
        for <linux-media@vger.kernel.org>; Sat, 30 May 2009 02:44:32 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [SOLVED] Re: [linux-dvb] SDMC DM1105N not being detected
Date: Sat, 30 May 2009 12:44:27 +0300
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A1C4AF1.6020200@koala.ie> <4A1FA9EC.4050405@koala.ie>
In-Reply-To: <4A1FA9EC.4050405@koala.ie>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Message-Id: <200905301244.27490.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29 мая 2009, "Igor M. Liplianin" <liplianin@me.by>, linux-media-owner@vger.kernel.org wrote:
> Simon Kenyon wrote:
> > Igor M. Liplianin wrote:
> >> The card is working with external LNB power supply, for example,
> >> through the loop out from another sat box. So, we need to know, which
> >> way to control LNB power on the board. Usually it is through GPIO pins.
> >> For example:
> >> Pins 112 and 111 for GPIO0, GPIO1. Also GPIO15 is at 65 pin.
> >> You can edit this lines in code:
> >> -*-*-*-*-*-*-*-*-*-*-*-*-
> >> /* GPIO's for LNB power control for Axess DM05 */
> >> #define DM05_LNB_MASK                           0xfffffffc  // GPIO
> >> control
> >> #define DM05_LNB_13V                            0x3fffd // GPIO value
> >> #define DM05_LNB_18V                            0x3fffc // GPIO value
> >> -*-*-*-*-*-*-*-*-*-*-*-*-
> >>
> >> BTW:
> >> Bit value 0 for GPIOCTL means output, 1 - input.
> >> Bit value for GPIOVAL - read/write.
> >> GPIO pins count is 18. Bits over 18 affect nothing.
> >
> > i will try to work out the correct values
> > when i have done so (or given up trying) i will let you know
> >
> > thank you very much for your help
> > --
> > simon
>
> well i thought i had sent out the correct information yesterday - but it
> seems that the email didn't leave my machine
Hi Simon,
You forget to add linux-media@vger.kernel.org to recepients list.

> of well! the correct settings are:
>
> /* GPIO's for LNB power control for DM05 */
> #define DM05_LNB_MASK                           0x00000000
> #define DM05_LNB_13V                            0x00020000
> #define DM05_LNB_18V                            0x00030000
>
> with these values the card can control the LNB
> it locks very quickly and gives good picture results (with kaffeine and
> mythtv)
> i am very pleased with this card so far
>
> i have not tried it behind a diseqc switch yet. i might have a go this
> weekend
> that would be the icing on the cake.
>
> would it be possible to push this into linuxtv.org?
>
> thanks for your help
> --
> simon
>
> PS by the way, putting a value of 0x00020001 in DM05_LNB_18V crashes the
> machine - so don't do that :-)
So, without crashes it is not possible to write drivers :)

> i found this out when trying to find the correct values
Thank you for resolving this.
I will prepair patch for linuxtv to test.
Then after you test and confirm, I will commit.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
