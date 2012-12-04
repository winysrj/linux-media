Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59473 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LDC3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 21:29:02 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so1878191qcr.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 18:29:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BD5CC3.1030100@pyther.net>
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
Date: Mon, 3 Dec 2012 21:29:00 -0500
Message-ID: <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matthew Gyurgyik <matthew@pyther.net>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2012 at 9:15 PM, Matthew Gyurgyik <matthew@pyther.net> wrote:
> Although, it looked like tuning was semi-successful, I tried the following
>
>   * cat /dev/dvb/adapter0/dvr0 (no output)
>   * mplayer /dev/dvb/adapter0/dvr0 (no output)
>   * cat /dev/dvb/adapter0/dvr0 > test.mpg (test.mpg was 0 bytes)

I would try running "lsusb -v" and send the output.  Make sure that
it's not expecting to use bulk mode for DVB (which would require
driver changes to support).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
