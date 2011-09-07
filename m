Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab1IGEGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 00:06:42 -0400
Received: by bke11 with SMTP id 11so6050983bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 21:06:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiw-QnfVVwOhejwbMmb+K2F0VDwN_L-6E37w+=jKYGGFkg@mail.gmail.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiy2hnH0Xoz_+Q8JgcB-tzuTGbfv8QdK0kv+ttP7t+EZKg@mail.gmail.com>
	<CAGoCfixa0pr048=-P3OUkZ2HMaY471eNO79BON0vjSVa1eRcTw@mail.gmail.com>
	<4E66E532.4050402@redhat.com>
	<CAGoCfiw7vjprc_skYYAXy9sTA7zkYEWtzXy9tEmJD+q8aazPog@mail.gmail.com>
	<CAGoCfiw-QnfVVwOhejwbMmb+K2F0VDwN_L-6E37w+=jKYGGFkg@mail.gmail.com>
Date: Wed, 7 Sep 2011 00:06:40 -0400
Message-ID: <CAGoCfixTqXaDU++-k_tn1NMkg4xXNcL=qvezggqe6BqEH+h5xg@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 11:42 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> One more thing worth noting before I quit for the night:
>
> What audio processor is on your WinTV USB 2 device?  The DVC-90 has an
> emp202.  Perhaps the WInTV uses a different audio processor (while
> still using an em2820 as the bridge)?  That might explain why your
> device advertises effectively only one capture rate (32), while mine
> advertises a whole range (8-48).

Just took a look at the driver code.  Seems we are calling
em28xx_analog_audio_set() even if it's not using vendor audio.  And
that function actually hard-codes the rate to 48KHz.

So here's the question:  if using snd-usb-audio, should we really be
poking at the AC97 registers at all?  It seems that doing such can
just get the audio processor state out of sync with however
snd-usb-audio set it up.  For example, the snd-usb-audio driver may
very well be configuring the audio to 32 KHz, and then we reset the
chip's state to 48Khz when we start streaming without the
snd-usb-audio driver's knowledge.

It seems like we should only be setting up the AC97 registers if it's
an AC97 audio processor *and* it's using vendor audio.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
