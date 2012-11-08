Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58817 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab2KHTqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:46:03 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so2409253lag.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:46:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <509BFBF5.7050209@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
	<1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
	<CAGoCfiwHviRd8-tsmwxf8=eLbiapUwnrvCM2qB2M5skiqXMNVw@mail.gmail.com>
	<509BFBF5.7050209@googlemail.com>
Date: Thu, 8 Nov 2012 14:46:02 -0500
Message-ID: <CAGoCfiy5wZUajtDiF53gaDED5MCUrsdabQicbrq+RG3dGU0D_A@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] em28xx: add module parameter for selection of
 the preferred USB transfer type
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 8, 2012 at 1:37 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> at least the "Silvercrest Webcam 1.3mpix" (board 71) exposes both
> endpoint types (0x82=isoc and 0x84=bulk).

Ah, interesting.  It might be worthwhile to log a warning in dmesg if
the user sets the modprobe option but the board doesn't actually
expose any bulk endpoints.  This might help avoid questions from users
(we already got one such question by somebody who believed enabling
this would put the device into bulk mode even though his hardware
didn't support it).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
