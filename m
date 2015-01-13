Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:58157 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAMPXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 10:23:11 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so3149617lab.13
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 07:23:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
From: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Date: Tue, 13 Jan 2015 12:22:49 -0300
Message-ID: <CAEt6MX=rLS+sZA75z+G7GyiNemYuHHMn1e2KMV4AWVEvN5k5Ow@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
To: Francesco Other <francesco.other@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

You are using Siano SMS2270, am I right?

My guess you're using ISDB-T firmware to program your ic, but are you
in ISDB-T region? I use same firmware name here and works fine
(Brazil) and it seems loaded ok on your log.

I never saw an DVB firmware available to sms2270. Your tuner is
working fine under Windows with provided software ?

Cheers,
  - Roberto



On Tue, Jan 13, 2015 at 11:50 AM, Francesco Other
<francesco.other@gmail.com> wrote:
> Is there a gentleman that can help me with my problem? On linuxtv.org
> they said that someone here sure will help me.
>
> I submitted the problem here:
> http://www.spinics.net/lists/linux-media/msg85432.html
>
> Regards
>
> Francesco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
