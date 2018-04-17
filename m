Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58577 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbeDQExD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 00:53:03 -0400
Received: from minime.bse ([77.22.125.85]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LqzIJ-1eV67B09pL-00ecC4 for
 <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 06:53:02 +0200
Date: Tue, 17 Apr 2018 06:53:01 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx88 invalid video opcodes when VBI enabled
Message-ID: <20180417045300.GA7723@minime.bse>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Sun, Apr 15, 2018 at 01:37:50PM -0400, Devin Heitmueller wrote:
> Any suggestions on the best way to debug this without having to learn
> the intimate details of the RISC engine on the cx88?  From the state
> of the RISC engine it looks like there is some issue with queuing the
> opcodes/arguments (where in some cases arguments are interpreted as
> opcodes), but this is certainly not my area of expertise.

> [   54.427224] cx88[0]: irq vid [0x10088] vbi_risc1* vbi_risc2* opc_err*
> [   54.427232] cx88[0]/0: video risc op code error
> [   54.427238] cx88[0]: video y / packed - dma channel status dump

Since the video IRQ status register has vbi_risc2 set, which we never
generate with our RISC programs, I assume it is the VBI RISC engine
that is executing garbage. So the dump of the video y/packed RISC engine
does not help us here. Can you add a call to cx88_sram_channel_dump for
SRAM_CH24 next to the existing one in cx8800_vid_irq?

Best regards,

  Daniel
