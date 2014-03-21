Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62139 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaCURiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 13:38:02 -0400
Received: by mail-qa0-f53.google.com with SMTP id w8so2697147qac.26
        for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 10:38:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <532C75F8.2030405@googlemail.com>
References: <532C75F8.2030405@googlemail.com>
Date: Fri, 21 Mar 2014 13:38:00 -0400
Message-ID: <CAGoCfizciqjEZ0QTtvSitAUYORjDFFM1br2xF3drnVSTUwzXdg@mail.gmail.com>
Subject: Re: xc2038/3028 firmware
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

I specifically asked for and received permission from
Xceive/CrestaTech to make the xc5000 firmware freely redistributable.
They were unwilling to entertain that though for the xc2028/3028 as
they considered it a long deprecated product.

In order to include firmware blobs in linux-firmware, there needs to
be an actual license legally permitting redistribution - we don't have
that for the 2028/3028.

In general CrestaTech have been extremely cooperative with the Linux
community, especially in recent years.  However in this case they just
couldn't justify the effort to do the paperwork for a chip that they
stopped shipping years ago.

Devin

On Fri, Mar 21, 2014 at 1:25 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Hi,
>
> are there any reasons why the xc2028/3028 firmware files are not
> included in the linux-firmware tree ?
> The xc5000 firmware is already there, so it seems Xceive|has nothing
> against| redistribution of their firmware... ?!
>
> Regards,
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
