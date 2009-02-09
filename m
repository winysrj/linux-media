Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:53615 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbZBIO33 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 09:29:29 -0500
Date: Mon, 9 Feb 2009 15:28:47 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib0700 "buggy sfn workaround" or equivalent
In-Reply-To: <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com>
Message-ID: <alpine.LRH.1.10.0902091442500.21232@pub2.ifh.de>
References: <e021c7c00902090411j4df14a69me568a6022a5bc4d2@mail.gmail.com> <e021c7c00902090413l12af9229t8a4db36f7c4ce160@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, 9 Feb 2009, Brett wrote:
> I have a dvb_usb_dib0700 (Nova 500 dual) card and it shows similar
> issues to the dvb_usb_dib3000mc card, ie:
>
> "This card has an issue (which particularly manifests itself in
> Australia where a bandwidth of 7MHz is used) with jittery reception -
> artifacts and choppy sound throughout recordings despite having full
> signal strength. Australian users will typically see this behaviour on
> SBS and ABC channels"


It has nothing to with the channel bandwidth. In Australia, and maybe in 
other places too, the DVB-T radio-channels (not to mix up with a radio 
service) which are used in single-frequency-networks (SFNs) are 
transmitted buggy: different transmitters are not using the same tps-data 
(cellid IIRC). The dibcom-demods are using this information to improve the 
reception robustness. This leads to synchronization losses, when the SFN 
is not set up correctly...

> The fix for the dib3000mc is to enable the 'buggy sfn workaround' but
> there is no such option for the dib 0700 :
>
> The buggy sfn workaround workaround does "dib7000p_write_word(state,
> 166, 0x4000);" if it is active, or "dib7000p_write_word(state, 166,
> 0x0000)" if it inactive, in the dib3000mc driver. I presume this
> tweaks a bandwidth filter or something similar for the dib3000mc, is
> there  such an equivalent feature for the dib0700 chipset ?

Your report here is mixing up several things: dib3000mc and dib7000p have 
this work-around implemented. To activate it you need to load the dib3000p 
resp. the dib7000p-module with buggy_sfn_workaround=1.

The dib0700-driver is only the USB driver here - nothing is missing there 
to avoid the SFN problem.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
