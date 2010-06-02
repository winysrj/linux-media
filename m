Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:50297 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab0FBWut (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jun 2010 18:50:49 -0400
Received: by fg-out-1718.google.com with SMTP id l26so1897624fgb.1
        for <linux-media@vger.kernel.org>; Wed, 02 Jun 2010 15:50:48 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: semiRocket <semirocket@gmail.com>,
	"Davor Emard" <davoremard@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni> <20100509173243.GA8227@z60m> <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m> <op.vcsntos43xmt7q@crni> <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan> <20100531075214.GA17456@lipa.lan>
 <op.vdn7g9nj3xmt7q@crni> <20100602182757.GA22171@emard.lan>
Date: Thu, 03 Jun 2010 00:50:45 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: =?iso-8859-2?B?U2FtdWVsIFJha2l0bmnoYW4=?=
	<samuel.rakitnican@gmail.com>
Message-ID: <op.vdo22vmundeod6@crni>
In-Reply-To: <20100602182757.GA22171@emard.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 02 Jun 2010 20:27:59 +0200, Davor Emard <davoremard@gmail.com>  
wrote:

> HI!
>
> Have you tested my lastest GPIO suggestion, or come up
> with your own initialization? Does it allow
> to load firmware without windows booting?
>

Didn't have time to look for gpios, tomorrow I will have. But I can tell  
that this change is not working for me:

	case SAA7134_BOARD_VIDEOMATE_T750:
		dev->has_remote = SAA7134_REMOTE_GPIO;
		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8082c000, 0x8082c000);
		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x8082c000, 0x0080c000);
		break;

> Key namings of the remote must be some from linux input.h
> I welcome you to change whatever is needed to fit any of your
> application if current scheme is not suitable. I use VDR whcih
> can adapt to just anything event layer gives.
>
> d.

OK, I'm not having any personal opinion about the keys nor a application  
which I'm using, I'm just noticed that the keys differ against standard  
keys defined at linuxtv wiki. But if the keys at wiki are not correct,  
then perhaps should we change them there and let all use the same keys.

If we have standard keys, than userspace applications programmers can make  
a use of it and assign the keys to their applications and to have just  
work experience to their users. But maybe I'm terrible wrong...


Best regards,
Samuel
