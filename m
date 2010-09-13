Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35484 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab0IMUlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 16:41:37 -0400
Received: by ewy23 with SMTP id 23so2886154ewy.19
        for <linux-media@vger.kernel.org>; Mon, 13 Sep 2010 13:41:36 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Need info to understand TeVii S470 cx23885 MSI  problem
Date: Mon, 13 Sep 2010 23:41:21 +0300
Cc: linux-media@vger.kernel.org
References: <1284321417.2394.10.camel@localhost> <201009132338.28664.liplianin@me.by>
In-Reply-To: <201009132338.28664.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009132341.21818.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 13 сентября 2010 23:38:28 автор Igor M. Liplianin написал:
> В сообщении от 12 сентября 2010 22:56:57 автор Andy Walls написал:
> > Igor,
> > 
> > To help understand the problem with the TeVii S470 CX23885 MSI not
> > working after module unload and reload, could you provide the output of
> > 
> > 	# lspci -d 14f1: -xxxx -vvvv
> > 
> > as root before the cx23885 module loads, after the module loads, and
> > after the module is removed and reloaded?
> > 
> > please also provide the MSI IRQ number listed in dmesg
> > (or /var/log/messages) assigned to the card.  Also the IRQ number of the
> > unhandled IRQ when the module is reloaded.
> > 
> > The linux kernel should be writing the MSI IRQ vector into the PCI
> > configuration space of the CX23885.  It looks like when you unload and
> > reload the cx23885 module, it is not changing the vector.
> > 
> > Regards,
> > Andy
> 
> Andy,
> Error appears only and if you zap actual channel(interrupts actually
> calls). First time module loaded and zapped some channel. At this point
> there is no errors. /proc/interrupts shows some irq's for cx23885.
> Then rmmod-insmod and szap again. Voilla! No irq vector.
> /proc/interrupts shows zero irq calls for cx23885.
> In my case Do_irq complains about irq 153, dmesq says cx23885 uses 45.
> 
> My first look not catch anything in lspci.
> For now I'm using workaround - find register and bit in cx23885 to write to
> disable MSI registers. In conjunction with particular card, naturally.
> 
> Regards
> Igor
Forget to mention. The tree is media_tree, branch staging/v2.6.37

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
