Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2007 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZBWQVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 11:21:07 -0500
Message-ID: <13434.62.70.2.252.1235406040.squirrel@webmail.xs4all.nl>
Date: Mon, 23 Feb 2009 17:20:40 +0100 (CET)
Subject: Re: Question regarding detail in dropping support for kernels <
     2.6.22 (related to Re: POLL: for/against dropping support for
     kernels < 2.6.22)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: tobi@to-st.de
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello Hans,
>
> Hans Verkuil schrieb:
>> We still need to support kernels from 2.6.22 onwards. Although I think
>> the
>> minimum supported kernel is something that needs a regular sanity check,
>> right now there are no technical reasons that I am aware of to go to
>> something newer than 2.6.22.
>>
>> Whether we keep our current system or not is a separate discussion:
>> whatever development system you choose there will be work involved in
>> keeping up the backwards compatibility.
>
> Just out of deep interesst:
>
> Could you, Hans (or anyone else) just explain, what is / are the reason
> to draw the line between kernels 2.6.21 and 2.6.22?
>
> What was the fundamental change there and do these changes as such apply
> to every supported device / driver?
>
> As I understand you, although you drop backport efforts for kernels
> below 2.6.22, you are going to adopt an policy to - in a sense - waste
> development efforts / time on seven instead of 12 kernels?
>
> Wouldn't it then not be more logical to support only the recent kernel
> and the kernel before, becaus in some month time 2.6.30 might include a
> major change which would force you to drop support for < 2.6.29
> altogether?
>
> Thanks for your patience and reply,

Hi Tobias,

No problem, I'd be happy to explain.

For a long time whenever you loaded an i2c module the kernel i2c core
would probe all i2c adapters to see if a chip supported by the i2c module
was present. This is very, very bad since the act of probing can corrupt
eeproms and worse. In addition, since many i2c devices cannot be properly
identified, you often get misdetections where the driver thinks it found a
match, when in reality it was a different device altogether.

In kernel 2.6.22 a new i2c API was created that allowed the adapter driver
such as bttv or ivtv to tell the i2c core what i2c devices are on which
address. So a driver that supported the new i2c API would prevent i2c
modules from autoprobing its i2c adapters, and it has to explicitly tell
the i2c code what device is where. It's a bit simplified since there are
still some probing methods available, but in all cases it is the adapter
driver that initiates them. This is a huge improvement and solves many
problems that were previously unsolvable. But it is a totally different
approach where the i2c module no longer initiates probes, but instead it
is done by the adapter driver.

However, it is a big task to convert drivers from the old to the new API.
It requires modifying the i2c modules to support the new API, but as long
as such modules are also still in use by unconverted adapter drivers they
have to support the old API as well. And before you can convert an adapter
driver *all* i2c modules it uses need to be converted to support the new
API.

In addition, since kernels older than 2.6.22 do not support the new API at
all, we need to keep support for the old API around under #if
KERNEL_VERSION as well.

To make all this possible without creating i2c modules riddled with #if's
I created two headers that hide most of this complexity. However, these
headers are exposed in the upstream kernel where they look really weird
when they are stripped from all #ifs.

Now all this is fine as long as adapter drivers exist that are not yet
converted, since that means we need to keep the compat stuff around
anyway. But I'm now attempting to finally convert the last drivers,
hopefully before the 2.6.30 merge window will close. Once that is done,
the only reason left to keep the compat code around is to support
pre-2.6.22 kernels.

It's a lot of tricky code meant primarily to support the transition from
the old to new i2c API. Now that we have almost finished this transition I
think it is time to say goodbye to all the code needed to keep the old i2c
API alive. And that means effectively dropping support for kernels older
than 2.6.22.

Of course, I might not be able to finish the conversion in time for
2.6.30, in which case the compat code needs to stay around for another
kernel cycle.

Luckily, such major API redesigns are rare. And normally the effort needed
to keep compatibility is fairly limited and the additional test exposure
is very welcome. So there are good reasons for having backwards
compatibility. I didn't create the daily build system to verify that it
still compiles on older kernels for nothing. But there are limits to the
amount of effort that I am willing to spend on it. And in this case I
think it's time to drop the compatibility with the old i2c API entirely.

A long and technical story, but I hope it helps explain the background.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

