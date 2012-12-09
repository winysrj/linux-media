Return-path: <linux-media-owner@vger.kernel.org>
Received: from firefly.pyther.net ([50.116.37.168]:34613 "EHLO
	firefly.pyther.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab2LIRxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2012 12:53:23 -0500
Message-ID: <50C4D011.6010700@pyther.net>
Date: Sun, 09 Dec 2012 12:53:21 -0500
From: Matthew Gyurgyik <matthew@pyther.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com> <50C4BAFB.60304@googlemail.com> <50C4C525.6020006@googlemail.com>
In-Reply-To: <50C4C525.6020006@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2012 12:06 PM, Frank Schäfer wrote:
> Forget this sh... (never do multiple things at the same time ;) )
>
> Reg 0x50 is set to according to rc_type specified in the selected remote
> control map.
> So if the correct map is selected, everything should be fine (as long as
> it is RC_TYPE_NEC or RC_TYPE_RC5 because we don't support others yet).
>
> RC_MAP_KWORLD_315U and RC_MAP_MSI_DIGIVOX_III are both RC_TYPE_NEC, so
> the stick seems to use no NEC protocol.
>
> Matthew, insert a line
>
>          ir_config = 0x01;
>
> before
>
> 380        em28xx_write_regs(dev, EM2874_R50_IR_CONFIG, &ir_config, 1);
>
> in em28xx-input.c and see if something shows up in the dmesg output.
>
> Regards,
> Frank

That seems to be a bit more successful!

Here is the dmesg output:

> [root@tux ~]# dmesg -t | sort | uniq | grep 'em28xx IR' | grep handle
> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 1, key 0x61d6
> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 0, count: 2, key 0x61d6
> em28xx IR (em28xx #0)/ir: 6em28xx_ir_handle_key: toggle: 1, count: 1, key 0x61d6
> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 1, key 0x61d6
> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 0, count: 2, key 0x61d6
> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 1, key 0x61d6
> em28xx IR (em28xx #0)/ir: em28xx_ir_handle_key: toggle: 1, count: 2, key 0x61d6

I pressed all the buttons on the remote (40 buttons).

Thanks,
Matthew
