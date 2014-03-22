Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48928 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCVMWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 08:22:03 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so2711490eek.8
        for <linux-media@vger.kernel.org>; Sat, 22 Mar 2014 05:22:02 -0700 (PDT)
Message-ID: <532D809D.4060605@googlemail.com>
Date: Sat, 22 Mar 2014 13:22:53 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: dheitmueller@kernellabs.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: xc2038/3028 firmware
References: <532C75F8.2030405@googlemail.com> <CAGoCfizciqjEZ0QTtvSitAUYORjDFFM1br2xF3drnVSTUwzXdg@mail.gmail.com>
In-Reply-To: <CAGoCfizciqjEZ0QTtvSitAUYORjDFFM1br2xF3drnVSTUwzXdg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Am 21.03.2014 18:38, schrieb Devin Heitmueller:
> Hi Frank,
>
> I specifically asked for and received permission from
> Xceive/CrestaTech to make the xc5000 firmware freely redistributable.
> They were unwilling to entertain that though for the xc2028/3028 as
> they considered it a long deprecated product.
>
> In order to include firmware blobs in linux-firmware, there needs to
> be an actual license legally permitting redistribution - we don't have
> that for the 2028/3028.
>
> In general CrestaTech have been extremely cooperative with the Linux
> community, especially in recent years.  However in this case they just
> couldn't justify the effort to do the paperwork for a chip that they
> stopped shipping years ago.
>
> Devin
Ok, so you've already asked them for a xc2028/3028 firmware
redistribution permission, but (in opposition to the xc5000) they didn't
grant it ?
Too bad. :-(
The xc2028/3028 is used in so many devices and playing manual firmware
extraction games sucks.
A too big obstacle for many users (if they even find out that their
device isn't working due to missing firmware)...

Regards,
Frank

> On Fri, Mar 21, 2014 at 1:25 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> Hi,
>>
>> are there any reasons why the xc2028/3028 firmware files are not
>> included in the linux-firmware tree ?
>> The xc5000 firmware is already there, so it seems Xceive|has nothing
>> against| redistribution of their firmware... ?!
>>
>> Regards,
>> Frank
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

