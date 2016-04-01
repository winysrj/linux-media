Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33787 "EHLO
	mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcDATLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2016 15:11:20 -0400
Received: by mail-yw0-f178.google.com with SMTP id h65so182010288ywe.0
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2016 12:11:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FEA192.9020303@nexvision.fr>
References: <56FE9B7F.7060206@nexvision.fr> <56FEA192.9020303@nexvision.fr>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Fri, 1 Apr 2016 21:11:00 +0200
Message-ID: <CAH-u=83J0kJzaV5Mqz7Zt76JgfVz6M_v_nhzPEeqwcRCRKm8VQ@mail.gmail.com>
Subject: Re: [PATCH] Add GS1662 driver (a SPI video serializer)
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Charles-Antoine,

Thank you for the patch.
FIrst of all, we, on the ML, do prefer reading patches as sent by git
send-email tool.
It is easier to comment the patch.

Next, you should add a complete description to your commit. Just
having an object and a signed-off-by line is not enough.
You also have to use the scripts/checkpatch.pl script to verify that
everything is ok with it.

Last thing, I can't see anything related to V4L2 in your patch. It is
just used to initialize the chip and the spi bus, that's all.
Adding a subdev is a start, and some operations if it can do something
else than just serializing.

That's it for the moment, when you submit a v2, I (and others) may
have some more comments :).

Thanks,
JM

2016-04-01 18:28 GMT+02:00 Charles-Antoine Couret
<charles-antoine.couret@nexvision.fr>:
>
