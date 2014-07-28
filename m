Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43400 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaG1IaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 04:30:18 -0400
Received: by mail-oa0-f52.google.com with SMTP id o6so8204064oag.25
        for <linux-media@vger.kernel.org>; Mon, 28 Jul 2014 01:30:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140728072043.GW16460@valkosipuli.retiisi.org.uk>
References: <53D12786.5050906@InUnum.com>
	<CA+2YH7v8bQG4K2Gz8aB9_BOHwuK_1nGDxU102S7EBnsMGEuwKA@mail.gmail.com>
	<20140728072043.GW16460@valkosipuli.retiisi.org.uk>
Date: Mon, 28 Jul 2014 10:30:17 +0200
Message-ID: <CA+2YH7sDWOP-JLEQLuCEmacSN85C2NZKfU+KoG9KP3ejVUQkWg@mail.gmail.com>
Subject: Re: omap3isp with DM3730 not working?!
From: Enrico <ebutera@users.sourceforge.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Michael Dietschi <michael.dietschi@inunum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 28, 2014 at 9:20 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Enrico and Michael,
>
> On Thu, Jul 24, 2014 at 05:57:30PM +0200, Enrico wrote:
>> On Thu, Jul 24, 2014 at 5:34 PM, Michael Dietschi
>> <michael.dietschi@inunum.com> wrote:
>> > Hello,
>> >
>> > I have built a Poky image for Gumstix Overo and added support for a TVP5151
>> > module like described here http://www.sleepyrobot.com/?p=253.
>> > It does work well with an Overo board which hosts an OMAP3530 SoC. But when
>> > I try with an Overo hosting a DM3730 it does not work: yavta just seems to
>> > wait forever :(
>> >
>> > I did track it down to the point that IRQ0STATUS_CCDC_VD0_IRQ seems never be
>> > set but always IRQ0STATUS_CCDC_VD1_IRQ
>
> VD1 takes place in 2/3 of the frame, and VD0 in the beginning of the last
> line. You could check perhaps if you do get VD0 if you set it to take place
> on the previous line (i.e. the register value being height - 3; please see
> ccdc_configure() in ispccdc.c).
>
> I have to admit I haven't used the parallel interface so perhaps others
> could have more insightful comments on how to debug this.
>
>> > Can someone please give me a hint?
>>
>> It's strange that you get the vd1_irq because it should not be set by
>> the driver and never trigger...
>
> Both VD0 and VD1 are used by the omap3isp driver, but in different points of
> the frame.

Hi Sakari,

that's true in "normal" mode, but with bt656 patches VD1 is not used.

Enrico
