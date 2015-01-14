Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:32991 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbbANP7G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 10:59:06 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so8871254lab.6
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2015 07:59:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdQK+wM1YHfzWfvzQ9ZgWgQb4WEY+6AW=cSb_YOwAKKr4Q@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
 <CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com>
 <CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
 <CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com> <CAPx3zdQK+wM1YHfzWfvzQ9ZgWgQb4WEY+6AW=cSb_YOwAKKr4Q@mail.gmail.com>
From: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Date: Wed, 14 Jan 2015 12:58:43 -0300
Message-ID: <CAEt6MXkDPcZ47gnH9FFmYGkw1-ZFt8JAN1qKsBGBKXLTdQauzw@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
To: Francesco Other <francesco.other@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Francesco,

Seems very strange not work once you have lock (1f) and ber 0. not a
real problem signal report.

After tzap -r open another console and:

dd if=/dev/dvb/adapter0/dvr0 of=test.ts

Wait 10 seconds and stop it. Please check file size (try to open on
vlc too if big enough...).

Cheers,
 - Roberto

On Tue, Jan 13, 2015 at 6:56 PM, Francesco Other
<francesco.other@gmail.com> wrote:
>
>
> So, this is the output for tzap with the NOT-working-device:
>
> $ tzap -r -c ~/.tzap/channels.conf Italia1
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/ionic/.tzap/channels.conf'
> Version: 5.10   FE_CAN { DVB-T }
> tuning to 698000000 Hz
> video pid 0x0654, audio pid 0x0655
> status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 010e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK




 - Roberto
