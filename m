Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:44920 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbeASVHB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 16:07:01 -0500
Received: by mail-wm0-f44.google.com with SMTP id t74so5854568wme.3
        for <linux-media@vger.kernel.org>; Fri, 19 Jan 2018 13:06:59 -0800 (PST)
Date: Fri, 19 Jan 2018 22:06:34 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: linux-media@vger.kernel.org
cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Sean Young <sean@mess.org>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Asus My Cinema-U3000Hybrid an dmesg flooding
Message-ID: <alpine.LNX.2.21.99.1801192158390.2221@mStation.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys!

First of all - thank you for your excellent and continued wok, which, amongst other things, allowed me to use this very nice piece of hardware.
The problem is, as I pointed out, the dmesg flooding happening any time I tune to a channel, see [1].
In a modprobe.d file I have the following media related quirks:
options tuner_xc2028 firmware_name=xc3028L-v36.fw
options dvb_usb_v2 disable_rc_polling=1
options dvb_usb disable_rc_polling=1

The tuner_xc2028 related quirk allows for much better performance. Infact the device works perfectly.
I used the "disable_rc_polling" as a possible workaround. I added it also to V2 device at some point, don't remember exactly why. Still, I am not using the IR transmitters, at least for now.

Thank you very very much again for all,
Enrico

[1]: dmesg:
As you'll know for sure :) ... the "xc2028 8-0061: Loading firmware" denotes tuning is completing. All works then.


[38397.715496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.723629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.731742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.738871] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.746997] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.755113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.762254] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.770356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.778497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.785628] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.793749] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.801879] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.809018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.817144] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.825236] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.832373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.840518] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.848633] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.855767] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.863853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.871992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.879151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.887255] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.895365] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.902510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.910669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.918803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.925945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.934082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.942234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.949394] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.957564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.965694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.972831] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.980978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.989095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38397.996274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.004441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.012598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.019680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.027804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.035927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.043106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.051269] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.059415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.066554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.074661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.082810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.089957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.098105] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.106263] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.113432] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.121582] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.129722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.136877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.145015] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.153191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.160333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.168498] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.176615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.183748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.191874] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.200023] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.207189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.215269] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.223427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.230608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.238747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.246866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.253991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.262137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.270173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.277310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.285462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.293598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.300763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.308893] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.317023] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.324210] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.332320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.340440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.347567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.355696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.363799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.370958] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.379102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.387179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.394310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.402472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.410591] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.417752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.425878] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.433896] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.441037] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.449201] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.457347] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.464516] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.472644] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.480734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.487830] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.495976] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.504107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.511194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.519265] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.527444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.534560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.542698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.550819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.557955] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.566102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.574215] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.581372] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.589544] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.597652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.604833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.612998] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.621122] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.628225] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.636369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.644508] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.651684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.659830] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.667943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.675094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.683247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.691363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.698467] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.706621] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.714736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.721889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.730040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.738156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.745288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.753412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.761568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.768683] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.776829] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.784972] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.792113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.800179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.808313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.815452] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.823620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.831744] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.838888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.847038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.855174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.862302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.870427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.878567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.885746] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.893867] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.901987] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.909119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.917177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.925326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.932481] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.940640] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.948758] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.955887] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.964033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.972182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.979350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.987475] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38398.995612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.002765] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.010876] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.018941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.026115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.034226] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.042363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.049489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.057639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.065756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.072937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.081100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.089175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.096327] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.104427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.112498] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.119641] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.127787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.135904] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.143052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.151178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.159311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.166443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.174574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.182709] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.189870] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.197995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.206109] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.213185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.221310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.229446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.236600] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.244764] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.252911] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.260062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.268187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.276344] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.283474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.291619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.299746] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.306888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.315016] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.323173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.330325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.338472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.346592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.353762] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.361889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.370027] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.377162] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.385261] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.393381] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.400562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.408722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.416856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.423989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.432137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.440213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.447368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.455514] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.463652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.470830] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.478967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.487098] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.494185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.502298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.510415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.517511] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.525637] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.533777] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.540953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.549099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.557145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.564259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.572386] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.580534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.587675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.595815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.603966] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.611127] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.619224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.627337] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.634375] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.641093] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.647940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.655188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.662937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.670688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.677763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.685924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.694041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.701200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.709340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.717464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.724610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.732740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.740873] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.748005] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.756137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.764211] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.771340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.779467] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.787604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.794743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.802911] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.811025] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.818186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.826330] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.834467] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.841621] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.849748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.857880] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.865057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.873223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.881327] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.888471] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.896637] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.904756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.911905] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.920033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.928149] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.935179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.945171] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.952559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.959926] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.967190] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.975158] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.983104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.990365] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38399.998323] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.006296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.013490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.021411] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.029330] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.036597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.056298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.063392] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.074096] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.083202] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.093866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.101796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.114418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.120636] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.127797] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.134970] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.142171] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.148366] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.155470] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.162618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.168791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.175954] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.183110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.185194] xc2028 8-0061: Loading firmware for type=D2620 DTV7 (88), id 0000000000000000.
[38400.191029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.198654] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.205496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.216004] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.227120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.238587] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.245786] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.252962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.263179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.270317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.279463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.285761] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.296869] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.304079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.311273] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.320328] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.327469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.334624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.340911] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.348847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38400.351983] xc2028 8-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
[38414.334325] xc2028 8-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[38415.887005] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38415.891085] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38415.895198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38415.899238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38415.904095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.012853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.017694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.022579] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.027442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.032317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.037223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.042169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.047082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.051980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.056923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.061743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.066655] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.071564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.076481] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.081383] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.086288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.091206] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.096109] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.101017] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.105941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.110830] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.115751] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.120695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.125619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.130541] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.135438] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.140334] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.145259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.152320] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.161235] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.169491] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.177670] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.184939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.193177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.201415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.208923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.217603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.226245] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.233557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.242011] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.250464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.257886] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.266288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.274697] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.282076] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.290478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.298858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.306268] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.314664] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.323031] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.330381] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.338685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.347045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.354330] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.362560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.370735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.378010] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.386221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.394617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.403016] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.410102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.418058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.425988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.433274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.441435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.449602] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.456773] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.464912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.473031] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.480222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.488350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.496462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.503465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.512305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.520407] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.527435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.535517] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.543634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.550700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.558780] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.566880] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.574016] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.582137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.590278] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.597406] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.605538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.613653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.620772] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.628914] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.637033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.644186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.652325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.660451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.667622] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.675706] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.683843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.691017] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.699184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.707321] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.714472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.722600] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.730652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.737769] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.745919] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.753918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.761075] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.769167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.777312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.784480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.792617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.800693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.807813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.815950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.824090] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.831224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.839371] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.847501] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.854631] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.862698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.870821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.877947] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.886096] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.894212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.901367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.909489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.917611] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.924721] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.932822] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.940945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.948129] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.956271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.964424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.971553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.979678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.987754] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38416.994938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.003036] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.011145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.018251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.026391] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.034532] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.041681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.049766] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.057879] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.065000] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.073157] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.081271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.088439] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.096574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.104710] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.111855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.119996] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.128108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.135251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.143412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.151551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.158681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.166784] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.174896] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.182037] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.190182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.198300] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.205450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.213599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.221653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.228787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.236931] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.245050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.252176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.260305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.268279] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.275435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.283534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.291653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.298765] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.306910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.315042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.322200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.330329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.338483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.345662] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.353766] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.361906] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.369052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.377185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.385323] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.392494] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.400684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.408752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.415842] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.423994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.432110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.439256] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.447383] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.455530] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.462696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.470806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.478944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.486097] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.494223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.502332] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.509474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.517576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.525647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.532744] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.540890] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.549002] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.556181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.564326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.572441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.579624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.587700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.595816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.602977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.611141] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.619252] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.626384] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.634514] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.642622] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.649748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.657889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.666002] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.673131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.681268] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.689372] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.696538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.704700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.712842] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.719992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.728138] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.736251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.743402] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.751532] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.759670] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.766770] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.774889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.783029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.790183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.798298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.806418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.813555] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.821700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.829813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.836992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.845127] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.853246] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.860408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.868550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.876688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.883825] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.891967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.900089] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.907236] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.915360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.923483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.930639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.938762] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.946899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.954055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.962179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.970293] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.977437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.985577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38417.993646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.000782] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.008924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.019196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.026156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.033232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.040352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.047483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.054616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.061712] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.068728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.075469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.082318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.089458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.096593] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.103672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.110791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.117914] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.125025] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.132172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.139278] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.146405] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.153523] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.160652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.167796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.174900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.182032] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.189145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.196290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.203399] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.210526] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.217660] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.224801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.231912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.239023] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.246167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.253275] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.260374] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.267529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.274666] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.281788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.288916] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.296023] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.303163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.310276] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.317403] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.324547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.331670] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.338795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.345940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.353066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.360219] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.367369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.374482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.381601] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.388669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.395795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.402910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.410024] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.417152] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.424282] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.431394] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.438491] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.445604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.452668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.459808] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.466933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.474043] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.481128] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.488247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.495356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.502494] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.509538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.516663] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.523782] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.530917] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.538023] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.545136] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.552276] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.559401] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.566517] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.573643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.580724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.587856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.594980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.602120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.609248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.616374] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.623509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.630652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.637772] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.644916] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.652033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.659149] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.666224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.673331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.680489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.687605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.694702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.701845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.708977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.716107] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.723230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.730354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.737476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.744604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.751695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.758812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.765936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.773079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.780184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.787316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.794445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.801567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.808653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.815790] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.822930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.830062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.837183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.844336] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.851463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.858588] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.865686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.872801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.879936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.887079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.894213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.901349] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.908482] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.915598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.922667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.929772] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.936921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.944041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.951152] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.958296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.965415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.972522] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.979646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.986774] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38418.993903] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.001044] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.008160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.015243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.022399] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.029537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.036644] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.043769] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.050913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.058045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.065160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.072271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.079372] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.086478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.093603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.100709] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.107842] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.114960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.122119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.129224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.136354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.143478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.150603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.157713] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.164833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.171960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.179099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.186228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.193353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.200469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.207583] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.214662] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.221787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.228924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.236057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.243186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.250309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.257444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.264589] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.271701] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.278853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.285977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.293123] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.300274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.307412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.314520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.321646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.328783] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.335899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.343019] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.350151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.357288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.364396] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.371524] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.378648] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.385764] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.392898] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.399984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.407118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.414242] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.421349] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.428458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.435584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.442700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.449813] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.456932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.464035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.471184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.478289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.485396] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.492536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.499638] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.506827] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.514035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.521022] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.528803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.536620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.544596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.552549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.560560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.568553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.576530] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.584517] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.592519] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.600534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.608536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.616535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.624519] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.632535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.640538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.648551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.656552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.664534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.672536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.680547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.688569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.696558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.704535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.712564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.720539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.728520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.736492] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.744518] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.752521] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.760663] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.768796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.776091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.783408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.791176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.799082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.807055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.815035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.823055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.831056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.839077] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.847100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.855084] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.863237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.871369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.878383] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.885344] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.893138] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.900958] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.908946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.916873] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.924816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.932791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.940927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.949038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.956164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.964317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.972468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.979604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.987693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38419.995812] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.002942] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.011089] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.019207] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.026344] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.034496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.042598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.049779] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.057921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.066038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.073175] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.081318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.089449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.096605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.104696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.112809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.119901] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.126686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.134620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.142583] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.149814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.157960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.166095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.173243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.181376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.189520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.196606] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.204734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.212849] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.220005] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.228170] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.236290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.243446] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.251613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.259669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.266844] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.274967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.283082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.290214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.298674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.306806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.313868] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.321999] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.330072] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.337228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.345352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.353493] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.360677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.368833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.376949] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.384084] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.392234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.400346] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.407520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.415608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.423752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.430900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.439038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.447146] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.454304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.462465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.470642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.477811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.485938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.494081] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.501213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.509297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.517415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.524544] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.532650] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.540758] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.547912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.556046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.564161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.571312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.579483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.587617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.594800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.602920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.611034] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.618172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.626314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.634459] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.641654] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.649804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.657955] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.665104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.673256] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.681394] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.688565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.696688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.704805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.711967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.720108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.728223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.735373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.743455] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.751598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.758675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.766795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.774917] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.782070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.790189] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.798324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.805484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.813674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.821796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.828920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.837048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.845180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.852316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.860457] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.868599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.875792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.883923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.892037] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.899167] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.907290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.915411] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.922552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.930694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.938804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.945941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.954086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.962228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.969400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.977545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.985636] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38420.992800] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.000939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.008988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.016153] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.024120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.033053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.040116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.048251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.056393] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.063558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.071668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.079805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.086901] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.095041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.103156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.110294] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.118416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.126549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.133646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.141792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.149904] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.157043] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.165161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.173283] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.180429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.188562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.196653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.203832] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.211959] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.220091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.227224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.235350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.243506] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.250599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.258679] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.266815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.273944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.282089] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.290200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.297382] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.305545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.313614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.320763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.328895] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.337026] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.344194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.352340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.360472] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.367594] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.375687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.383845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.391003] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.399121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.407269] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.414434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.422580] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.430700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.437858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.446022] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.454157] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.461295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.469416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.477550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.484733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.492897] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.501006] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.508085] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.516252] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.524387] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.531537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.539631] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.547781] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.554936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.563062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.571196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.578356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.586496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.594585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.601734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.609894] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.618013] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.625192] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.633329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.641457] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.648613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.656749] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.664889] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.672056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.680163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.688281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.695414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.703537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.711642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.718789] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.726932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.735062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.742214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.750356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.758490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.765629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.772796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.781013] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.788993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.797005] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.805030] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.813030] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.821065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.829064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.837093] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.845092] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.853139] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.861148] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.869137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.877150] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.885047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.893052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.901049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.909067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.917064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.925016] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.932951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.940872] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.948915] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.956078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.964227] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.972340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.979502] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.987603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38421.995733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.002872] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.011021] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.019128] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.026211] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.034375] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.042510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.049615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.057741] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.065866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.073038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.081164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.089299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.096457] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.104620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.112754] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.119897] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.128060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.136194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.143373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.151489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.159551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.166639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.173484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.181238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.189009] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.196079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.204214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.212343] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.219486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.227545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.235686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.242835] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.250998] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.259094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.266271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.274390] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.282516] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.289617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.297757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.305857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.313110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.321236] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.329390] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.336567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.344706] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.352837] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.359988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.368115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.376258] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.383418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.391551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.399643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.406787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.414912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.423027] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.430188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.438331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.446450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.453535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.461645] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.469765] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.476908] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.485026] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.493152] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.500288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.508411] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.516532] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.523646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.531630] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.541093] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.548075] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.555998] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.563944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.571201] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.579324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.587448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.594585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.602750] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.610886] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.618018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.626182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.634317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.641455] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.649536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.657672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.664804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.672954] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.681086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.688248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.696414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.704550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.711681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.719826] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.727973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.735124] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.743287] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.751427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.758536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.766621] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.774761] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.781906] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.790018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.798136] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.805293] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.813431] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.821550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.828739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.836863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.845008] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.852163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.860284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.868396] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.875536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.883609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.891741] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.898919] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.907042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.915152] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.922307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.930433] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.938478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.945583] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.953733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.961840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.968994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.977134] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.985278] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38422.992428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.000558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.008639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.015787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.023828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.031913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.039018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.047162] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.055288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.062451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.070514] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.078662] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.097664] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.105237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.116275] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.125791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.136896] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.145269] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.158256] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.164462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.171793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.179383] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.186943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.193144] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.200325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.207481] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.213618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.217592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.224787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.228283] xc2028 8-0061: Loading firmware for type=D2620 DTV7 (88), id 0000000000000000.
[38423.234951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.242040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.248434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.259080] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.270615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.282528] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.290148] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.297740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.307852] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.315228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.324568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.330760] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.342034] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.349645] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.357213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.366142] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.373465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.380788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.386975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.394948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38423.398073] xc2028 8-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
[38451.439301] xc2028 8-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[38452.992295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38452.996377] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.000503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.004595] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.009487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.115805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.120668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.125571] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.130465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.135297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.140174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.145052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.149953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.154840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.159748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.164632] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.169533] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.174404] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.179257] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.184092] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.188965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.193805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.198624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.203539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.208434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.213330] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.218238] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.223166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.228059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.232998] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.237936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.242815] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.247740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.254770] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.263739] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.272649] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.279786] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.288026] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.296251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.303722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.312402] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.321089] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.328497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.336928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.345388] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.352747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.361179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.369609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.376988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.385379] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.393743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.401140] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.409560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.418203] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.426753] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.433964] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.442160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.450342] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.457699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.466127] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.474499] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.481766] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.490200] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.498609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.505853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.514201] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.522274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.529436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.537515] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.545649] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.552761] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.560906] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.569040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.576202] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.584348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.592484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.599642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.607738] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.615877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.623013] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.631161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.639276] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.646407] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.654554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.662676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.669785] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.677929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.686044] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.693196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.701325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.709440] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.716618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.724680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.732810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.739993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.748152] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.756296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.763426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.771536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.779655] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.786788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.794949] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.803090] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.810241] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.818360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.826497] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.833534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.841678] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.849811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.856993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.865131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.873247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.880380] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.888513] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.896637] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.903717] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.911845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.919980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.927110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.935262] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.943376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.950559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.958665] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.966795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.973911] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.982055] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.990163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38453.997341] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.005486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.013624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.020718] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.028888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.037029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.044181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.052302] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.060420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.067565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.075696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.083810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.090949] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.099095] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.107233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.114421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.122553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.130685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.137821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.145950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.154081] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.161211] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.171114] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.178594] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.186089] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.193241] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.201409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.209539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.216698] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.224803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.232875] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.240007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.248137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.256246] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.263388] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.271469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.279615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.286667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.294769] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.302904] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.310057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.318176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.326312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.333476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.341607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.349703] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.356845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.364991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.373118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.380252] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.388400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.396535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.403669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.411760] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.419903] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.426968] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.435119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.443240] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.450405] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.458551] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.466671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.473824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.481994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.490106] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.497233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.505360] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.513503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.520658] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.529015] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.537364] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.544427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.552574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.560661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.567819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.575969] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.584103] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.591261] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.599420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.607556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.614696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.622842] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.630961] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.638052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.646168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.654299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.661463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.669611] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.677689] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.684843] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.692984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.701118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.708259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.716430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.724559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.731659] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.739781] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.747899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.755052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.763177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.771182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.778369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.786490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.794623] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.801762] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.809898] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.818035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.825193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.833313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.841437] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.848618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.856717] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.864858] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.872009] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.880177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.888312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.895442] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.903611] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.911718] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.918810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.926927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.934368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.941181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.949127] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.957042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.964315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.972447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.980585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.987714] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38454.995857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.003979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.011113] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.019213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.027353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.034480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.042634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.050770] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.057950] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.066094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.074229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.081372] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.089509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.097672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.104821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.112944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.121056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.128177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.136315] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.144434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.151587] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.159694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.167856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.175031] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.183168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.191289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.198451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.206605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.214702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.221862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.229991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.238054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.245193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.253310] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.261468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.268549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.276713] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.284828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.291991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.300133] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.308243] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.315382] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.323552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.331622] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.338782] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.346924] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.355060] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.362195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.370341] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.378473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.385639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.393757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.401895] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.409027] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.417174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.425287] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.432422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.440548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.448616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.455740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.463905] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.471943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.479120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.487257] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.495369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.502512] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.510673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.518736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.525900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.534020] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.542148] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.549296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.557416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.565534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.572690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.580840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.588957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.596115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.604258] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.612369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.619540] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.627668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.635809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.642940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.651070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.659186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.666340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.674371] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.682495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.689588] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.697694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.705837] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.712990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.721132] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.729255] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.736401] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.744529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.752643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.759798] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.767939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.776080] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.783212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.791354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.799474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.806605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.814692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.822832] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.829979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.838112] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.846222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.853354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.861479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.869617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.876740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.884862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.892992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.900131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.908275] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.916400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.923547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.931629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.939742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.946885] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.955045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.963172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.970313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.978464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.986607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38455.993740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.001875] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.010024] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.017135] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.025274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.033394] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.040563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.048624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.056741] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.063907] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.072059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.080181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.087345] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.095499] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.103619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.110778] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.118937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.127066] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.134210] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.142356] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.150471] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.157633] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.165788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.173908] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.181086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.189214] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.197325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.204487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.212674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.220778] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.227909] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.236071] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.244182] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.251316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.259463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.267538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.274595] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.282670] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.290788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.297885] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.306046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.314178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.321340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.329507] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.337655] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.344788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.352918] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.361054] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.368212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.376355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.384473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.391634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.399775] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.407895] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.415062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.423216] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.431367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.438496] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.446629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.454742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.461885] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.470049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.478172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.485314] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.493462] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.501599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.508707] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.516861] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.525018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.532151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.540296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.548408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.555561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.563603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.571724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.578877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.587045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.595186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.602316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.610463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.618596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.625704] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.633851] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.641975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.649145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.657293] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.665411] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.672562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.680671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.688777] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.695912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.704046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.712176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.719313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.727459] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.735586] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.742743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.750899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.759021] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.766151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.774296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.782424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.789569] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.797669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.805805] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.812956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.821084] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.829237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.836380] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.844503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.852554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.859650] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.867803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.875930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.883111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.891253] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.899366] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.906500] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.914649] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.922756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.929900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.938045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.946222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.953378] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.961525] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.969577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.976595] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.983382] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.990183] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38456.997572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.005072] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.012464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.020866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.029221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.036291] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.044418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.052542] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.059648] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.067801] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.075920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.083061] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.091185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.099328] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.106483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.114620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.122766] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.129912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.138046] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.146154] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.153309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.161460] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.169576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.176537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.185946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.193216] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.200616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.207968] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.216316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.224638] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.231592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.239547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.247468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.254754] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.262878] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.270989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.278099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.286223] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.294316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.301485] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.309619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.317734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.324864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.333025] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.341137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.348309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.356451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.364576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.371723] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.379857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.387966] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.395125] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.403271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.411409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.418541] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.426580] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.434701] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.441854] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.450024] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.458166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.465308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.473459] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.481578] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.488685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.496811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.504952] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.512021] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.520164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.528313] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.535480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.543624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.551720] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.558816] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.566935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.575082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.582231] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.590390] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.598535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.605618] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.613743] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.621863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.628993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.637118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.645233] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.652380] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.660540] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.668609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.675748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.683887] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.692007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.699146] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.707290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.715457] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.722623] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.730748] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.738862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.745989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.754127] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.762174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.769311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.777421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.785560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.792707] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.800848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.808979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.816128] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.824271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.832389] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.839560] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.847665] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.855778] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.862948] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.871104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.879236] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.886373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.894541] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.902656] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.909793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.917914] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.926028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.933161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.941305] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.949426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.956596] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.964732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.972839] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.979978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.988124] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38457.996248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.003393] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.011522] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.019608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.026732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.034875] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.043017] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.050156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.058271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.066387] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.073565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.081685] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.089799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.096957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.105096] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.113225] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.120391] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.128531] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.136607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.143772] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.151919] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.160052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.167180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.175311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.183424] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.190535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.198709] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.206840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.213987] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.222123] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.230266] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.237410] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.245540] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.253641] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.260736] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.268871] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.276989] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.284121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.292248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.300392] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.307539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.315669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.323781] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.330913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.339040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.347158] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.354280] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.362436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.370544] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.377681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.385834] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.393946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.401101] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.409246] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.417390] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.424553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.432658] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.440795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.447930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.456078] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.464215] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.471378] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.479538] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.487634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.494803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.502941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.511010] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.518160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.526252] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.534384] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.541524] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.549614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.557733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.564888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.572996] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.581111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.588239] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.596372] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.604511] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.611609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.619771] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.627899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.635029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.643137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.651262] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.658409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.666539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.674626] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.681787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.691169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.698592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.706099] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.713247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.721415] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.729550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.736704] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.744824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.752968] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.760038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.768162] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.776287] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.783428] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.791581] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.799643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.806763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.814907] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.823009] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.830138] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.838288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.846401] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.853558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.861669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.869793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.876933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.885057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.893216] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.900341] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.908474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.916574] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.923728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.931894] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.940008] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.947140] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.955290] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.963416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.970562] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.978724] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.986856] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38458.994018] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.002162] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.010234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.017344] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.025435] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.032272] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.038945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.046185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.054326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.062466] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.069434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.077369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.085299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.092553] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.100702] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.108840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.115974] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.124092] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.132228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.139393] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.147510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.155604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.162747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.170882] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.179028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.186155] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.194298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.202423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.209578] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.217715] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.225865] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.233028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.241166] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.249312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.256477] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.264573] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.272663] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.279828] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.287994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.296131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.303282] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.311410] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.319522] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.326642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.334793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.342960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.350119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.358259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.366389] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.373535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.381616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.389754] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.396890] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.405025] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.413132] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.420277] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.428409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.436575] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.443761] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.451912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.460038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.467180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.475304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.483421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.490533] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.498617] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.506760] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.513917] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.522052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.530193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.537321] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.545473] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.553547] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.560706] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.568840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.576977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.584145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.592286] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.600426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.607518] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.615614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.623730] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.630840] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.638945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.647088] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.654231] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.662358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.670510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.677661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.685783] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.693899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.701033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.709159] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.717272] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.724404] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.732531] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.740648] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.747774] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.755912] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.764070] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.771178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.779325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.787463] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.794572] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.802696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.810809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.817973] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.826137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.834267] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.841402] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.849493] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.857584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.864722] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.872846] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.880962] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.888138] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.896278] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.904399] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.911550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.919704] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.927819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.934975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.943139] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.951281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.958425] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.966598] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.974719] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.981869] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.989991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38459.998128] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.005283] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.013426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.021478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.028575] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.036661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.044747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.051847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.059992] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.068100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.075251] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.083413] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.091503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.098622] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.106753] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.114882] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.122050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.130222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.138350] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.145484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.153595] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.161735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.168893] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.177031] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.185145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.192155] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.201186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.209007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.216802] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.223838] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.231888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.240048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.247196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.255345] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.263458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.270550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.278709] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.286818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.293990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.302118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.310299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.328633] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.336013] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.346910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.356226] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.367094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.375262] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.388077] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.394288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.401674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.409057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.416392] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.422620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.429706] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.436859] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.442974] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.446882] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.453979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.457259] xc2028 8-0061: Loading firmware for type=D2620 DTV7 (88), id 0000000000000000.
[38460.463744] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.471892] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.477978] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.489094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.500412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.512028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.519427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.526727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.536853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.544239] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.553542] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.559752] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.571012] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.578386] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.585668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.594605] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.601945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.609288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.615458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.623443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[38460.626567] xc2028 8-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
[39026.572033] xc2028 8-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[39028.124781] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.131224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.137681] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.144160] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.151443] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.260550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.265429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.270373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.275317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.280234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.285170] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.290100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.295042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.299956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.304810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.309727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.314668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.319564] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.324509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.329362] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.334303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.339207] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.344130] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.349040] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.353874] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.358734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.363623] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.368515] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.373405] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.378325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.383226] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.388131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.393062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.397991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.402913] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.407806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.412728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.417688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.422599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.431239] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.439369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.447434] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.454378] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.462328] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.470285] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.477487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.485639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.493728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.500874] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.509015] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.517065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.524198] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.532288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.540395] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.547486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.555612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.563753] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.570932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.579056] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.587201] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.594353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.602430] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.610568] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.617747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.625879] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.634029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.641186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.649327] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.657483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.664639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.672792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.680938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.688074] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.696221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.704359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.711426] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.719505] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.727659] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.734831] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.742965] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.751087] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.758263] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.766412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.774483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.781570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.789700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.797857] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.805010] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.813140] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.821281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.828452] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.836628] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.844750] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.851916] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.860028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.868151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.875283] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.883450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.891563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.898728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.906877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.915029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.922196] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.930348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.938412] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.945539] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.953695] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.961845] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.969006] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.977137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.985250] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39028.992367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.000494] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.008608] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.015696] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.023848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.031957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.039091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.047263] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.055414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.062537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.070639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.078799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.085946] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.094053] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.102161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.109298] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.117423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.125549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.132706] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.140892] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.149026] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.156194] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.164324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.172375] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.179466] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.187592] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.195712] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.202870] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.211008] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.219124] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.226292] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.234436] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.242561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.249672] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.257819] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.265901] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.272891] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.280848] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.288790] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.296035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.304179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.312275] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.319445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.327508] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.335573] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.342744] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.350905] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.359027] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.366164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.374304] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.382400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.389548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.397670] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.405782] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.412923] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.421069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.429193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.436348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.444445] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.452559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.459692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.467847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.475995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.483163] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.491319] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.499400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.506570] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.514694] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.522881] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.530011] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.538156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.546301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.553451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.561609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.569740] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.577855] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.584824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.594609] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.602102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.609582] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.616782] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.624927] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.633062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.640197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.648339] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.656399] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.663557] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.671675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.679793] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.686943] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.695069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.703213] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.710391] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.718498] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.726652] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.733803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.741925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.750058] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.757193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.765309] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.773395] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.780487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.788629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.796764] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.803903] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.812029] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.820147] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.827282] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.835429] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.843558] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.850692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.858821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.866938] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.874086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.882232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.890355] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.897483] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.905614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.913727] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.920886] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.929024] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.937168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.944316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.952406] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.960516] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.967654] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.975777] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.983898] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.991057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39029.999195] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.007311] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.014409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.022550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.030667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.037794] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.045932] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.054092] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.061264] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.069406] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.077529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.084666] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.092792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.100944] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.108108] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.116237] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.124368] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.131490] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.139627] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.147757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.154904] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.163042] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.171174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.178307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.186406] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.194520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.201654] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.209756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.217903] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.225048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.233191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.241312] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.248407] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.256577] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.264591] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.271687] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.279746] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.287853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.294940] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.303069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.311204] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.318366] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.326465] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.334590] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.341754] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.349873] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.357977] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.365177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.373318] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.381409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.388565] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.396693] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.404744] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.411582] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.418224] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.425614] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.433715] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.441836] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.449006] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.457132] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.465274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.472419] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.480508] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.488620] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.495750] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.503886] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.511934] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.519064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.527151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.535284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.542405] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.550548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.558661] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.565810] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.573939] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.582082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.589284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.597423] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.605542] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.612690] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.620824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.628936] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.636064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.644193] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.652333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.659479] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.667604] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.675710] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.682861] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.691006] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.699115] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.706289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.714358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.722476] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.729634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.737776] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.745897] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.753069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.761172] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.769306] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.776416] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.784505] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.792649] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.799790] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.807928] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.816083] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.823259] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.831422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.839529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.846667] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.854799] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.862910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.870047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.878171] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.886307] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.893413] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.901546] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.909663] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.916792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.924929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.933036] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.940173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.948295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.956388] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.963548] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.971673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.979791] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.986921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39030.995048] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.003161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.010244] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.018401] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.026535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.033671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.041814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.049963] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.057136] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.065301] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.073375] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.080537] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.088677] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.096637] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.103760] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.111899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.120007] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.127131] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.135275] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.143331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.150444] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.158590] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.166699] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.173853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.181990] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.190147] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.197297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.205358] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.213474] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.220629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.228750] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.236869] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.243994] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.252120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.260181] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.267363] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.275489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.283616] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.290747] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.298900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.307019] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.314177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.322316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.330450] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.337603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.345728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.353849] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.361004] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.369124] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.377274] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.384365] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.392505] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.400650] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.407733] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.415851] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.423988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.431117] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.439247] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.447391] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.454561] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.462692] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.470834] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.478010] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.486150] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.494246] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.501411] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.509517] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.517655] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.524776] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.532900] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.541017] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.548188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.556333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.564427] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.571579] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.579713] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.587853] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.594984] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.603129] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.611241] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.618381] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.626528] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.634662] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.641796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.649919] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.658032] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.665165] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.673296] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.681399] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.688549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.696664] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.704784] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.711921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.720045] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.728156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.735317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.743419] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.751535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.758647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.766796] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.774908] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.782044] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.790168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.798281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.805359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.813526] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.821623] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.828770] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.836899] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.845032] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.852169] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.860295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.868370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.875509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.883668] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.891803] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.898937] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.907085] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.915236] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.922378] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.930524] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.938675] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.945833] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.953960] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.962111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.969245] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.977379] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.985514] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39031.992648] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.000837] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.008920] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.016065] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.023266] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.031283] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.039212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.047199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.055205] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.063179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.071178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.079161] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.087158] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.095157] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.103186] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.111191] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.119219] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.127197] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.135199] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.143173] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.151184] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.159144] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.167079] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.175020] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.183015] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.190295] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.198418] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.206552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.213686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.221836] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.229945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.237085] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.245211] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.253326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.260397] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.268563] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.276680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.283866] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.291991] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.300137] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.307297] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.315400] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.323510] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.330648] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.338795] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.346929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.354062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.362205] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.370353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.377487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.385647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.393784] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.400941] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.409082] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.417220] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.424367] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.432495] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.440550] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.447645] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.455111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.461933] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.469865] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.477779] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.485067] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.493081] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.501219] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.508308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.516397] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.524529] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.531684] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.539809] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.547971] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.555116] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.563271] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.571359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.578489] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.586647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.594764] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.602037] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.610212] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.618348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.625532] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.633688] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.641804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.648955] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.657041] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.665185] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.672359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.680506] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.688613] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.695745] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.703864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.711985] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.719145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.727292] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.735359] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.742501] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.750639] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.758720] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.765863] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.773953] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.782090] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.789204] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.797347] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.805469] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.812625] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.820770] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.828887] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.836038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.844165] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.852281] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.859376] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.867520] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.875632] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.882771] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.890917] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.899049] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.906207] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.914333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.922448] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.929597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.937732] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.945838] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.952993] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.961145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.969262] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.976373] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.984526] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.992634] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39032.999792] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.007895] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.016034] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.023146] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.031289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.039452] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.046612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.054751] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.062862] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.069988] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.078147] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.086273] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.093420] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.101559] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.109674] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.116830] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.124954] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.133094] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.140273] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.148395] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.156512] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.163642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.171786] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.179905] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.187038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.195187] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.203324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.210486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.218619] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.226766] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.233910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.242035] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.250176] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.257325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.265413] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.273486] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.280629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.288709] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.296824] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.303954] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.312104] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.320235] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.327357] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.335509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.343653] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.350788] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.358935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.367050] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.374229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.382331] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.390447] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.397603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.405742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.413864] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.421017] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.429164] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.437294] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.444406] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.452556] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.460676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.467804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.475957] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.484091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.491268] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.499390] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.507451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.514628] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.522735] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.530888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.538064] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.546204] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.554279] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.561396] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.569545] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.577680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.584835] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.592986] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.601110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.608284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.616395] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.624514] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.631680] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.639807] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.647935] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.655080] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.663248] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.671338] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.678468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.686595] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.694671] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.701806] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.709930] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.718047] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.725180] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.733327] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.741441] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.748624] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.756763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.764885] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.772057] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.780230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.788329] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.795467] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.803601] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.811716] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.818871] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.827013] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.835146] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.842308] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.850478] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.858588] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.865728] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.873871] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.881983] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.889121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.897285] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.905403] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.912536] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.920657] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.928786] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.935929] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.944059] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.952188] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.959354] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.967517] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.975646] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.982785] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.990910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39033.999025] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.006156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.014284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.022369] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.029544] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.037686] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.045827] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.052985] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.061142] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.069258] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.076414] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.084535] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.092651] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.099785] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.109351] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.116771] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.124228] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.131324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.139466] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.147597] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.154734] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.162872] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.171032] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.178120] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.186266] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.194388] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.201552] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.209682] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.217798] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.224975] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.233119] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.241234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.248352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.256515] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.264629] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.271718] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.279849] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.287966] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.295091] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.303229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.311340] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.318466] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.326599] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.334714] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.341877] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.350016] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.358154] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.365284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.373370] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.381509] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.388676] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.396811] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.404967] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.412098] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.420266] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.428338] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.435503] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.443637] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.451757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.458910] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.467034] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.475168] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.482353] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.490515] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.498647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.505289] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.512109] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.519348] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.526945] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.534567] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.541951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.550039] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.558154] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.565324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.573451] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.581612] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.588763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.596893] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.605031] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.612177] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.620341] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.628477] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.635643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.643784] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.651921] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.659102] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.667242] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.675352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.682487] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.690631] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.698756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.705908] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.714033] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.722151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.729303] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.737408] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.745480] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.752631] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.760757] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.768847] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.776009] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.784142] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.792269] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.799409] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.807533] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.815673] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.822821] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.830951] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.839069] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.846222] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.854352] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.862468] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.869621] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.877779] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.885894] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.893052] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.901178] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.909221] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.916346] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.924484] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.932607] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.939756] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.947888] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.956022] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.963151] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.971284] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.979421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.986576] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39034.994742] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.002879] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.010028] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.018110] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.026260] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.033394] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.041512] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.049647] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.056804] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.064956] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.073086] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.080234] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.088326] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.096449] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.103603] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.111763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.119897] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.127036] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.135156] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.143288] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.150422] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.158549] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.166700] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.173859] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.181987] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.190132] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.197299] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.205470] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.213586] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.220762] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.228907] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.237020] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.244174] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.252241] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.260316] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.267421] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.275554] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.283669] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.290839] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.298970] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.307100] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.314232] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.322324] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.330461] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.337615] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.345764] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.353898] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.361034] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.369159] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.377210] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.384325] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.392464] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.400585] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.407712] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.415871] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.423980] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.431159] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.450347] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.457925] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.469038] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.478542] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.489659] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.498062] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.511081] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.517287] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.524641] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.532229] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.539814] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.545995] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.553145] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.557111] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.564458] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.571979] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.578077] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.581168] xc2028 8-0061: Loading firmware for type=D2620 DTV7 (88), id 0000000000000000.
[39035.587584] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.595534] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.601636] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.612642] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.624179] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.636088] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.643717] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.651333] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.661402] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.668787] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.678118] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.684317] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.695610] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.703230] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.710818] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.719763] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.727121] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.734459] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.740643] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.748586] dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0

[39035.751709] xc2028 8-0061: Loading SCODE for type=DTV78 DTV8 DIBCOM52 SCODE HAS_IF_5200 (61000300), id 0000000000000000.
