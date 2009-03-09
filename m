Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:20309 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZCIKf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 06:35:27 -0400
Received: by ey-out-2122.google.com with SMTP id 25so274946eya.37
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 03:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <af2e95fa0903051238g6c0b072n4890a0461e9f0b09@mail.gmail.com>
References: <af2e95fa0903051238g6c0b072n4890a0461e9f0b09@mail.gmail.com>
Date: Mon, 9 Mar 2009 11:35:24 +0100
Message-ID: <af2e95fa0903090335l75abb225n6af05b612eb08d8b@mail.gmail.com>
Subject: Re: saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solved,
Did an lspci -vvv and setting latency according to the cards needs (128).
Seems like all vpeirq: used 2 times >80% of buffer  and i2c errors are
gone now, the i2c errors might have disapperaed when I rearranged the
PCI cards and pulled the PVR-150 board.

/Henrik


On Thu, Mar 5, 2009 at 9:38 PM, Henrik Beckman <henrik.list@gmail.com> wrote:
> Hi list,
> I get errors on my DVB-C card,
>
> Mar  5 21:23:47 media kernel: [ 1489.968022] saa7146 (0)
> saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>
> Ubuntu 8.10, TT-1501-C with CI module.
> There is a PVR-150 in the adjacent PCI slot, if that matters I can try
> an switch them or remove the pvr board.
>
> any ideas
>
> /Henrik
>
