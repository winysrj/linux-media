Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:39411 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbeDQNFU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:05:20 -0400
Received: by mail-ua0-f169.google.com with SMTP id g10so12440740ual.6
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 06:05:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180417045300.GA7723@minime.bse>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
 <20180417045300.GA7723@minime.bse>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Tue, 17 Apr 2018 09:05:19 -0400
Message-ID: <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
Subject: Re: cx88 invalid video opcodes when VBI enabled
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

Thanks for the feedback.

On Tue, Apr 17, 2018 at 12:53 AM, Daniel Gl=C3=B6ckner <daniel-gl@gmx.net> =
wrote:

>> [   54.427224] cx88[0]: irq vid [0x10088] vbi_risc1* vbi_risc2* opc_err*
>> [   54.427232] cx88[0]/0: video risc op code error
>> [   54.427238] cx88[0]: video y / packed - dma channel status dump
>
> Since the video IRQ status register has vbi_risc2 set, which we never
> generate with our RISC programs, I assume it is the VBI RISC engine
> that is executing garbage. So the dump of the video y/packed RISC engine
> does not help us here. Can you add a call to cx88_sram_channel_dump for
> SRAM_CH24 next to the existing one in cx8800_vid_irq?

Doh, I actually already did that a few days ago but didn't save the
log (and in fact, it was the VBI RISC queue that had garbage on it).
I'll dig up the log later today (or just add the line back in and
recreate it).

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
