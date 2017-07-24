Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:34106 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932741AbdGXRCX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 13:02:23 -0400
Received: by mail-wr0-f174.google.com with SMTP id 12so108964230wrb.1
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 10:02:21 -0700 (PDT)
Received: from eeeinsomma.lan (host161-229-dynamic.58-82-r.retail.telecomitalia.it. [82.58.229.161])
        by smtp.gmail.com with ESMTPSA id q185sm12821294wmd.19.2017.07.24.10.02.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Jul 2017 10:02:17 -0700 (PDT)
Date: Mon, 24 Jul 2017 19:02:02 +0200 (CEST)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: linux-media@vger.kernel.org
Subject: dmesg flood + tuning problems on Asus My Cinema-U3000Hybrid
Message-ID: <alpine.LNX.2.21.1707241857540.1811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys.

First of all, thank you for your great work.

I am writing to you about the behaviour of an Asus My Cinema-U3000Hybrid device, while running the 4.11.9 kernel.

Bus 001 Device 015: ID 0b05:1736 ASUSTek Computer, Inc.

The device actually works fine, except for some annoyances that looks like 
driver-dependent.

First of all, everytime I tune to a channel, my dmesg is flooded with 
something like this:

[11908.576919] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[11910.139426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.143659] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.148020] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.152167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.157162] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.266415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.271418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.276422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.281408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.286409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.291277] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.296417] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.301414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.306408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[11910.311276] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
And so on, for something like 1940 more lines.
While I would like to keep the xc2028-related messages, the dib0700 
"stk7700ph_xc3028_callback"-related ones are too many in my opinion.

Another thing I noticed is the following: once I tune to UHF channels, 
tuning to VHF ones is not possible anymore.

As an example: if I plug the device and then watch the following channel.
Rai 1:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_NONE:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:512:650+694+699:3401

then all goes well.
If I then tune to something like:
Italia1:698000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_NONE:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:1620:1621+1622:4006

I will not be able to tune back to
Rai 1:177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_NONE:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:512:650+694+699:3401

Unless I unplug and plug the device again, or reload the dvb_usb_dib0700 
module driver (modprobe -r / modprobe the driver).

Setup details

I am using these modprobe lines:
options dvb_usb disable_rc_polling=1
options dvb_usb_v2 disable_rc_polling=1
options tuner_xc2028 firmware_name=xc3028L-v36.fw

I added the first two of them due to my desidre to disable IR plling for 
dvb usb and dvb usb v2 based devices; I don't use IR for now.
And this was a possible workaround for the flooding problem I found 
reading around (if I am not wrong).

I then overridden the firmware version used by the xc2028 tuner driver, 
since the standard 2.7 firmware version didn't perform well on the device 
(e.g.: high rate of bad frames).
This behaviour doesn't seem application dependent, nor kernel version 
dependent. I am using mplayer.

So, except for those annoyances, the device works really well.
You can find appended some logs: I don't think they're useful, still 
posting them here.
Enrico

-------TUNING SUCCESSFULLY TO RAI 1-------

[14375.073318] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[14376.632329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.636565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.641061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.645192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.650190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.759440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.764444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.769454] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.774439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.779315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.784178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.789095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.794066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.798942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.803801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.808710] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.813692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.818577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.823555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.828570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.833690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.838818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.843963] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.849192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.854313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.859447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.864578] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.869819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.875200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.880306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.885214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.890313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.895451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.900551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.905571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.910688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.915810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.920957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.926190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.931329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.936446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.941613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.946813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.951950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.957050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.961953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.967062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.972200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.977299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.982198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.987314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.992440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14376.997334] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.002448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.007564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.012677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.017566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.022686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.027812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.032929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.037811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.043686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.048815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.053959] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.059070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.064186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.069320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.074209] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.079317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.084438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.089550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.094439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.099568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.104699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.109804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.115211] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.120311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.125446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.130579] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.135699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.140815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.145943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.150831] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.155936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.161064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.166179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.171061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.176195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.181323] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.186429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.191601] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.196811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.201946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.207082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.212198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.217312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.222441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.230922] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.236064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.241190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.246312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.251465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.256560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.261823] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.266942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.272083] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.277181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.282318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.287426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.292336] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.297435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.302562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.307675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.312825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.317961] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.323064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.327983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.333062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.338200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.343300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.348268] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.353439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.358572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.363676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.368581] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.373686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.378820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.383704] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.388821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.393939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.399058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.403940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.409073] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.414190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.419306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.424438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.429566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.434694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.439825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.445325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.450435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.455563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.460440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.465574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.470689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.475807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.480682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.485822] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.490939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.496075] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.501187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.506311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.511442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.516581] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.521947] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.527062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.532185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.537069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.542197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.547311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.552432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.557566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.562687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.567811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.572951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.578072] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.583182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.588569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.593569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.598698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.603812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.608934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.613810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.618948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.633071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.638194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.643311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.648579] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.653687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.658823] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.663941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.668841] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.674063] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.679190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.684302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.689202] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.694311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.699448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.704552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.709685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.714827] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.719937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.725326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.730438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.735573] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.740693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.745584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.750684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.755819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.760928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.765834] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.770935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.776062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.781178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.786198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.791336] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.796435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.801721] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.806939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.812075] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.817191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.822450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.827563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.832691] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.837804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.842825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.847967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.853061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.858178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.863063] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.868200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.873312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.878311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.883443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.888572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.893677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.898568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.903688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.908820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.913925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.918833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.923936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.929077] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.934174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.939079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.944189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.949307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.954460] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.959689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.964823] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.969953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.974976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.980185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.985319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.990428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14377.995324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.000434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.005568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.010677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.015583] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.020687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.025814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.041125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.046313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.054645] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.059579] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.064694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.069815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.074948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.080186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.085319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.090428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.095333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.100432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.105561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.110676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.115702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.120809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.125936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.131063] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.136310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.141451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.146567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.151630] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.156812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.161946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.167049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.171961] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.177062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.182198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.187308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.192214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.197311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.202449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.207568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.212815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.217962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.223061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.227995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.233186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.238574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.243673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.248587] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.253688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.258820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.263926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.268828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.273935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.279074] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.284193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.289307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.294434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.299556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.304455] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.309685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.314825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.319928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.324833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.329933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.335199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.340303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.345203] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.350312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.355442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.360546] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.365460] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.370560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.375694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.380846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.386061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.391190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.396317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.401462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.406556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.411941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.417054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.421953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.427061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.432198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.446438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.451949] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.458143] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.463199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.468572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.473686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.478806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.483686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.488817] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.493938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.499053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.503938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.509072] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.514188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.519111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.524309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.529441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.534556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.539566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.544698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.549809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.555180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.560061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.565320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.570434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.575589] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.580690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.585820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.590939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.595842] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.601059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.606186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.611348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.616188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.621321] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.626435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.631683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.636563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.641946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.647059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.652205] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.657314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.662449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.667566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.672448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.677561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.682686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.687800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.692829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.697964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.703057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.708182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.713066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.718197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.723310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.728587] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.733689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.738821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.743941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.748838] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.754064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.759187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.764304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.769206] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.774312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.779439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.784547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.789569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.794696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.799814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.805324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.810441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.815571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.820688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.825576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.830685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.835814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.840925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.849950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.855444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.860559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.865681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.870565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.875696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.880808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.885925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.890812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.896061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.901193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.906102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.911187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.916307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.921426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.926310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.931448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.936560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.941930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.947057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.952196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.957312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.962448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.967567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.972684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.977813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.982840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.988073] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.993186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14378.998555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.003442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.008567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.013685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.018800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.023687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.028819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.033936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.038858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.044133] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.049313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.054440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.059574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.064695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.069810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.075185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.080071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.085196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.090307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.095303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.100185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.105320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.110433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.115439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.120561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.125698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.130815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.135714] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.140939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.146061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.151172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.156192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.161317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.166435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.171555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.176439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.181572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.186681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.191957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.197190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.202324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.207439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.212821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.217962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.223061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.228183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.233070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.238190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.251821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.256933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.262068] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.268597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.273811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.278934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.284064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.289199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.294310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.299447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.304552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.309570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.314698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.319811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.325317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.330443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.335568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.340688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.345577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.350686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.355818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.360926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.365824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.370935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.376060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.381174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.386198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.391324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.396435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.401578] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.406687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.411947] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.417065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.422199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.427312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.432446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.437548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.442446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.447558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.452685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.457797] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.462948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.468073] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.473187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.478379] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.483559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.488699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.493801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.498939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.504059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.509185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.514298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.519209] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.524310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.529447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.534557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.539812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.545183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.550311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.555446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.560559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.565699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.570799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.575702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.580811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.585935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.591047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.596207] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.601319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.606439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.611622] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.616808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.621940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.627047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.631956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.637059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.642197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.647297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.657685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.662813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.667962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.673060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.678199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.683310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.688554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.693449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.698569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.703688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.708804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.713687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.718820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.723935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.729051] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.734060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.739184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.744311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.749477] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.754701] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.759807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.765186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.770196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.775323] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.780431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.785553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.790435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.795569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.800685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.805800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.810684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.815822] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.820940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.825839] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.831060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.836187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.841335] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.846200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.851322] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.856430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.861680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.866560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.871948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.877060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.882049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.886933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.892197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.897317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.902247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.907436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.912559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.917672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.922819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.927935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.933059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.938179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.943060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.948199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.953312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.958592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.963810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.969066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.974189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.979570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.984697] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.989811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14379.995303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.000184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.005316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.010434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.015563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.020687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.025816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.030940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.035839] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.041061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.046192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.061447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.066560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.071938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.077078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.082198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.087310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.092430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.097314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.102446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.107557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.112678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.117685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.122818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.127960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.133196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.138574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.143683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.148807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.153945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.159067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.164184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.169306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.174182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.179310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.184433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.189549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.194432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.199560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.204691] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.209833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.215320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.220434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.225566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.230570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.235694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.240811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.245927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.250809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.255932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.261059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.266174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.271056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.276312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.281443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.286577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.291937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.297059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.302180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.307317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.312445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.317561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.322676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.327556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.332681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.337808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.342925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.347969] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.353062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.358210] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.363327] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.368696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.373805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.378940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.383949] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.389068] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.394180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.399301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.404182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.409309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.414434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.419546] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.424439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.429684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.434817] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.439957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.445322] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.450429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.455555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.466448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.471693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.476806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.481927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.486807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.491944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.497059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.502176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.507130] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.512445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.517561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.522461] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.527560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.532682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.537797] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.542829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.547962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.553055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.558178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.563061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.568190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.573307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.578584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.583683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.588817] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.593939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.598834] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.604061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.609186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.614429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.619573] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.624695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.629811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.635300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.640184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.645318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.650440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.655335] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.660435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.665570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.670675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.675576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.680685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.685811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.690923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.695828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.700933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.706058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.711169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.716196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.721317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.726435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.731615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.736811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.741941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.747049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.751945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.757057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.762193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.767297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.772200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.777309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.782445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.787545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.792460] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.797558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.802682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.807832] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.813064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.818195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.823312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.828580] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.833684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.838813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.843924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.848831] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.853934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.868574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.873682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.878814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.883964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.889181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.894309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.899437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.904570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.909806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.915196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.920297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.925201] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.930311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.935442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.940543] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.945455] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.950558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.955690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.960832] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.966061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.971187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.976315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.981458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.986556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.991945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14380.997045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.001956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.007060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.012190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.017298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.022329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.027433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.032558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.037705] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.042936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.048069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.053193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.058299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.067973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.075843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.080714] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.085587] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.090456] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.095593] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.100584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.107996] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.113105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.118565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.123556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.131585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.136564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.141444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.146422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.151325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.156307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.161183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.166174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.171065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.176060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.180931] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.185930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.190811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.195818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.200930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.206077] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.211185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.216306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.221437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.226337] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.231446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.236558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.241803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.246684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.251941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.257059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.262176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.267059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.272195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.277314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.282217] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.287431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.292558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.297677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.302815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.307965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.313057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.318177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.323062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.328193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.333308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.338570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.343685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.348816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.353938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.358832] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.363933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.369069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.374173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.379083] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.384181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.389307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.394420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.399449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.404557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.409685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.414569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.419812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.425196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.430293] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.435195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.440307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.445445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.450547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.455575] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.460682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.465816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.470944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.476185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.481319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.486436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.491613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.496804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.502065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.507173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.512078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.517182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.522314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.527418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.532333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.537433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.542552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.547699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.552934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.558065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.563186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.568264] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.573432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.578568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.583673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.588571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.599307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.607689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.612812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.617929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.639558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.643932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.651821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.658191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.666050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.670932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.680807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.685047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.689209] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.693557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.697934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.702316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.706449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.710809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.715191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.719556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.723924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.723938] xc2028 1-0061: Loading firmware for type=D2620 DTV7 (88), id 0000000000000000.
[14381.728827] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.733935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.738438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.746683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.755061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.763685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.768069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.772450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.780671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.784945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.791316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.795695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.803943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.808318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.812818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.819942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.824430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.828826] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.833177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.838549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14381.838557] xc2028 1-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.

-------TUNING SUCCESSFULLY TO Italia1-------

[14485.666682] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[14487.225942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.230180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.234414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.238574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.243551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.352805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.357686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.362829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.367804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.372675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.377545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.382442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.387431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.392439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.397420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.402324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.407307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.412188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.417164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.422193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.427300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.432423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.437570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.442685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.447804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.452919] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.457808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.462929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.468066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.473168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.478249] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.483427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.488561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.493664] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.498690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.503803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.508940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.513829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.519067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.524182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.529299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.534184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.539430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.544548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.549668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.554553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.559680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.564814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.569918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.574815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.579927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.585309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.590194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.595315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.600426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.605549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.610434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.615562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.620675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.625798] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.630681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.635807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.640927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.646072] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.651181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.656303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.661431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.666320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.671439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.676555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.681922] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.686805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.691942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.697053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.702043] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.706935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.712065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.717182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.722081] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.727175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.732435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.737545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.742448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.747553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.752681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.757793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.762929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.768065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.773177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.778572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.783675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.788816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.793938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.798828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.803928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.809060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.814169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.823067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.828186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.833301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.838547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.843428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.848563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.853681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.858799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.863680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.868810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.873935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.878726] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.883926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.889064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.894169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.899075] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.904177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.909300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.914419] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.919556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.924693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.929806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.935331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.940554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.945680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.950790] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.955701] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.960802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.965927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.971040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.976196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.981312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.986428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.991576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14487.996676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.001938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.007062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.012197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.017303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.022441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.027543] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.032447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.037553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.042675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.047791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.052821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.057962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.063057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.067979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.073049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.078189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.083288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.088192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.093305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.098559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.103668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.108578] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.113678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.123086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.128568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.133422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.138561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.143676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.148817] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.153928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.159062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.164185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.169078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.174179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.179301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.184413] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.189441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.194551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.199675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.204806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.209931] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.215185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.229678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.234829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.240055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.245322] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.250426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.255554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.260685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.265576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.270679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.275806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.280918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.285821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.290924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.296052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.301166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.306200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.311316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.316438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.321602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.326801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.331939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.337048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.341956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.347053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.352185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.357291] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.362196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.367306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.372435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.377541] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.382452] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.387552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.392678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.397829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.403046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.408191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.413312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.418573] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.423804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.428935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.434041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.438958] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.444054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.449177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.454289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.459442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.464553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.469683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.474568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.479804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.485186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.490295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.495182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.500300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.505437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.510540] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.515448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.520553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.525687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.530794] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.535702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.540806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.545926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.551076] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.556311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.561441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.566557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.571698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.576926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.582063] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.587168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.592071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.597177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.602313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.607415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.612322] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.617427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.622552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.638312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.643431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.651294] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.656202] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.661313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.666422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.671713] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.676927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.682064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.687189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.692069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.697180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.702311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.707417] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.712319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.717430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.722554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.727665] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.732812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.737960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.743049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.748202] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.753306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.758563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.763683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.768824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.773929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.779059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.784165] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.789071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.794182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.799302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.804416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.809445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.814551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.819680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.824562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.829800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.835186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.840289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.845182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.850300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.855437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.860543] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.865444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.870678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.875802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.880911] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.885828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.890927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.896056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.900962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.906178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.911313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.916415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.921319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.926430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.931686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.936793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.941700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.946804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.951934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.957041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.962074] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.967175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.972331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.977468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.982675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.987806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.992934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14488.998078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.003180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.008563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.013666] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.018576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.023683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.028811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.043179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.048562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.053672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.061692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.066802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.071934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.077039] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.081934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.087049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.092182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.097338] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.102556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.107673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.112932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.118079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.123177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.128559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.133665] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.138574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.143680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.148810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.153915] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.158821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.163925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.169064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.174209] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.179305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.184422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.189559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.194434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.199673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.204812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.209916] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.214815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.219928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.225191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.230295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.235200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.240302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.245434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.250536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.255445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.260678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.265941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.271059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.276299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.281442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.286561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.291823] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.296926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.302061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.307167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.312070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.317173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.322307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.327413] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.332322] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.337428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.342549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.347717] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.352928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.358065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.363182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.368316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.373430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.378562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.383667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.388566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.393677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.398812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.403914] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.408820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.413926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.419059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.424182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.429303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.434428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.439552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.448430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.453424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.458558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.463679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.468844] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.474050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.479177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.484311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.489566] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.494674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.499799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.505169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.510055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.515190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.520302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.525414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.530302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.535434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.540555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.545458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.550551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.555686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.560809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.565707] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.570930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.576049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.581167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.586185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.591312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.596420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.601671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.606678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.611936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.617057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.622110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.627302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.632436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.637558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.642450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.647552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.652675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.657792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.662816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.667964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.673052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.678166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.683049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.688192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.693303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.698571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.703803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.708933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.714058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.719439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.724554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.729675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.734794] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.739679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.744810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.749924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.755305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.760429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.765558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.770684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.775456] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.780552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.785677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.790789] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.795696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.800804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.805924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.811040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.816185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.821314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.826427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.831691] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.836803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.851574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.856679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.861933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.870439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.875562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.880677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.885794] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.890679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.895810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.900927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.906042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.910932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.916049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.921178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.926291] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.931177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.936299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.941428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.946311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.951440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.956555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.961915] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.966803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.971938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.977051] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.982169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.987049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.992184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14489.997303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.002429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.007553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.012676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.017804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.022829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.028070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.033172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.038548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.043432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.048559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.053677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.058793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.063677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.068810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.073941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.079078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.084180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.089303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.094431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.099447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.104552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.109674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.114795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.119678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.124814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.129925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.135294] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.140175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.145309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.150430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.155312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.160423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.165559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.170683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.175570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.180675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.185809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.190928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.195821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.200925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.206047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.211163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.216179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.221313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.226428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.231600] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.236798] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.241935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.247059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.255428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.260552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.265686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.270800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.275994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.281180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.286301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.291434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.296315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.301439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.306550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.311918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.316800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.321927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.327048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.332169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.337049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.342190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.347308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.352315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.357425] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.362547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.367680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.372820] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.377953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.383047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.388165] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.393304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.398558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.403675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.408789] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.413678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.418934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.424052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.428979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.434173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.439301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.444414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.449440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.454550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.459675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.464795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.469802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.475185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.480299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.485453] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.490553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.495685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.500810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.505583] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.510801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.515921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.521039] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.526180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.531334] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.536424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.541663] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.546561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.551932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.557067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.562218] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.567430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.572556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.577686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.582807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.587952] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.593049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.598173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.603053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.608186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.613297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.618540] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.623424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.628559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.633692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.638846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.644051] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.658825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.663928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.669058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.677692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.682925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.688065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.693165] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.698066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.703172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.708559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.713661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.718572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.723677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.728810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.733910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.738940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.744052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.749167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.754324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.759557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.764685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.769807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.775071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.780172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.785307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.790414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.795312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.800423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.805558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.810661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.815571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.820676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.825810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.830984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.836181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.841357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.846554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.851621] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.856801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.861931] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.867039] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.871956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.877175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.882308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.887410] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.892324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.897424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.902547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.907697] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.912928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.918059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.923177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.928445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.933548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.938681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.943787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.948697] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.953922] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.959059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.964160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.969073] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.974174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.979295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.984448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.989676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.994809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14490.999927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.005066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.010175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.015310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.020417] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.025316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.030429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.035554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.040661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.045568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.050673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.055803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.070927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.076055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.084624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.089562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.094692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.099802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.104986] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.110181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.115434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.120538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.125432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.130549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.135685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.140786] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.146180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.151307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.156421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.161701] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.166929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.172060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.177180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.182065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.187174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.192312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.197418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.202314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.207423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.212546] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.217660] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.222815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.227958] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.233050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.238259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.243423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.248558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.253661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.258563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.263677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.268807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.273913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.278818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.283925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.289060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.294163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.299440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.304550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.309680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.314563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.319797] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.325188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.330288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.335304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.340429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.345558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.350661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.355817] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.360926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.366046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.371181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.376426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.381560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.386685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.391824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.397070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.402309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.407415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.412316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.417426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.422548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.427667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.432810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.437951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.443058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.448196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.453305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.458551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.463686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.474435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.479677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.484808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.489914] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.494950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.500049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.505184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.510290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.516609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.521938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.527047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.531959] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.537052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.542185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.547290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.552189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.557299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.562428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.567539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.572445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.577549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.582672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.587835] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.593052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.598184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.603308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.608298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.613422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.618559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.623667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.628562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.633674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.638805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.643913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.649073] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.654172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.659302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.664437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.669677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.674807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.679930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.684969] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.690173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.695310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.700410] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.705321] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.710424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.715553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.720659] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.725563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.730677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.735807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.740923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.746053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.751173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.756302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.761178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.766417] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.771684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.776788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.781943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.787049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.792185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.797288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.802444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.807676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.812799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.817978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.823172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.828555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.833676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.838585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.843795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.848928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.854040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.858954] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.864049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.869170] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.884300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.889554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.894681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.899568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.904686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.909799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.915296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.920172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.925308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.930422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.935539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.940422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.945559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.950695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.955825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.961050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.966173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.971335] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.976434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.981689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.986799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.991918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14491.996799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.001932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.007049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.012164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.017052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.022182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.027301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.032184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.037302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.042434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.047546] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.052452] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.057548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.062672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.067785] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.072808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.077950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.083046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.088169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.093053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.098183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.103296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.108572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.113805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.118931] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.124060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.128964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.134174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.139298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.144412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.149431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.154550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.159673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.164792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.169673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.174813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.179924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.185323] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.190426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.195553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.200673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.205577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.210795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.215920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.236174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.240549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.248442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.254811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.262666] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.267547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.277426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.281790] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.286176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.290542] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.294933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.308942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.313302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.317798] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.322184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.326301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.330674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.330982] xc2028 1-0061: Loading firmware for type=D2620 DTV78 (108), id 0000000000000000.
[14492.336170] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.341320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.345444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.353676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.361973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.370677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.375056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.379420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.387433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.391802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.398166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.402319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.410548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.414928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.419054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.425937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.430301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.434674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.438815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.443928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14492.444235] xc2028 1-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.

-------TUNING UNSUCCESSFULLY TO RAI 1-------

[14544.723487] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[14546.286238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.294630] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.298879] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.303105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.307983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.419488] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.424360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.429507] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.434478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.439479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.444345] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.449490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.454482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.459481] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.464343] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.469490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.474482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.479480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.484352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.489232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.494106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.499006] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.503999] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.508995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.513979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.519112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.524007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.529119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.534232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.539350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.544229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.549358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.554478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.559593] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.564484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.569607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.574759] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.579873] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.585244] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.590355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.595486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.600484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.605617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.610732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.615854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.620735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.625855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.630980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.636098] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.640978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.646113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.651234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.656125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.661231] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.666356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.671476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.676357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.681496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.686605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.691848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.696736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.701863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.706984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.711888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.716980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.722116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.727220] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.732130] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.737233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.742370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.747469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.752873] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.757991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.763105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.768495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.773608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.778740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.783847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.788745] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.793854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.798985] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.804097] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.809495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.814616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.819731] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.824885] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.829979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.835245] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.840362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.845499] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.850599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.855751] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.860846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.865757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.870858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.875980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.881091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.886116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.891228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.896361] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.901242] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.912367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.919387] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.924482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.929604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.938136] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.943232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.948492] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.953597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.958497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.963606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.968739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.973843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.978752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.983856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.988992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.994125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14546.999233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.004353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.009485] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.014643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.019868] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.025245] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.030345] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.035248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.040357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.045489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.050591] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.055506] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.060605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.065735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.070889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.075982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.081105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.086242] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.091119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.096355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.101495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.106594] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.111496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.116606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.121865] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.126970] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.132002] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.137107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.142240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.147341] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.152256] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.157354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.162484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.167628] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.172858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.177995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.183110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.188378] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.193484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.198617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.203721] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.208628] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.213730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.218867] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.223967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.228881] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.233984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.239113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.244256] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.249486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.254613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.259732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.264964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.270107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.275240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.280346] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.285234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.290356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.295492] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.300596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.305505] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.310607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.324743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.329859] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.335248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.340381] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.345486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.350606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.355741] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.360627] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.365610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.370728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.375847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.380734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.385858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.390978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.396102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.401021] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.406616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.411862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.416982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.422100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.426982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.432121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.437230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.442234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.447356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.452482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.457605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.462516] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.467726] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.472857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.477989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.482864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.487990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.493107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.498602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.503480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.508745] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.513856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.518856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.523983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.529116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.534235] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.539129] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.544226] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.549357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.554467] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.559495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.564615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.569729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.574848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.579730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.584870] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.589982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.595255] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.600356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.605492] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.610602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.615509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.620735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.625853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.630969] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.636121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.641230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.646354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.651469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.656355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.661497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.666605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.671895] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.677105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.682244] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.687360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.692497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.697606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.702733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.707845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.712866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.723729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.732982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.738113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.743230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.748629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.753855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.758990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.764102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.768910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.774106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.779233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.784342] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.789489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.794612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.799730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.804845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.809728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.814867] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.819981] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.825252] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.830354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.835489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.840608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.845512] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.850730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.855855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.860970] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.866119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.871228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.876356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.881472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.886358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.891489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.896607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.901902] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.907106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.912233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.917364] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.922741] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.927859] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.932983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.938095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.943230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.948615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.953727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.958910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.964107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.969232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.974363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.979620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.984732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.989855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14547.995221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.000102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.005243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.010357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.015472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.020360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.025488] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.030607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.035489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.040604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.045859] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.050985] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.055907] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.061104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.066228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.071350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.076232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.081368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.086476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.091843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.096730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.101992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.107099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.112112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.117237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.122366] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.137606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.142734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.151286] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.156114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.161230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.166485] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.171586] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.176739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.181989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.187095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.191999] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.197106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.202240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.207342] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.212247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.217355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.222479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.227610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.232858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.237989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.243112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.248376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.253476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.258613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.263720] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.268629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.273728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.278863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.283967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.288870] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.293973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.299113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.304237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.309482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.314616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.319733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.324930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.330104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.335238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.340345] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.345251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.350358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.355486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.360591] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.365504] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.370607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.375739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.380849] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.385984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.391108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.396233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.401103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.406234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.411368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.416484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.421582] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.426735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.431864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.436966] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.441880] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.446981] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.452115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.457219] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.462125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.467230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.472363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.477465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.482376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.487483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.492607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.497495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.502609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.507729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.512846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.517742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.522980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.528119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.542983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.548115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.553225] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.558627] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.563854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.568993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.574108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.579487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.584616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.589730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.594854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.599729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.604854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.609974] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.615226] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.620107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.625243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.630360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.635288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.640479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.645742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.650844] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.655749] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.660855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.665980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.671094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.676117] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.681230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.686354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.691470] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.696358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.701489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.706606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.711615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.716729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.721991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.727093] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.731981] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.737104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.742250] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.747342] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.752250] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.757355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.762480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.767592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.772502] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.777603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.782731] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.787615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.792853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.798004] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.803094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.807995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.813103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.818488] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.823594] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.828503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.833603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.838738] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.843839] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.848876] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.853976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.859104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.864254] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.869483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.874620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.879735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.884974] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.890105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.895235] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.900343] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.905234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.910352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.915480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.920592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.925752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.930857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.935979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.951120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.956350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.961486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.966368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.971495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.976604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.981848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.986733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.991991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14548.997102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.002233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.007103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.012241] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.017351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.022510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.027606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.032729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.037853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.042902] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.048117] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.053229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.058473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.063360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.068613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.073733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.078847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.083732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.088863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.093977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.098980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.104103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.109230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.114362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.119491] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.124617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.129729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.134846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.139730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.144865] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.149982] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.155222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.160105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.165240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.170352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.175503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.180729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.185853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.190988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.196235] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.201370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.206480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.211845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.216730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.221991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.227102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.232223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.237108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.242234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.247359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.252258] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.257354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.262481] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.267596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.272496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.277602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.282853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.287979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.293105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.298490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.303601] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.308735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.313856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.318997] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.324110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.329002] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.334103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.339228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.354478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.359604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.364734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.369629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.374866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.379980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.385224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.390105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.395364] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.400478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.405597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.410479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.415616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.420724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.425920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.431101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.436350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.441484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.446492] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.451989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.457102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.462222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.467103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.472368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.477480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.482592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.487477] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.492602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.497738] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.502760] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.507996] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.513102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.518473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.523356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.528612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.533723] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.538850] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.543722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.548990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.554100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.559281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.564478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.569606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.574735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.579625] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.584868] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.589974] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.595224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.600107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.605234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.610351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.615596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.620475] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.625740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.630857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.635739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.640853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.645979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.651111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.656125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.661230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.666353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.671472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.676360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.681489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.686604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.691843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.696727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.701988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.707107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.712114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.717230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.722363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.727483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.732370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.737480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.742605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.747719] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.757619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.762856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.767992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.773095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.778270] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.783476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.788614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.793716] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.798615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.803728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.808864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.813987] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.819231] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.824353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.829484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.834626] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.839729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.844853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.849968] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.854876] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.859980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.865237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.870339] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.875250] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.880352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.885488] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.890605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.895742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.900975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.906113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.911242] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.916479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.921862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.926965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.931889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.937101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.942237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.947339] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.952251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.957353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.962474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.967623] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.972863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.977991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.983103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.988377] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.993480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14549.998610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.003714] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.008627] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.013729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.018863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.023963] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.028874] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.033978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.039114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.044240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.049349] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.054475] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.059609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.064374] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.069603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.074739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.079843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.084746] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.089852] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.095240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.100338] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.105250] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.110356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.115487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.120588] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.125503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.130728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.135857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.140745] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.145856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.159505] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.164740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.169853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.175232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.180244] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.185364] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.190478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.195597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.200479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.205617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.210729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.215846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.220725] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.225851] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.230977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.236251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.241369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.246478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.251856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.256869] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.261990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.267101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.272221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.277101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.282239] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.287351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.292344] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.297227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.302367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.307473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.312610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.317727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.322857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.327989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.332913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.338112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.343228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.348598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.353478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.358617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.363728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.368847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.373724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.378860] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.384000] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.389111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.394229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.399352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.404480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.409498] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.414617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.419727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.424846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.429728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.434864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.439975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.445220] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.450104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.455238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.460376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.465529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.470734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.475852] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.480984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.485910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.491103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.496227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.501342] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.506227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.511365] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.516479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.521851] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.526729] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.531858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.536990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.542109] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.547229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.552362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.567474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.572606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.577732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.582756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.587993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.593101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.598470] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.603356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.608612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.613725] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.618847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.623726] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.628864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.633984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.638928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.644099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.649224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.654340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.659490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.664616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.669725] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.674843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.679728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.684867] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.689977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.695254] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.700351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.705490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.710607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.715509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.720724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.725853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.730965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.736114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.741229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.746477] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.751844] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.756731] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.761985] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.767105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.771902] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.776977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.782114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.787214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.792120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.797221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.802362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.807469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.812371] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.817478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.822601] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.827711] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.832870] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.837990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.843107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.848274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.853474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.858614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.863715] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.868615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.873730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.878853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.883965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.888882] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.893978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.899111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.904212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.909121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.914227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.919355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.924245] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.929349] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.934476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.939592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.944489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.949726] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.954865] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.969731] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.975238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.984456] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.989615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.994736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14550.999932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.004978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.010103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.015232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.020338] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.025229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.030351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.035484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.040590] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.045749] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.050855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.055976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.061126] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.066352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.071490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.076604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.081877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.086973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.092112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.097216] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.102115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.107227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.112367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.117464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.122370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.127479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.132728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.137891] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.143102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.148610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.153721] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.158625] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.163725] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.168864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.173966] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.178880] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.183976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.189110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.194213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.199618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.204736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.209854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.214944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.220100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.225239] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.230339] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.235232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.240352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.245483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.250589] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.255491] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.260600] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.265736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.270836] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.275746] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.280980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.286105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.306095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.310243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.318107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.324363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.331990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.337098] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.347007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.351362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.355752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.360106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.364464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.368624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.372976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.377352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.381727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.385904] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.396116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.396429] xc2028 1-0061: Loading firmware for type=D2620 DTV78 (108), id 0000000000000000.
[14551.405004] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.410101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.414478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.422727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.430987] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.439593] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.443722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.448111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.456357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.460462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.466603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.471104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.479346] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.483479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.487848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.494979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.499110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.503227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.507854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.512976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[14551.513283] xc2028 1-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.

Some lines from mplayer:
dvb_tune Freq: 177500000
Not able to lock to the signal on the given frequency, timeout: 30
dvb_tune, TUNING FAILED
ERROR, COULDN'T SET CHANNEL  363: Failed to open dvb://Rai 1.

-------lsusb device details-------

Bus 001 Device 015: ID 0b05:1736 ASUSTek Computer, Inc. 
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0b05 ASUSTek Computer, Inc.
   idProduct          0x1736
   bcdDevice            1.00
   iManufacturer           1 ASUSTeK
   iProduct                2 U3000 Hybrid
   iSerial                 3 0550100291
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval              10
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x82  EP 2 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               1
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)
