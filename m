Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48157 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751946AbaFUORp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 10:17:45 -0400
In-Reply-To: <6a19b39b-a20a-45b7-b889-611a39bf0325@email.android.com>
References: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com> <6a19b39b-a20a-45b7-b889-611a39bf0325@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Best way to add subdev that doesn't use I2C or SPI?
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 21 Jun 2014 10:17:42 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <152e45c7-d129-4cc5-918b-ae32b18bc540@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On June 21, 2014 7:17:07 AM EDT, Andy Walls <awalls@md.metrocast.net> wrote:
>On June 20, 2014 9:58:19 PM EDT, Devin Heitmueller
><dheitmueller@kernellabs.com> wrote:
>>Hello,
>>
>>I'm in the process of adding support for a new video decoder.  However
>>in this case it's an IP block on a USB bridge as opposed to the
>>typical case which is an I2C device.  Changing registers for the
>>subdev is the same mechanism as changing registers in the rest of the
>>bridge (a specific region of registers is allocated for the video
>>decoder).
>>
>>Doing a subdev driver seems like the logical approach to keep the
>>video decoder related routines separate from the rest of the bridge.
>>It also allows the reuse of the code if we find other cases where the
>>IP block is present in other devices.  However I'm not really sure
>>what the mechanics are for creating a subdev that isn't really an I2C
>>device.
>>
>>I think we've had similar cases with the Conexant parts where the Mako
>>was actually a block on the main bridge (i.e. cx23885/7/8, cx231xx).
>>But in that case the cx25840 subdev just issues I2C commands and
>>leverages the fact that you can talk to the parts over I2C even though
>>they're really on-chip.
>>
>>Are there any other cases today where we have a subdev that uses
>>traditional register access routines provided by the bridge driver to
>>read/write the video decoder registers?  In this case I would want to
>>reuse the register read/write routines provided by the bridge, which
>>ultimately are send as USB control messages.
>>
>>Any suggestions welcome (and in particular if you can point me to an
>>example case where this is already being done).
>>
>>Thanks in advance,
>>
>>Devin
>
>cx23888-ir
>cx18-av
>cx18-gpio
>
>I have a nonreleased one that uses SPI as well if you need an example
>of that.
>
>Regards,
>Andy
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I should mention that cx23888-ir and cx23885-ir both bring up interesting issues with IRQ handling and reuse.

Regarding interrupts:

cx23888-ir does all its interrupt handling work in the hard IRQ context; because it can, but it shouldn't. 

cx23885-ir uses a work queue to defer interrupt handling work, but that's not optimal for RT, as you can't tune concurrency managed work queue handler priorities for your work items.

Both should really be using a threaded IRQ handler.  That makes deferring work easy and tuning RT priority easy.


Regarding resue:

Both are using the same watermark level for triggering interrupts even though response times for direct vs. I2c connected is different. Also the IRQ mask registers between the block versions are inverted.  These sorts of things amount in code reuse pains.

Regards,
Andy
