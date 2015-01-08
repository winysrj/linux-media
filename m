Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:60986 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbAHAYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 19:24:00 -0500
Received: by mail-yh0-f53.google.com with SMTP id i57so1163364yha.12
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 16:24:00 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Jan 2015 00:23:59 +0000
Message-ID: <CAL+psHzFP8VeDSa2KRyW0t6S6gH43vNxo8cGENDb5m=EkFno8Q@mail.gmail.com>
Subject: [WISHLIST] Volume in tvtime not equal to alsamixer (logarithmic scale
 / "mapped volume" should be used)
From: George Pojar <geoubuntu@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It adjusts the volume linearly, while the correct behaviour is to
adjust it logarithmically (in dB...). So the volume scale is
incorrect, and the volume level isn't equal to alsamixer's. I use
plain ALSA.

VOLUME MAPPING:
In alsamixer, the volume is mapped to a value that is more natural for
a human ear. The mapping is designed so that the position in the
interval is proportional to the volume as a human ear would perceive
it, i.e. the position is the cubic root of the linear sample
multiplication factor. For controls with a small range (24 dB or
less), the mapping is linear in the dB values so that each step has
the same size visually. Only for controls without dB information, a
linear mapping of the hardware volume register values is used (this is
the same algorithm as used in the old alsamixer).

(I'm talking about
http://git.alsa-project.org/?p=alsa-utils.git;a=blob;f=alsamixer/volume_mapping.c;h=1c0d7c45e6686239464e1b0bbc8983ea57f3914f;hb=HEAD
)
