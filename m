Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35537 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035572AbdEZOcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 10:32:22 -0400
Received: by mail-io0-f169.google.com with SMTP id f102so10432265ioi.2
        for <linux-media@vger.kernel.org>; Fri, 26 May 2017 07:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e20f0625-98c9-7778-4723-ebff59195593@iki.fi>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
 <1489616530-4025-2-git-send-email-andreas@kemnade.info> <43216679-3794-14ca-b489-00ac97a57777@iki.fi>
 <20170515222837.3d822338@aktux> <e20f0625-98c9-7778-4723-ebff59195593@iki.fi>
From: Steven Toth <stoth@kernellabs.com>
Date: Fri, 26 May 2017 10:32:20 -0400
Message-ID: <CALzAhNUjXY=S=TotADqWFTnP-VscdHdUir1VctmTe_n+TSHRtQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] [media] si2157: get chip id during probing
To: Antti Palosaari <crope@iki.fi>
Cc: Andreas Kemnade <andreas@kemnade.info>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> ep: 81 l:    9 08260080ffffff5901
>>
>> here you see all the ffff from the device.

You need to be able to see the traffic on the physical I2C bus in
order to help diagnose issues like this. You're going to want to see
ACKS/NAKS, clocks and other I2C bus activity.

You'll need to solder down scl/sda/gnd wiring to the PCB, I generally
attached to the eeprom which tends to have larger pins (details on
their respective datasheets).

It's not hard to do, but does require a small investment in hardware.

One the actual bus behavior is documented and understood, you'll
likely get a better technical discussion going on.

Send me a detailed picture of the PCB and I can probably help spot the
I2C bus for you, if you have a low cost bus analyzer and a soldering
iron.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
