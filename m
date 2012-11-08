Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:56091 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2KHTTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:19:08 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so2388140lag.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:19:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
	<1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
Date: Thu, 8 Nov 2012 14:19:05 -0500
Message-ID: <CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 8, 2012 at 1:11 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> By default, isoc transfers are used if possible.
> With the new module parameter, bulk can be selected as the
> preferred USB transfer type.

Hi Frank,

Does your device actually expose both isoc and bulk endpoints?  If I
recall from the datasheet, whether isoc or bulk mode is provided is
not actually configurable from the driver.  The EEPROM dictates how
the endpoint map gets defined, and hence it's either one or the other.
 If that is indeed the case, then we don't need a modprobe option at
all (since would never actually be user configurable), and we should
just add a field to the board definition to indicate that bulk should
be used for that product.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
