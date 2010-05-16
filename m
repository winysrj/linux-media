Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63766 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab0EPKiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 06:38:07 -0400
Received: by fxm6 with SMTP id 6so2826038fxm.19
        for <linux-media@vger.kernel.org>; Sun, 16 May 2010 03:38:06 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: Emard <davoremard@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <20100508160628.GA6050@z60m> <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni> <20100509173243.GA8227@z60m> <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m>
Date: Sun, 16 May 2010 12:38:03 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: semiRocket <semirocket@gmail.com>
Message-ID: <op.vcsntos43xmt7q@crni>
In-Reply-To: <20100509231535.GA6334@z60m>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 May 2010 01:15:35 +0200, Emard <davoremard@gmail.com> wrote:

> HI
>
> This is even more cleanup from spaces into tabs
> and replacing KEY_BACKSPACE with KEY_BACK
> which I think is more appropriate for this remote.
>
> compro t750f patch v17
>
> About the remote - I noticed 2-10% of the keypresses
> are not recognized, seems like it either looses packets
> or saa7134 gpio should be scanned faster/better/more_reliable?
> I think this may be the issue with other 7134 based
> remotes too
>
> Best Regards, Emard
>

Hi Davor,


Unfortunately it doesn't work for me. It can't load firmware like before,  
I've attached patch against recent hg tree I applied manually (without IR  
code part) and dmesg output.

In tvtime it shows black screen in PAL mode, if switch to SECAM, it's  
still black screen but with some random flickering occurring represented  
by horizontal red/green lines. No white/black dots noise present.

Thanks,
Samuel
