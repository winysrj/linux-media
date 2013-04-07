Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:34410 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254Ab3DGKfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Apr 2013 06:35:55 -0400
Received: by mail-vb0-f54.google.com with SMTP id w16so3137433vbf.27
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 03:35:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1385456.JiqmfYkIEH@avalon>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com>
	<1691028.0qtxercLZ8@avalon>
	<CAHG8p1CpeF3BGyVB1pT+brOB+1o1MmuEZuAk+mvDhY_wPYynLA@mail.gmail.com>
	<1385456.JiqmfYkIEH@avalon>
Date: Sun, 7 Apr 2013 18:35:54 +0800
Message-ID: <CAHG8p1DdY=j1VJH0XdkK8TgYD8sSXvG7u2coX_BwrFB-uUzL5A@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

>> >> >> +struct mt9m114_reg {
>> >> >> +     u16 reg;
>> >> >> +     u32 val;
>> >> >> +     int width;
>> >> >> +};
>> >> >> +
>> >> >> +enum {
>> >> >> +     MT9M114_QVGA,
>> >> >> +     MT9M114_VGA,
>> >> >> +     MT9M114_WVGA,
>> >> >> +     MT9M114_720P,
>> >> >> +};
>> >> >
>> >> > This is the part I don't like. Instead of hardcoding 4 different
>> >> > resolutions and using large register address/value tables, you should
>> >> > compute the register values from the image size requested by the user.
>> >>
>> >> In fact we get this table with the Aptina development tool. So we only
>> >> support fixed resolutions. If we compute each register value, it only
>> >> makes the code more complex.
>> >
>> > But it also makes the code more useful, as the user won't be limited to
>> > the 4 resolutions above.
>>
>> The problem is Aptina datasheet doesn't tell us how to calculate these
>> values. We only have some register presets.
>
> Have you tried requesting the information from Aptina ?

No, there is only a datasheet on its website. I refer to register
definition from Andrew Chew on  this website :
http://git.chromium.org/gitweb/?p=chromiumos/third_party/kernel-next.git;a=blob;f=drivers/media/video/mt9m114.c;h=a5d2724005e7863607ffe204eefabfb0fad4da46.
Even if we have any NDA docs, we can't use it in open source code.
