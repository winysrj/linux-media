Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50432 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2GRQ65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jul 2012 12:58:57 -0400
Message-ID: <5006EB4D.1020104@gmail.com>
Date: Wed, 18 Jul 2012 18:58:53 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Subject: Re: [RFC/PATCH 04/13] devicetree: Add common video devices bindings
 documentation
References: <4FBFE1EC.9060209@samsung.com> <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com> <1337975573-27117-4-git-send-email-s.nawrocki@samsung.com> <Pine.LNX.4.64.1207161057050.12302@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207161057050.12302@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 07/16/2012 11:09 AM, Guennadi Liakhovetski wrote:
> On Fri, 25 May 2012, Sylwester Nawrocki wrote:
> 
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/video/video.txt |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/video/video.txt
>>
>> diff --git a/Documentation/devicetree/bindings/video/video.txt b/Documentation/devicetree/bindings/video/video.txt
>> new file mode 100644
>> index 0000000..9f6a637
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/video/video.txt
>> @@ -0,0 +1,10 @@
>> +Common properties of video data source devices (image sensor, video encoders, etc.)
>> +
>> +Video bus types
>> +---------------
>> +
>> +- video-bus-type : must be one of:
>> +
>> +    - itu-601   : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
>> +    - itu-656   : parallel bus with embedded synchronization - ITU-R BT.656;
> 
> wikipedia tells me, that bt.601 is mostly a data encoding standard, it
> also defines bus-types, but recent versions also include serial busses.

Hmm, indeed, I got slightly misled by the Samsung SoCs' User Manuals 
that used bt.601/bt.656 to distinguish between bus with sync signals
and with embedded sync.

>> +    - mipi-csi2 : MIPI-CSI2 serial bus;
> 
> In general: are these at all needed? Wouldn't it be better to specify pads
> on sensors and interfaces to differentiate between serial and parallel
> connections. As for whether HSYNC and VSYNC are used - I see 3

We have video buses and data receivers and transmitters attached to them.
The pads concept doesn't quite fit here for me. Specifying possible links 
with character string tags might be a way to go, but I'd like to hear
others' opinion on that. Do we have any bindings already that do something
similar ?

> possibilities there:
> 
> 1. real sync signals are used - the default.
> 
> 2. embedded syncs shall be used, because sync signals are missing. This
> should (arguably) be derived from pinctrl - see this discussion:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/index.html#03893

Hmm, I'm not terribly familiar with pinctrl API, but wouldn't it be 
required to have two pin group names: (data + clock + sync) signals and
(data + clock) (for embedded video synchronization) ? We would have to name
these two configurations somehow anyway, wouldn't we ?

Also, as Stephen pointed out, the control flow is supposed to be from
drivers to pin controller, not the other way around.

> 3. sync signals are present, but cannot be used, because one of the
> partners doesn't support them - .g_mbus_config() can be used to retrieve
> this information.

OK.

> 4. sync signals are available and supported by both peers, but for some
> reason the user prefers to use embedded sync data - is such a case
> feasible? Even if so, this should be run-time configurable then?

I've never seen such a situation. I would expect that if sync signal wires 
are routed, they shall be used. Otherwise only embedded synchronization
would be used, to save PCB area.
 
> So, maybe we don't need these at all.

We need something that would let drivers distinguish which (serial/
parallel) bus is supported on a board. And what type of synchronization
is used. I'm fine as long as this can be specified reliably in DT and
drivers of the transmitters/receivers can configure their output/input
interfaces. I'm not against dynamic configuration but static one also
need to be supported.

--
Regards,
Sylwester
