Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56199 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2LFWDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 17:03:13 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so1324459qaq.19
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 14:03:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C115BB.1020005@googlemail.com>
References: <50B5779A.9090807@pyther.net>
	<50B67851.2010808@googlemail.com>
	<50B69037.3080205@pyther.net>
	<50B6967C.9070801@iki.fi>
	<50B6C2DF.4020509@pyther.net>
	<50B6C530.4010701@iki.fi>
	<50B7B768.5070008@googlemail.com>
	<50B80FBB.5030208@pyther.net>
	<50BB3F2C.5080107@googlemail.com>
	<50BB6451.7080601@iki.fi>
	<50BB8D72.8050803@googlemail.com>
	<50BCEC60.4040206@googlemail.com>
	<50BD5CC3.1030100@pyther.net>
	<CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
	<50BD6310.8000808@pyther.net>
	<CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com>
	<50BE65F0.8020303@googlemail.com>
	<50BEC253.4080006@pyther.net>
	<50BF3F9A.3020803@iki.fi>
	<50BFBE39.90901@pyther.net>
	<50BFC445.6020305@iki.fi>
	<50BFCBBB.5090407@pyther.net>
	<50BFECEA.9060808@iki.fi>
	<50BFFFF6.1000204@pyther.net>
	<50C11301.10205@googlemail.com>
	<CAGoCfiwi3HVBjBh7TzWmwSbVH4S-0174=mqKA64Jw2zYz6K6LA@mail.gmail.com>
	<50C115BB.1020005@googlemail.com>
Date: Thu, 6 Dec 2012 17:03:12 -0500
Message-ID: <CAGoCfiwKGxFt33bf7C0h8akhVJy2ED-R1vGgpe+nJpHYoAVKWg@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 6, 2012 at 5:01 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> That's possible, because Matthews log doesn't show any access to this
> register.
> If it is not used, the question is if writing 0x07 to this register can
> cause any trouble...

Historically speaking, on that family of devices registers that are no
longer used get treated as scratch registers (meaning writing to them
has no adverse effect).

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
