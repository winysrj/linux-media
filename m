Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp115.rog.mail.re2.yahoo.com ([68.142.225.231]:34155 "HELO
	smtp115.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752343AbZBWEch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 23:32:37 -0500
Message-ID: <49A226E4.3050009@rogers.com>
Date: Sun, 22 Feb 2009 23:32:36 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: sebastian.blanes@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add "Sony PlayTV" to dibcom driver
References: <9160c0600902190120w705b3d55jf4aa1af3418e5c62@mail.gmail.com>	<49A1AFBD.7030208@rogers.com> <20090222233839.566f2870@pedra.chehab.org>
In-Reply-To: <20090222233839.566f2870@pedra.chehab.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> On Sun, 22 Feb 2009 15:04:13 -0500 CityK <cityk@rogers.com> wrote:
>> I don't think the Patchwork tool picked it up, as I don't see it in the
>> queue :(
>> http://patchwork.kernel.org/project/linux-media/list/
>>
>> I'm wondering it the quotations in the subject line are enough to throw
>> the script off.  Mauro, any ideas?
>>     
>
> In general those tools to pick and work with scripts don't like very much
> inlined patches, although it generally works.
>
> Also, it requires that the patch is not line wrapped.
>
> In this specific case, the patch is line-wrapped:
>
> --- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
> 13:49:37.000000000 +0100
> +++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
> 23:45:43.000000000 +0100
>
> instead of:
>
> --- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18 13:49:37.000000000 +0100
> +++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18 23:45:43.000000000 +0100
>
>
> So, it doesn't apply as a patch and patchwork discards it.

Ahh, thanks for the explanation. Its strange that they are not tailored
for inline patches, given that that is precisely the preferred and
prescribed submission method!
