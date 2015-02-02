Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:48694 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbbBBNSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 08:18:49 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so40530729lab.6
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2015 05:18:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
References: <CAPx3zdRNiaSKbG9PtVbnA_fXm-ietqOiciq9H0N5dHQFKibZ_w@mail.gmail.com>
From: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Date: Mon, 2 Feb 2015 10:18:27 -0300
Message-ID: <CAEt6MX=4t5EPjAQ=Jy0Zs+wuKRsiH_6zuRQZNnanAmZ66Gk1Gg@mail.gmail.com>
Subject: Re: [BUG] - Why anyone fix this problem?
To: Francesco Other <francesco.other@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Francesco has reported problem with DVB-T on Siano sms2270. Basically
him reach a lock with tzap but seems not have stream data.

I tried to help him to debug but I can't reproduce their problem once
I have isdb-t only here. He is using some dvb firmware with device
that seems works fine on Windows.

Cheers,
 - Roberto


 - Roberto


On Mon, Feb 2, 2015 at 10:10 AM, Francesco Other
<francesco.other@gmail.com> wrote:
> Is it possible that the problem I explained here isn't interesting for anyone?
>
> The device is supported by kernel but obviously there is a bug with DVB-T.
>
> I have the working firmware (on Windows) for DVB-T if you need it.
>
> http://www.spinics.net/lists/linux-media/msg85505.html
>
> http://www.spinics.net/lists/linux-media/msg85478.html
>
> http://www.spinics.net/lists/linux-media/msg85432.html
>
> Regards
>
> Francesco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
