Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33773 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZCIQ6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 12:58:52 -0400
Received: by ewy25 with SMTP id 25so932031ewy.37
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 09:58:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <af2e95fa0903090335l75abb225n6af05b612eb08d8b@mail.gmail.com>
References: <af2e95fa0903051238g6c0b072n4890a0461e9f0b09@mail.gmail.com>
	 <af2e95fa0903090335l75abb225n6af05b612eb08d8b@mail.gmail.com>
Date: Mon, 9 Mar 2009 17:58:49 +0100
Message-ID: <af2e95fa0903090958g77f63bfevef52333a34c5fc93@mail.gmail.com>
Subject: Re: saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
From: Henrik Beckman <henrik.list@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

not,
saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
uname -a
Linux media 2.6.27-11-generic #1 SMP Thu Jan 29 19:24:39 UTC 2009 i686 GNU/Linux

Is this a regression or has it always almost worked.

/Henrik

On Mon, Mar 9, 2009 at 11:35 AM, Henrik Beckman <henrik.list@gmail.com> wrote:
> Solved,
> Did an lspci -vvv and setting latency according to the cards needs (128).
> Seems like all vpeirq: used 2 times >80% of buffer  and i2c errors are
> gone now, the i2c errors might have disapperaed when I rearranged the
> PCI cards and pulled the PVR-150 board.
>
> /Henrik
>
>
> On Thu, Mar 5, 2009 at 9:38 PM, Henrik Beckman <henrik.list@gmail.com> wrote:
>> Hi list,
>> I get errors on my DVB-C card,
>>
>> Mar  5 21:23:47 media kernel: [ 1489.968022] saa7146 (0)
>> saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
>>
>> Ubuntu 8.10, TT-1501-C with CI module.
>> There is a PVR-150 in the adjacent PCI slot, if that matters I can try
>> an switch them or remove the pvr board.
>>
>> any ideas
>>
>> /Henrik
>>
>
