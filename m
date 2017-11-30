Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:35258 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbdK3NYs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 08:24:48 -0500
Received: by mail-yw0-f174.google.com with SMTP id m81so2675182ywd.2
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 05:24:48 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?zpHOuM6xzr3OrM+DzrnOv8+CIM6fzrnOus6/zr3PjM68zr/PhQ==?=
        <athoik@gmail.com>
Date: Thu, 30 Nov 2017 15:24:47 +0200
Message-ID: <CANDbA3f1FaMrgBLHgcdrABsxYxa3oU+ofOcRtU87sheV=skwzw@mail.gmail.com>
Subject: DVB-S2X - S2 Extensions Support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I am not aware if there was a discussion regarding S2X before, so I
would like to hear what are your plans regarding S2X.

There are already several manufacturers with S2X capable receivers and
soon more will follow.

The S2 extensions will bring more code rates and modulations, so I
guess adding those to fe_code_rate and fe_modulation is mandatory.

Something like the following with proper documentation of course.

@@ -313,6 +313,24 @@ enum fe_code_rate {
        FEC_3_5,
        FEC_9_10,
        FEC_2_5,
+       FEC_13_45,
+       FEC_9_20,
+       FEC_11_20,
+       FEC_23_36,
+       FEC_25_36,
+       FEC_13_18,
+       FEC_26_45,
+       FEC_28_45,
+       FEC_7_9,
+       FEC_77_90,
+       FEC_32_45,
+       FEC_11_15,
+       FEC_1_2_L,
+       FEC_8_15_L,
+       FEC_3_5_L,
+       FEC_2_3_L,
+       FEC_5_9_L,
+       FEC_26_45_L
 };

@@ -350,6 +368,10 @@ enum fe_modulation {
        APSK_32,
        DQPSK,
        QAM_4_NR,
+       APSK_8,
+       APSK_64,
+       APSK_128,
+       ASPK_256
 };

Adding new values, means that we should bump the DVB API as well to
5.12 in order usespace applications to be aware of the changes.

That is let's say the easy part, the hard part is how are we going to
query frontend capabilities?

Are we going to introduce a new delsys (SYS_DVBS2X)? Or are we going
to introduce Supports "3nd generation" modulation"
(FE_CAN_3G_MODULATION) ?

Or since the new APSK modulations are optional, we need to add
FE_CAN_APSK_8/64/128/256 to capabilities.

Thanks for your suggestions.

Best Regards,
Athanasios

PS. Here you can read about S2X:
https://www.dvb.org/standards/dvb-s2x
http://www.dvb.org/resources/public/standards/a83-2_dvb-s2x_den302307-2.pdf
