Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:33276 "EHLO
	mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbcCHVtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 16:49:35 -0500
Received: by mail-yw0-f169.google.com with SMTP id d65so23888498ywb.0
        for <linux-media@vger.kernel.org>; Tue, 08 Mar 2016 13:49:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL0vL9yc=d_2LSUui=vWD2tttB0-oFathrEG8P35EoKtJEkSMQ@mail.gmail.com>
References: <CAL0vL9yc=d_2LSUui=vWD2tttB0-oFathrEG8P35EoKtJEkSMQ@mail.gmail.com>
Date: Tue, 8 Mar 2016 16:49:33 -0500
Message-ID: <CAGoCfizteSfFOSYJQWRBeBzr2ZJ3H_VaF2Akvv3mqEX3gVPVYw@mail.gmail.com>
Subject: Re: HVR-850 2040:b140 fails to initialize
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Scott Robinson <scott.robinson55@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	User discussion about IVTV <ivtv-users@ivtvdriver.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Appreciate some advice.

Return it and get an HVR-950q.  This has been a known issue for more
than 5 years and nobody's gotten around to fixing it (largely because
of limitations inside the V4L2 framework).

Devin
(a.k.a. the guy who added the original support for the HVR-850).

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
