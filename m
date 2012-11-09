Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65524 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2KIRAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 12:00:54 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so1743357bkc.19
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2012 09:00:53 -0800 (PST)
Message-ID: <509D28B6.5060503@googlemail.com>
Date: Fri, 09 Nov 2012 18:00:54 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com> <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com> <CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com> <509BFBF5.7050209@googlemail.com> <CAGoCfiy5wZUajtDiF53gaDED5MCUrsdabQicbrq+RG3dGU0D_A@mail.gmail.com>
In-Reply-To: <CAGoCfiy5wZUajtDiF53gaDED5MCUrsdabQicbrq+RG3dGU0D_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.11.2012 21:46, schrieb Devin Heitmueller:
> On Thu, Nov 8, 2012 at 1:37 PM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> at least the "Silvercrest Webcam 1.3mpix" (board 71) exposes both
>> endpoint types (0x82=isoc and 0x84=bulk).
> Ah, interesting.  It might be worthwhile to log a warning in dmesg if
> the user sets the modprobe option but the board doesn't actually
> expose any bulk endpoints.  This might help avoid questions from users
> (we already got one such question by somebody who believed enabling
> this would put the device into bulk mode even though his hardware
> didn't support it).
>
> Devin
>

Well, I deliberately called the module 'prefer_bulk' (and not
'use_bulk', 'force_bulk' ...) which should imply that nothing is guaranteed.
And selecting bulk transfers for a device which actually doesn not
provide bulk support doesn't make sense and is clearly the users fault.
Anway, I'm fine with adding a warning message and maybe I could extend
the module parameter description, too.

I'm going to wait for further feedback from Mauro before sending an
updated version of the patch (series).

Regards,
Frank
