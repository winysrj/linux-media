Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail35.syd.optusnet.com.au ([211.29.133.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darrinritter@optusnet.com.au>) id 1JXbvS-0007MM-Ep
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 13:43:57 +0100
Received: from [192.168.1.250] (d220-238-157-74.dsl.vic.optusnet.com.au
	[220.238.157.74]) (authenticated sender darrinritter)
	by mail35.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m27Chd8h030022
	for <linux-dvb@linuxtv.org>; Fri, 7 Mar 2008 23:43:39 +1100
Message-ID: <47D1387F.6050509@optusnet.com.au>
Date: Fri, 07 Mar 2008 23:13:43 +1030
From: Darrin Ritter <darrinritter@optusnet.com.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [Fwd: Re: TV cards]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all
Im forwarding this email as suggested by LinuxSA mailing list

Im interested in your response, it would be a shame to see this patch 
lost due to being sent to the wrong list.

thanks Darrin

-------- Original Message --------
Subject: 	Re: TV cards
Date: 	Fri, 7 Mar 2008 13:35:49 +1030
From: 	Mike Lampard <mike@mtgambier.net>
To: 	linuxsa@linuxsa.org.au
CC: 	Darrin Ritter <darrinritter@optusnet.com.au>
References: 	<47D0A029.3060404@optusnet.com.au>



Hi Darrin,

On Friday 07 March 2008 12:23:45 Darrin Ritter wrote:
> Hi all
>
> Well after some deliberation I decided to take the plunge and install a
> TV card in my mythbox. So I did my research and found that there were 2
> that suited me. the Leadtek 1000T and the Leadtek 2000H, the first was
> superseded  by the 1000S so I had to go with the 2000H card.
>
> After some considerable time I managed to get a picture out of it and I
> had to specify  in the /etc/modprobe.d/options  "options cx88xx card=51"
> (with out the quotation marks) to get the kernel to recognize the card
> and now I have picture but no sound.
>
> after further research I found the the card that I bought was version J
> instead of version i that currently already works and then I found this
> post in lkml list
> http://lkml.org/lkml/2008/2/6/289
> the text below
>
>     Hello all,
>
> I bought Leadtek WinFast DTV2000H, but it didn't work. I found, that
> there are two types of this card. Type I (older), and type J (latest)
> ... and only type I is supported by the module.
>
> Type J is not autodetected, and if you force card type (card = 51),
> DVB-T works, but there is no sound in analogue television. I know why
> (multiplexer, which is switching between the radio, TV, and external
> sound is driven by GPIO pins ... and setting of this pins is wrong), and
> I wrote a patch, which makes this card (DTV2000H type J) works.
>
> With this patch, card is autodetected, I'm having sound in analogue
> television, I can switch between antenna, and cable signal input, and I
> can see video from external S-video and composite video input.
>
> So ... I'm sending this patch to you. I think it will be good to add
> support for this card to the cx88xx module.
>
> Bye,
>
>
>     Zbynek Hrabovsky, Brno, Czech Republic
>
> It would appear that this would solve my problem but where do I go from
> here? is there a way of checking that the patch actually made it into
> the kernel? can I patch the kernel myself and rebuild it?
>
> I'm using Ubuntu Gutsy 32 bit on a athlon64 3000 with 512MB ram
>
> any help appreciated
>
> Thanks Darrin

It appears there was no response on the Linux Kernel mailinglist to the 
original post, so I don't know for sure if the patch was applied upstream, 
but a quick scan of the kernel changelogs doesn't look positive.  The poster 
didn't send the patch to the linux-dvb mailinglist either afaics, so it may 
have been missed completely.

You can try to apply the patch to your Linux kernel source, however depending 
on how recent your kernel version is you may need to do a bit of manual 
editing to one or more of the cx88 source files.

I'd suggest joining the linux-dvb@linuxtv.org mailinglist, and maybe sending 
your original email to that list, as the patch is more likely to be picked up 
if posted there (it's where the dvb driver developers hang out).  They may 
also know of an alternative method for enabling your card.

Good Luck
Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
