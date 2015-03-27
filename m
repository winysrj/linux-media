Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34649 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbbC0MQj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 08:16:39 -0400
Received: by qgep97 with SMTP id p97so131257970qge.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 05:16:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5515496A.4050600@iki.fi>
References: <1427457439-1493-1-git-send-email-olli.salonen@iki.fi>
	<1427457439-1493-5-git-send-email-olli.salonen@iki.fi>
	<CALzAhNX+covLWsgpUdW5sOfHtka6B93wK6y8o6A2+qt6PGkWug@mail.gmail.com>
	<5515496A.4050600@iki.fi>
Date: Fri, 27 Mar 2015 08:16:38 -0400
Message-ID: <CALzAhNUndjd7NscMSeDRNDWxt2Kadd8p451025+t4OC7JiUdSA@mail.gmail.com>
Subject: Re: [PATCH 5/5] saa7164: Hauppauge HVR-2205 and HVR-2215 DVB-C/T/T2 tuners
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I did not require any 2168/2157 driver changes to make these devices
>> work. (Antti please note).
>
>
> There seems to be only minor TS config change (which is not even needed if
> you set that bit to existing TS mode config value) for gapped/variable
> length TS clock (which is in my understanding to leave TS valid line
> unconnected).

Its not required for the HVR2205 or the HVR2255, these are the only
two models of the hardware shipping in production volumes to
customers. Any other cards were advanced prototypes, that's my
understanding.

I'm not suggesting the gapped clock 2168 patch isn't useful for other
bridges, you might want to pull Olli's patch for that, but its not
required for the HVR2205/2255 support.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
