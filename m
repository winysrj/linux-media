Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KBdtW-0001RF-DA
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 00:55:26 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K3100BIXJLUJQ20@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 25 Jun 2008 18:53:55 -0400 (EDT)
Date: Wed, 25 Jun 2008 18:53:54 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080625223207.289C832675A@ws1-8.us4.outblaze.com>
To: stev391@email.com
Message-id: <4862CC82.3000205@linuxtv.org>
MIME-version: 1.0
References: <20080625223207.289C832675A@ws1-8.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
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

stev391@email.com wrote:
> Steve,
> 
> I have found the cause of my DMA timeouts, as per your suggestion I 
> checked the sram settings.
> The cause of the issue was in SRAM_CH06 cdt, this was originally set to 
> 0x10480 and is currently set to 0x108d0.  In changeset 7005:a6d2028a4aab 
> you introduced this as an alternative set of values and then in 
> changeset 7464:20a1412b4f1a it was all converted to these values.  I was 
> wondering why this value was required to change?
> 
> I have not yet had the time to analyse these values in detail, but the 
> following are possible options that I/we can persue:
> 
> 1) Set the value back to 0x10480 (diff attached), the following 
> supported cards will use this value (from a quick glance):
>     CX23885_BOARD_HAUPPAUGE_HVR1800lp
>     CX23885_BOARD_HAUPPAUGE_HVR1800
>     CX23885_BOARD_HAUPPAUGE_HVR1250
>     CX23885_BOARD_HAUPPAUGE_HVR1500Q
>     CX23885_BOARD_HAUPPAUGE_HVR1500
>     CX23885_BOARD_HAUPPAUGE_HVR1200
>     CX23885_BOARD_HAUPPAUGE_HVR1700
>     CX23885_BOARD_HAUPPAUGE_HVR1400
>     CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP
> 
> 2) Introduce another variable in struct cx23885_board to allow board 
> specific srams.  The sram would not be duplicated in this struct, a 
> second version would be included in cx23885-core.c (similar to the 7005 
> changeset except it is now manual configurable and not switching on PCI 
> id). The down side of this is the cx23885-core.c will be slightly 
> larger, with a larger memory footprint.
> 
> 3) Reallocate entire sram, this would require a detailed look on my 
> behalf to see how much space each variable requires and reallocate it.  
> This will potentially break the cards mentioned in option 1 and will 
> take more time to implement and test. This is highly undesirable my 
> viewpoint.
> 
> 4) Something else? Please suggest a solution...
> 
> Regards,
> 
> Stephen
> 
> diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-core.c 
> v4l-dvb1/linux/drivers/media/video/cx23885/cx23885-core.c
> --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-core.c    
> 2008-06-06 14:57:55.000000000 +1000
> +++ v4l-dvb1/linux/drivers/media/video/cx23885/cx23885-core.c   
> 2008-06-26 08:26:42.000000000 +1000
> @@ -142,7 +142,7 @@
>                 .name           = "TS2 C",
>                 .cmds_start     = 0x10140,
>                 .ctrl_start     = 0x10680,
> -               .cdt            = 0x108d0,
> +               .cdt            = 0x10480,
>                 .fifo_start     = 0x6000,
>                 .fifo_size      = 0x1000,
>                 .ptr1_reg       = DMA5_PTR1,
> 
>     ----- Original Message -----
>     From: "Steven Toth"
>     To: stev391@email.com
>     Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
>     Date: Mon, 23 Jun 2008 08:51:10 -0400
> 
>     No need to try windows, if you have the driver already running
>     (pascoe's patches) then your chipset and hardware are fine.
> 
>     Sounds like you have a simple merge issue.
> 
>     Try to figure out which parts of the merge actually create the
>     problem then bring that issue back to this list for discussion.
> 
>     Regards,
> 
>     - Steve

Let me go back and look at the existing layout. Something is obviously 
wrong.

We don't want board specific values.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
