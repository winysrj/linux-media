Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1IGG1E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Sep 2011 02:27:04 -0400
Message-ID: <4E670F51.8050100@redhat.com>
Date: Wed, 07 Sep 2011 08:29:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com> <CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com> <4E66E532.4050402@redhat.com> <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
In-Reply-To: <CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Lots of good stuff in this thread! It seems Mauro has answered most
things, so I'm just going to respond to this bit.

On 09/07/2011 05:37 AM, Devin Heitmueller wrote:

<Snip>
>> We've added a parameter for that on xawtv3 (--alsa-latency). We've parametrized
>> it at the alsa stream function call. So, all it needs is to add a new parameter
>> at tvtime config file.
>
> Ugh.  We really need some sort of heuristic to do this.  It's
> unreasonable to expect users to know about some magic parameter buried
> in a config file which causes it to start working.  Perhaps a counter
> that increments whenever an underrun is hit, and after a certain
> number it automatically restarts the stream with a higher latency.  Or
> perhaps we're just making some poor choice in terms of the
> buffers/periods for a given rate.

This may have something to do with usb versus pci capture, on my bttv card
30 ms works fine, but I can imagine it being a bit on the low side when
doing video + audio capture over USB. So maybe should default to say
50 for usb capture devices and 30 for pci capture devices?

In the end if people load there system enough / have a slow enough
system our default will always be wrong for them. All we can do is try to
get a default which is sane for most setups ...

Regards,

Hans
