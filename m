Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:46782 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbZKPXZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 18:25:41 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 16 Nov 2009 17:25:34 -0600
Subject: RE: [PATCH 3/4 v7] TVP7002 driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C57E9@dlee06.ent.ti.com>
References: <1257889836-19208-1-git-send-email-santiago.nunez@ridgerun.com>
 <200911151416.00674.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401559C558C@dlee06.ent.ti.com>
 <200911162244.09409.hverkuil@xs4all.nl>
In-Reply-To: <200911162244.09409.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Please see my response below.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com
>>
>> I think Santiago based his driver on tvp514x which doesn't update the
>register until the chip is ready to stream. Only when STREAMON is called
>> the chip is powered On and the register values are configured. This looks
>> perfectly fine to me ( For example due to power savings considerations).
>> So please elaborate why you think this is not right. IMO, keeping the
>driver design similar to TVP514x helps in understanding the driver better.
>So unless you see a serious design flaw with this approach, I wouldn't
>change
>> the code.
>>
>> I would like Vaibhav's opinion as well since he is the owner of TVP514x
>> driver.
>
>OK, I took a closer look at both tvp5147 and tvp7002 and also went through
>the
>datasheets. As far as I am concerned both drivers are very weird...
>
>In both cases the devices start up in fully powered mode. Only the tvp514x
>will be powered off if s_stream(false) is called, but that happens only
>after
>streaming has started first. I would expect it to start up in powersaving
>mode,

Agree. I also looked at the device specs and feel that in the probe() after doing initialization of the registers, both 7002 and 514x may enter into a power saving mode (bit1 of register 0xf for 7002 and bit 0 of 0x3 of TVP514x). 

>otherwise it's rather pointless. And going in powersaving will preserve all
>register values on both devices as far as I can tell from the datasheets.

Correct.

>So
>why rewrite the registers again? Frankly, I see no reason why tvp514x uses
>the
>tvp514x_regs array.

Santiago just followed the tvp514x design since it is already reviewed and
accepted in the community. Now we know we can not make this assumption :(
Not sure why tvp514x code is written this way than writing the register values directly based on user inputs. I will let Vaibhav comment on this.

>
>And in the case of the tvp7002 I see no mention in the datasheet why you
>would
>need to power down and up in quick succession when you start streaming. Or
>why
>that would reset all registers for that matter since the i2c part always
>remains
>up.
>
>So I see this disconnect between what the drivers are doing and what I read
>in
>the datasheets. Perhaps there is some errata sheet or appnote somewhere
>that I
>don't know about, and in that case the drivers need to point to it or
>describe
>what is going on since right now it makes no sense to me.
>
>In general keeping shadow registers is bad coding practice. The only case I
>know where that is valid is with write-only registers. And that only tends
>to
>appear in really, really low-end devices.
>
>Actually, I tried to find examples of that, but the only two write-only
>devices
>I could find (wm8775.c and wm8739.c) were rewritten to avoid having to keep
>shadow registers.
>
>In all other devices I know of the i2c registers are never reset, so you
>can
>just configure them directly. Even if the i2c registers are reset at some
>point,
>then it is much better to just reconfigure the device by re-initializing
>the
>registers and updating them based on the configuration (e.g. preset and
>gain in
>the case of the tvp7002) stored in the driver state struct.
>
>You need to have functions to set the preset/gain/whatever anyway, so just
>call

I think in the probe(), All registers can be initialized
and then the chip can be put to power save mode. But I am not sure if registers can be updated in power save mode (Santiago, Could you check if this is possible?) based on user inputs. If not, shadow register is a way
to do it. I can't see any mention about that in the data sheet if i2c
registers can updated in power save mode. But in the case of tvp514x that
reason doesn't hold good since in probe() the chip is put to normal
operation. I think that is a bug in the tvp514x driver.

>them again.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

