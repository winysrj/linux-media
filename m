Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49679 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1FIIwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 04:52:37 -0400
Received: by vxi39 with SMTP id 39so1004573vxi.19
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2011 01:52:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik=h0G+8z-z+rvD+ONv944LmOKthw@mail.gmail.com>
References: <BANLkTik=h0G+8z-z+rvD+ONv944LmOKthw@mail.gmail.com>
Date: Thu, 9 Jun 2011 02:52:36 -0600
Message-ID: <BANLkTin8chAxXg+vjziC11J2sZD52DHBYw@mail.gmail.com>
Subject: Re: How do I change a IR remotes keymap?
From: Dark Shadow <shadowofdarkness@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 8, 2011 at 10:23 PM, Dark Shadow <shadowofdarkness@gmail.com> wrote:
> I just got a Grey IR Hauppauge Remote working and I am now trying to
> setup the keymap for my XBMC HTPC but it seems some buttons don't even
> show up to XBMC's debugging mode.
>
> How do I modify the keymap loaded by the cx23885 module, I don't even
> know where it is.
>
> My most pressing concern is that the "OK" button on the remote can't
> be used with XBMC so I can't start anything.
>
>
> When I put the cx23885 module in debugging mode and XBMC in debugging
> mode. Then have to ssh terminals into it, one running "tail -f
> /var/log/syslog" and one doing the XBMC log.
> Then press most buttons entries show up in both logs but when I try a
> button like OK it is only the module debugging that shows the rx data
> but XBMC never sees anything that I can map to a function.
>
>
>
> Here is one press of the OK button how would I use this info in the
> modules keymap to make it work as a keyboards enter key
>
>
> Jun  8 21:52:25 htpc kernel: [  248.019314] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.019318] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.022854] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.022859] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.026418] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.026423] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.032541] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.032546] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.038770] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.038774] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.050099] cx23885[0]/888-ir: IRQ
> Status:  tsr     rto
> Jun  8 21:52:25 htpc kernel: [  248.050104] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.050127] cx23885[0]/888-ir: rx
> read:     851815 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050131] cx23885[0]/888-ir: rx
> read:     800407 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050134] cx23885[0]/888-ir: rx
> read:     826926 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050137] cx23885[0]/888-ir: rx
> read:     812407 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050140] cx23885[0]/888-ir: rx
> read:     827667 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050143] cx23885[0]/888-ir: rx
> read:     811815 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050146] cx23885[0]/888-ir: rx
> read:     826926 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050149] cx23885[0]/888-ir: rx
> read:     812704 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050153] cx23885[0]/888-ir: rx
> read:     850481 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050156] cx23885[0]/888-ir: rx
> read:     788852 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050159] cx23885[0]/888-ir: rx
> read:     826926 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050162] cx23885[0]/888-ir: rx
> read:     812704 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050165] cx23885[0]/888-ir: rx
> read:    1627519 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050168] cx23885[0]/888-ir: rx
> read:    1651222 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050171] cx23885[0]/888-ir: rx
> read:    1627519 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050177] cx23885[0]/888-ir: rx
> read:     786630 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050179] cx23885[0]/888-ir: rx
> read:     853444 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050181] cx23885[0]/888-ir: rx
> read:    1650926 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050183] cx23885[0]/888-ir: rx
> read:    1627074 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050185] cx23885[0]/888-ir: rx
> read:    1651667 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.050187] cx23885[0]/888-ir: rx
> read:     801148 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.050189] cx23885[0]/888-ir: rx
> read: end of rx
> Jun  8 21:52:25 htpc kernel: [  248.050191] cx23885[0]/888-ir: rx
> read:    9709000 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.132956] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.132961] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.136485] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.136491] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.139986] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.139992] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.146119] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.146124] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.152377] cx23885[0]/888-ir: IRQ
> Status:  tsr rsr             rby
> Jun  8 21:52:25 htpc kernel: [  248.152383] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.163681] cx23885[0]/888-ir: IRQ
> Status:  tsr     rto
> Jun  8 21:52:25 htpc kernel: [  248.163686] cx23885[0]/888-ir: IRQ
> Enables:     rse rte roe
> Jun  8 21:52:25 htpc kernel: [  248.163704] cx23885[0]/888-ir: rx
> read:     854333 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163707] cx23885[0]/888-ir: rx
> read:     798037 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163711] cx23885[0]/888-ir: rx
> read:     828259 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163714] cx23885[0]/888-ir: rx
> read:     811222 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163717] cx23885[0]/888-ir: rx
> read:     828852 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163720] cx23885[0]/888-ir: rx
> read:     810630 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163724] cx23885[0]/888-ir: rx
> read:     828852 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163727] cx23885[0]/888-ir: rx
> read:     810630 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163730] cx23885[0]/888-ir: rx
> read:     827815 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163764] cx23885[0]/888-ir: rx
> read:     811370 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163769] cx23885[0]/888-ir: rx
> read:     828704 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163773] cx23885[0]/888-ir: rx
> read:     811074 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163777] cx23885[0]/888-ir: rx
> read:    1629000 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163782] cx23885[0]/888-ir: rx
> read:    1649889 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163787] cx23885[0]/888-ir: rx
> read:    1651074 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163796] cx23885[0]/888-ir: rx
> read:     762926 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163798] cx23885[0]/888-ir: rx
> read:     854185 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163800] cx23885[0]/888-ir: rx
> read:    1650333 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163803] cx23885[0]/888-ir: rx
> read:    1628852 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163805] cx23885[0]/888-ir: rx
> read:    1650185 ns  space
> Jun  8 21:52:25 htpc kernel: [  248.163807] cx23885[0]/888-ir: rx
> read:     802778 ns  mark
> Jun  8 21:52:25 htpc kernel: [  248.163808] cx23885[0]/888-ir: rx
> read: end of rx
> Jun  8 21:52:25 htpc kernel: [  248.163810] cx23885[0]/888-ir: rx
> read:    9709000 ns  space
>

Ignore this I found out I still have to use lirc and now it is working fine
