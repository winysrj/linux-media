Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40440 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1HRSon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 14:44:43 -0400
Received: by bke11 with SMTP id 11so1672769bke.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 11:44:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com>
References: <4E4D5157.2080406@yahoo.com>
	<CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com>
Date: Thu, 18 Aug 2011 14:44:42 -0400
Message-ID: <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV 290e
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 18, 2011 at 2:43 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Aug 18, 2011 at 1:52 PM, Chris Rankin <rankincj@yahoo.com> wrote:
>> Hi,
>>
>> Here's my latest patch for the em28xx / em28xx-dvb modules, which addresses
>> the following problems:
>>
>> a) Locking problem when unplugging and then replugging USB adapter.
>> b) Race conditions between adding/removing devices from the devlist, while
>> simultaneously loading/unloading extension modules.
>> c) Resource leaks on error paths.
>> d) Preventing the DVB framework from trying to put the adapter into sleep
>> mode when the adapter has been physically unplugged. (This results in
>> occasional "-19" errors from I2C functions when disconnecting.)
>> e) Use atomic bit operations to manage "device in use" slots, and enforce
>> upper limit of EM28XX_MAXBOARDS slots.
>
> Hi Chris,
>
> You would be well served to break this into a patch series, as it
> tends to be difficult to review a whole series of changes in a single
> patch.
>
> You seem to be mixed in a bunch of "useless" changes alongside
> functional changes.  For example, if you're trying to add in a missing
> goto inside an exception block, doing that at the same time as
> renaming instances of "errCode" to "retval" just creates confusion.
>
> And finally, the mutex structure used for the modules is somewhat
> complicated due to to the need to keep the analog side of the board
> locked while initializing the digital side.  This code was added
> specifically to prevent race conditions that were seen during
> initialization as things like udev and dbus attempted to connect to
> the newly created V4L device while the em28xx-dvb module was still
> coming up.
>
> In other words, I don't doubt there are bugs, and I cannot say whether
> your fixes are appropriate without giving a hard look at the logic.
> But you should be aware of the thinking behind the way it was done and
> it would be very worthwhile if you could test with at least one hybrid
> product to ensure the changes you are making don't break anything (the
> em2874 used in the 290e is a poor test case since it doesn't have
> analog support).
>
>> BTW, was there a reason why the em28xx-dvb module doesn't use dvb-usb?
>
> This is largely a product of the history of the devices using the
> framework.  The em28xx driver was originally analog only, and DVB
> support was added later as new chips came out which needed it.  The
> dvb-usb driver came from dedicated DVB devices that had no analog
> support.  In fact, even today the lack of analog support is a huge
> deficiency in that framework which is why we don't support the analog
> side of any hybrid devices that use dvb-usb.
>
> In other words, if we were reinventing this stuff today, there would
> probably be only a single framework shared by dvb-usb and em28xx.  But
> at this point it's too much cost and too little benefit to go through
> the work to attempt to merge them.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Probably one more point worth making:  I definitely appreciate that
you've take the time to focus on these particular problems.  I've been
complaining about them for months but just never got around to rolling
up my sleeves to debug them myself.

In other words, don't interpret anything in my previous email as discouragement.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
