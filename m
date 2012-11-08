Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55384 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500Ab2KHTho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:37:44 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1769183eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:37:43 -0800 (PST)
Message-ID: <509BFBF5.7050209@googlemail.com>
Date: Thu, 08 Nov 2012 20:37:41 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com> <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com> <CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com>
In-Reply-To: <CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.11.2012 21:19, schrieb Devin Heitmueller:
> On Thu, Nov 8, 2012 at 1:11 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> By default, isoc transfers are used if possible.
>> With the new module parameter, bulk can be selected as the
>> preferred USB transfer type.
> Hi Frank,
>
> Does your device actually expose both isoc and bulk endpoints?  If I
> recall from the datasheet, whether isoc or bulk mode is provided is
> not actually configurable from the driver.  The EEPROM dictates how
> the endpoint map gets defined, and hence it's either one or the other.
>  If that is indeed the case, then we don't need a modprobe option at
> all (since would never actually be user configurable), and we should
> just add a field to the board definition to indicate that bulk should
> be used for that product.
>
> Devin
>

Hi Devin,

at least the "Silvercrest Webcam 1.3mpix" (board 71) exposes both
endpoint types (0x82=isoc and 0x84=bulk).

Regards,
Frank
