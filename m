Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59838 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0FCRRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 13:17:06 -0400
Received: by bwz11 with SMTP id 11so103849bwz.19
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 10:17:03 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: "Davor Emard" <davoremard@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <20100509173243.GA8227@z60m> <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m> <op.vcsntos43xmt7q@crni> <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan> <20100531075214.GA17456@lipa.lan>
 <op.vdn7g9nj3xmt7q@crni> <20100602182757.GA22171@emard.lan>
 <op.vdo22vmundeod6@crni> <20100603140403.GA22382@emard.lan>
Date: Thu, 03 Jun 2010 19:17:00 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.vdqiamq63xmt7q@crni>
In-Reply-To: <20100603140403.GA22382@emard.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 03 Jun 2010 16:04:07 +0200, Davor Emard <davoremard@gmail.com>  
wrote:

>> Didn't have time to look for gpios, tomorrow I will have. But I can
>> tell that this change is not working for me:
>>
>> 	case SAA7134_BOARD_VIDEOMATE_T750:
>> 		dev->has_remote = SAA7134_REMOTE_GPIO;
>> 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8082c000, 0x8082c000);
>> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x8082c000, 0x0080c000);
>> 		break;
>
> Thanx for testing it out, If it doesn't work, try this:
>
> saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   /* keep */ 0x8082c000, /* keep  
> */   0x8082c000);
> saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, /* keep */ 0x8082c000, /* modify  
> */ 0x0080c000);
>
> modify only the indicated number, try 0, try 0x8082c000 and if
> you have time try all combinations of bits 0x8082c000 optionally set to 0
> e.g. 0x8002c000, 0x8080c000, 0x80828000, 0x0080c000 etc...
>
> It is possible that you and I don't have same revision of the
> card and you need a slightly different initialization procedure.
> If you get something to work for your card then I can try it back at
> mine there's a changes that we get a common setup which works for both.
>

OK, do I need to do cold boot or reboot anytime I try different gpio value?
