Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.27]:61510 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZIIRJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2009 13:09:58 -0400
Message-ID: <4AA7E166.7030906@gmail.com>
Date: Wed, 09 Sep 2009 19:09:58 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: Samuel Rakitnican <samuel.rakitnican@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com> <op.uzzz96se6dn9rq@crni>
In-Reply-To: <op.uzzz96se6dn9rq@crni>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Samuel Rakitnican a écrit :
>
> No, this is used for some autodetection routine for different version 
> of the same card. This has nothing to do with your case.
>
> The key is here, you need to find correct value.
>
>     case SAA7134_BOARD_ADS_INSTANT_TV:
>         ir_codes = AdsInstantTvPci_codes;
>         // This remote seems to return 0x7f after each button is pushed.
>         // No button may be repeated ; no release message. Only 1 msg 
> with
>         // raw data = button idx, followed by one message with raw 
> data = 0x7f
>         mask_keycode = 0xffffff;
>         mask_keyup   = 0xffffff;
>         mask_keydown = 0xffffff;
>         polling      = 50; // ms
>         break;
>
> Have you tried to follow the tutorial on the web?, By tutorial you 
> need to modify with something like this:
>
>     case SAA7134_BOARD_ADS_INSTANT_TV:
>         ir_codes = AdsInstantTvPci_codes;
>         mask_keycode = 0;
>         polling      = 50; // ms
>         break;
>
> And then try to find correct gpio masks.
>
i did try it ( well, i left the keyup and keydown part and i also tried 
it by setting it to 0 ) but the gpio still repeat ("saa7133[0]/ir: 
build_key gpio=0x1b mask=0x0 data=0" for Power and Record, each followed 
by gpio=7f ).
Which is why i believe i am missing part of that code ( got the dvb-t 
version too on another computer, and given the software used, there 
should be no duplicate keys ).
I guess i will have to wait for someone to solve the problem. I can at 
least use the remote in a "broken" way.


