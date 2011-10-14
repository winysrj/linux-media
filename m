Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43540 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab1JNRBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 13:01:21 -0400
Received: by qadb15 with SMTP id b15so1025823qad.19
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 10:01:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9838CF.6030702@redhat.com>
References: <CABb1zhvkLYTZ4zUy7jPh1AH+1XGQRdhsHM7CxK5ADMuuzKHAzg@mail.gmail.com>
	<CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
	<4E9838CF.6030702@redhat.com>
Date: Fri, 14 Oct 2011 19:01:19 +0200
Message-ID: <CABb1zhsxHyYb1nXvVTZUzMwOdLzvKpGSGG36VmbOzB1XqGK9zw@mail.gmail.com>
Subject: Re: Support for Sveon STV22 (IT9137)
From: =?ISO-8859-1?Q?Leandro_Terr=E9s?= <imlordlt@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/10/14 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 09-10-2011 02:09, Leandro Terrés escreveu:
>> This device identifies has IdProduct 0xe411 and is a clone of KWorld
>> UB499-2T T09(IT9137).
>>
>> This patch simply adds support for this device.
>
> Patch applies ok, with just one small whitespace issue. However, you
> forgot to add your signed-off-by: on it. Also, it helps if you copy the
> driver's maintainer (Malcolm).
>
> Patchwork: http://patchwork.linuxtv.org/patch/8099/
>
> WARNING: please, no space before tabs
> #24: FILE: drivers/media/dvb/dvb-usb/dvb-usb-ids.h:323:
> +#define USB_PID_SVEON_STV22_IT9137     ^I^I0xe411$
>
> ERROR: Missing Signed-off-by: line(s)
>
> total: 1 errors, 1 warnings, 29 lines checked
>

This is my first contribution and I don't know who to do that.

Sorry.
