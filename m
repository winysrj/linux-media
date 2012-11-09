Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35031 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab2KIRI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 12:08:58 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so3195527lbo.19
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2012 09:08:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509D28B6.5060503@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
	<1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
	<CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com>
	<509BFBF5.7050209@googlemail.com>
	<CAGoCfiy5wZUajtDiF53gaDED5MCUrsdabQicbrq+RG3dGU0D_A@mail.gmail.com>
	<509D28B6.5060503@googlemail.com>
Date: Fri, 9 Nov 2012 12:08:57 -0500
Message-ID: <CAGoCfizc==b7khc-979Y6ymnH5FmENQa38-103UN_yDfO70VeQ@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 9, 2012 at 11:00 AM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Well, I deliberately called the module 'prefer_bulk' (and not
> 'use_bulk', 'force_bulk' ...) which should imply that nothing is guaranteed.
> And selecting bulk transfers for a device which actually doesn not
> provide bulk support doesn't make sense and is clearly the users fault.
> Anway, I'm fine with adding a warning message and maybe I could extend
> the module parameter description, too.
>
> I'm going to wait for further feedback from Mauro before sending an
> updated version of the patch (series).

Yeah, none of this should hold up it being merged as-is.  A patch
adding the warning can be submitted after the fact.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
