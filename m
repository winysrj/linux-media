Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64229 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab2GLVIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 17:08:01 -0400
Received: by yhmm54 with SMTP id m54so3226593yhm.19
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2012 14:08:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com>
References: <4FFF327A.9080300@iki.fi>
	<CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com>
Date: Thu, 12 Jul 2012 17:07:59 -0400
Message-ID: <CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com>
Subject: Re: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Resend in plaintext, it got bounced from vger.

On Thu, Jul 12, 2012 at 4:49 PM, Steven Toth <stoth@kernellabs.com> wrote:
>>
>> Is there anyone who could say straight now what is best approach and
>> where to look example?
>>
>
> I don't have an answer but the topic does interest me. :)
>
> Nobody understands the relationship between the bridge and the
> sub-component as well as the bridge driver. The current interfaces are
> limiting in many ways. We solve that today with rather ugly 'attach'
> structures that are inflexible, for example to set gpios to a default state.
> Then, once that interface is attached, the bridge effectively loses most of
> the control to the tuner and/or demod. The result is a large disconnect
> between the bridge and subcomponents.
>
> Why limit any interface extension to GPIOs? Why not make something a
> little more flexible so we can pass custom messages around?
>
> get(int parm, *value) and set(int parm, value)
>
> Bridges and demods can define whatever parmid's they like in their attach
> headers. (Like we do for callbacks currently).
>
> For example, some tuners have temperature sensors, I have no ability to
> read that today from the bridge, other than via I2C - then I'm pulling i2c
> device specific logic into the bridge. :(
>
> It would be nice to be able to demod/tunerptr->get(XC5000_PARAM_TEMP,
> &value), for example.
>
> Get/Set I/F is a bit of a classic, between tuners and video decoders. This
> (at least a while ago) was poorly handled, or not at all. Only the bridge
> really knows how to deal with odd component configurations like this, yet it
> has little or no control.
>
> I'd want to see a list of 4 or 5 good get/set use cases though, with some
> unusual parms, before I'd really believe a generic get/set is more
> appropriate than a strongly typed set of additional function pointers.
>
> What did you ever decide about the enable/disable of the LNA? And, how
> would the bridge do that in your proposed solution? Via the proposed GPIO
> interface?
>
> Regards,
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> +1.646.355.8490
