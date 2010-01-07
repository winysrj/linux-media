Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57333 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0AGUA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2010 15:00:27 -0500
Received: by fxm25 with SMTP id 25so12043609fxm.21
        for <linux-media@vger.kernel.org>; Thu, 07 Jan 2010 12:00:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B463AC6.2000901@mailbox.hu>
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu>
	 <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu>
	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>
Date: Thu, 7 Jan 2010 15:00:25 -0500
Message-ID: <829197381001071200n2100df65h84028042ffd4dd11@mail.gmail.com>
Subject: Re: DTV2000 H Plus issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 7, 2010 at 2:49 PM, istvan_v@mailbox.hu <istvan_v@mailbox.hu> wrote:
> On 01/05/2010 02:25 AM, Raena Lea-Shannon wrote:
>
>> Thanks. Will try again later.
>
> By the way, for those who would like to test it, here is a patch based
> on Devin Heitmueller's XC4000 driver and Mirek Slugen's older patch,
> that adds support for this card:
>  http://www.sharemation.com/IstvanV/v4l/dtv2000h+.patch
> It can be applied to this version of the v4l-dvb code:
>  http://linuxtv.org/hg/v4l-dvb/archive/75c97b2d1a2a.tar.bz2
> This is experimental code, so use it at your own risk. The analogue
> parts (TV and FM radio) basically work, although there are some minor
> issues to be fixed. Digital TV is not tested yet, but is theoretically
> implemented; reports on whether it actually works are welcome.
> The XC4000 driver also requires a firmware file:
>  http://www.sharemation.com/IstvanV/v4l/dvb-fe-xc4000-1.4.1.fw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Istan_v,

Could you please do me a favor and rename your firmware file, both in
the patch and the file you are redistributing (perhaps as
dvb-fe-xc4000-1.4.1-istanv.fw)?  I worry that by redistributing a file
with the exact same name as the "official" release, people are going
to get confused and it will make it harder for me to debug problems
given my assumptions about what firmware image they are using is
incorrect.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
