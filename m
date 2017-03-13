Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34444 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdCMRGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 13:06:40 -0400
Subject: Re: [PATCH v5 15/39] [media] v4l2: add a frame interval error event
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-16-git-send-email-steve_longerbeam@mentor.com>
 <5b0a0e76-2524-4140-5ccc-380a8f949cfa@xs4all.nl>
 <ec05e6e0-79f2-2db2-bde9-4aed00d76faa@gmail.com>
 <6b574476-77df-0e25-a4d1-32d4fe0aec12@xs4all.nl>
 <5d5cf4a4-a4d3-586e-cd16-54f543dfcce9@gmail.com>
 <aa6a5a1d-18fd-8bed-a349-2654d2d1abe0@xs4all.nl>
 <20170313104538.GF21222@n2100.armlinux.org.uk>
 <b36875e0-683a-fcc3-343d-9ddd1a39cac0@xs4all.nl>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <bb2d078d-1c2f-ad67-d98f-bde3894601d6@gmail.com>
Date: Mon, 13 Mar 2017 10:06:35 -0700
MIME-Version: 1.0
In-Reply-To: <b36875e0-683a-fcc3-343d-9ddd1a39cac0@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/13/2017 03:53 AM, Hans Verkuil wrote:
> On 03/13/2017 11:45 AM, Russell King - ARM Linux wrote:
>> On Mon, Mar 13, 2017 at 11:02:34AM +0100, Hans Verkuil wrote:
>>> On 03/11/2017 07:14 PM, Steve Longerbeam wrote:
>>>> The event must be user visible, otherwise the user has no indication
>>>> the error, and can't correct it by stream restart.
>>>
>>> In that case the driver can detect this and call vb2_queue_error. It's
>>> what it is there for.
>>>
>>> The event doesn't help you since only this driver has this issue. So nobody
>>> will watch this event, unless it is sw specifically written for this SoC.
>>>
>>> Much better to call vb2_queue_error to signal a fatal error (which this
>>> apparently is) since there are more drivers that do this, and vivid supports
>>> triggering this condition as well.
>>
>> So today, I can fiddle around with the IMX219 registers to help gain
>> an understanding of how this sensor works.  Several of the registers
>> (such as the PLL setup [*]) require me to disable streaming on the
>> sensor while changing them.
>>
>> This is something I've done many times while testing various ideas,
>> and is my primary way of figuring out and testing such things.
>>
>> Whenever I resume streaming (provided I've let the sensor stop
>> streaming at a frame boundary) it resumes as if nothing happened.  If I
>> stop the sensor mid-frame, then I get the rolling issue that Steve
>> reports, but once the top of the frame becomes aligned with the top of
>> the capture, everything then becomes stable again as if nothing happened.
>>
>> The side effect of what you're proposing is that when I disable streaming
>> at the sensor by poking at its registers, rather than the capture just
>> stopping, an error is going to be delivered to gstreamer, and gstreamer
>> is going to exit, taking the entire capture process down.
>>
>> This severely restricts the ability to be able to develop and test
>> sensor drivers.
>>
>> So, I strongly disagree with you.
>>
>> Loss of capture frames is not necessarily a fatal error - as I have been
>> saying repeatedly.  In Steve's case, there's some unknown interaction
>> between the source and iMX6 hardware that is causing the instability,
>> but that is simply not true of other sources, and I oppose any idea that
>> we should cripple the iMX6 side of the capture based upon just one
>> hardware combination where this is a problem.
>>
>> Steve suggested that the problem could be in the iMX6 CSI block - and I
>> note comparing Steve's code with the code in FSL's repository that there
>> are some changes that are missing in Steve's code to do with the CCIR656
>> sync code setup, particularly for >8 bit.  The progressive CCIR656 8-bit
>> setup looks pretty similar though - but I think what needs to be asked
>> is whether the same problem is visible using the FSL/NXP vendor kernel.
>>
>>
>> * - the PLL setup is something that requires research at the moment.
>> Sony's official position (even to their customers) is that they do not
>> supply the necessary information, instead they expect customers to tell
>> them the capture settings they want, and Sony will throw the values into
>> a spreadsheet, and they'll supply the register settings back to the
>> customer.  Hence, the only way to proceed with a generic driver for
>> this sensor is to experiment, and experimenting requires the ability to
>> pause the stream at the sensor while making changes.  Take this away,
>> and we're stuck with the tables-of-register-settings-for-set-of-fixed-
>> capture-settings approach.  I've made a lot of progress away from this
>> which is all down to the flexibility afforded by _not_ killing the
>> capture process.
>>
>
> In other words: Steve should either find a proper fix for this, or only
> call vb2_queue_error in this specific case. Sending an event that nobody
> will know how to handle or what to do with is pretty pointless IMHO.
>
> Let's just give him time to try and figure out the real issue here.


This is a long-standing issue, I've traveled to Hildesheim working with
our customer to try and get to the bottom of it. I can go into a lot of
details from those trips, we probed the bt.656 bus with a logic analyzer
and I can share those results with anyone who asks. But the results of
those investigations indicate the CSI is not handling the SAV/EAV sync
codes correctly - if there is a shift in the line position at which
those codes occur, the CSI/IPU does not abort the frame capture DMA
and start from the new sync code position, it just continues to capture
lines until the programmed number of lines are transferred, hence you
get these split images. Freescale also informed us of a mechanism in the
IPU that will add lines if it detects these short frames, until the
programmed number of lines are reached. Apparently that is what creates 
the rolling effect, but this rolling can last for up to a full minute,
which is completely unacceptable, it must be corrected as soon as
possible.

So the only thing we could come up with was to monitor frame intervals,
this is purely empirical, but we observed that frame intervals drop
by approx. one line time (~60 usec) when these short frames are
received. I don't really have any explanation for that but we take
advantage of that observation by sending this event to userspace so
the problem can be corrected immediately with a stream restart.

As I've said, the ADV718x does not provide _any_ indication via status
when the shift in the sync code position occurs. And the IPU is also 
severely lacking in DMA completion status as well (no short packet
status like in USB for example). So the only way to detect this event
is by monitoring the frame intervals.

I will review differences in the CCIR code register setup from FSL's
repo that Russell pointed out, but I'm fairly sure those code registers
are setup correctly, there's not much room for variability in those
values. They only define the values of the sync codes, so the CSI can
detect them, those values are defined by the bt.656 spec.

Anyway, perhaps for now I can remove the event, but keep the FI
monitoring, and for now just report a kernel error message on
a detected bad FI.

Steve
