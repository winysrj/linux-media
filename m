Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:57020 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab2ISWq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 18:46:59 -0400
In-Reply-To: <CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
References: <1348080243-3818-1-git-send-email-oliver+list@schinagl.nl> <CAGoCfizA_wEcJdcXHfN1xA4MTMUJy4vCX4YpN8vpei9=wFZg-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
From: Oliver Schinagl <oliver+list@schinagl.nl>
Date: Thu, 20 Sep 2012 00:47:49 +0200
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Message-ID: <41a0de76-8a71-4c8e-aedd-cdc731c63145@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

>On Wed, Sep 19, 2012 at 2:44 PM,  <oliver@schinagl.nl> wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This is initial support for the Asus MyCinema U3100Mini Plus. The
>driver
>> in its current form gets detected and loads properly.
>>
>> Scanning using dvbscan works without problems, Locking onto a channel
>> using tzap also works fine. Only playback using tzap -r + mplayer was
>> tested and was fully functional.
>
>Hi Oliver,
>
>The previous thread suggested that this driver didn't work with
>dvbv5-scan and w_scan.  Is that still the case?  If so, do we really
>want a "half working" driver upstream?  Seems like this is more likely
>to cause support headaches than the device not being supported at all
>(since users will "think" it's supported but it's actually broken in
>some pretty common use cases).
>
>Or perhaps I'm mistaken and the issues have been addressed and now it
>works with all the common applications.
I've only tested with dvbscan, which worked fine. So initial problems apear to be solved. After working in antti's comments I will also test some more tools, but don't forsee any other issues.
>
>Devin

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
