Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45868 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2E2IPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 04:15:10 -0400
Received: by yhmm54 with SMTP id m54so2045955yhm.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 01:15:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CCB94AA4F@MEP-EXCH.meprolight.com>
References: <B9D34818-CE30-4125-997B-71C50CFC4F0D@yahoo.com>
	<4875438356E7CA4A8F2145FCD3E61C0B2CCB94AA4F@MEP-EXCH.meprolight.com>
Date: Tue, 29 May 2012 10:15:09 +0200
Message-ID: <CAGGh5h13ks+yN44OJvFogjj9jWr9HeN7_OzE2Aob9T2n3e9nMA@mail.gmail.com>
Subject: Re: FW: OMAP 3 ISP
From: jean-philippe francois <jp.francois@cynove.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Ritesh <yuva_dashing@yahoo.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/5/29 Alex Gershgorin <alexg@meprolight.com>:
>
> Hi Ritesh,
>
> Please send in the future CC to laurent.pinchart@ideasonboard.com and linux-media@vger.kernel.org
>
>> Hi Alex,
>> I also started working with OMAP35x torpedo kit, I successful compile Linux 3.0 and ported on the board.
>> Device is booting correctly but probe function in omap3isp module not getting called.
>> Please help me
>
> You have relevant Kernel boot messages?
> You can also find information in media archives OMAP 3 ISP thread.
>
> Regards,
> Alex
>

Hi, I had a similar problem with a 2.6.39 kernel, that was solved with
a 3.2 kernel.
When compiled as a module, the probe function was called, but was failing later.

The single message I would see was "ISP revision x.y found" [1]

When compiled in the kernel image, everything was fine.


[1] http://lxr.linux.no/linux+v2.6.39.4/drivers/media/video/omap3isp/isp.c#L2103

Jean-Philippe François

>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
