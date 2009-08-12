Return-path: <linux-media-owner@vger.kernel.org>
Received: from jordan.toaster.net ([69.36.241.228]:1481 "EHLO
	jordan.toaster.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZHLV4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 17:56:18 -0400
Message-ID: <4A833A39.2000305@toaster.net>
Date: Wed, 12 Aug 2009 14:55:05 -0700
From: Sean <knife@toaster.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Hans de Goede <hdegoede@redhat.com>
Subject: Re: capture-example.c crash on close_device()
References: <4A79E6A3.7050508@toaster.net>
In-Reply-To: <4A79E6A3.7050508@toaster.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

What do you think is causing this? pac207 driver.

Sean

Sean wrote:
> Hi,
>
> I have compiled kernel 2.6.30 from kernel.org, and I have also 
> compiled capture-example.c from the mercurial depository. These work 
> on laptop hardware, but on my DM&P e-box 2300SX (with vortex86 cpu), 
> capture-example.c crashes the system. Complete lockup, no keyboard, 
> etc. I turned on all debuging in gspca_main, i.e. options gspca_main 
> debug=0x1FF. I also put print statements in capture-example.c in 
> main() before each function call. Here is the output below. Has anyone 
> had this problem?
>
> -------
> # capture-example -r
> <snip>
> gspca: packet [28] o:28644 l:126
> gspca: add t:2 l:126
> gspca: packet [31] o:31713 l:630
> pac207: SOF found, bytes to analyze: 630. Frame starts at byte #19
> gspca: add t:3 l:14
> gspca: frame complete len:26496 q:1 i:0 o:1
> gspca: add t:1 l:0
> gspca: add t:2 l:600
> gspca: poll
> gspca: read (202752)
> gspca: dqbuf
> gspca: frame wait q:1 i:0 o:0
> gspca: autogain: lum: 252, desired: 102, steps: 5
> gspca: dqbuf 1
> gspca: qbuf 1
> gspca: qbuf q:0 i:0 o:0
> .stop_capturing()
> uninit_device()
> close_device()
> gspca: capture-example close
> gspca: kill transfer
> gspca: isoc irq
> gspca: isoc irq
> gspca: isoc irq
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
