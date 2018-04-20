Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:45819 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751338AbeDTVye (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 17:54:34 -0400
Received: from minime.bse ([77.22.125.85]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M3d9B-1eJBpA1pnV-00rGAW for
 <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 23:54:33 +0200
Date: Fri, 20 Apr 2018 23:54:32 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: cx88 invalid video opcodes when VBI enabled
Message-ID: <20180420215432.GA3747@minime.bse>
References: <CAGoCfiw_oD6PLOoot55zkNBVaujeG7ReNQORiqUbLuh-=iwcyw@mail.gmail.com>
 <20180417045300.GA7723@minime.bse>
 <CAGoCfiwwCtp0entUfK74PhJDAubxAQeuAYgf6Jotw_EOT7+hSw@mail.gmail.com>
 <CAGoCfizXy6j5rgzDghT3Lo3ZKvoUjLt7P3k7qo5wnX+xEE7m-g@mail.gmail.com>
 <20180418182959.GA19152@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180418182959.GA19152@minime.bse>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Apr 18, 2018 at 08:29:59PM +0200, Daniel Glöckner wrote:
> The VBI instruction queue read pointer points outside the VBI instruction
> queue and into the video y/packed CMDS (to 0x180000+0x11*4). The values
> next to the iq rd ptr look ok.
> 
> We only initialize the iq rd ptr to zero in cx88_sram_channel_setup and
> then never touch it again. The hardware takes care of updating it.
> Maybe cx88_sram_channel_setup is sometimes called for channel 24 while the
> VBI risc engine is still running?

for some reason I feel like buffer_queue in cx88-vbi.c should not be
calling cx8800_start_vbi_dma as it is also called a few lines further
down in start_streaming.

Devin, can you check if it helps to remove that line and if VBI still
works afterwards?

Best regards,

  Daniel
