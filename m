Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:61891 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2LDC6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 21:58:40 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so454752qaq.19
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2012 18:58:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BD6310.8000808@pyther.net>
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
Date: Mon, 3 Dec 2012 21:58:39 -0500
Message-ID: <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matthew Gyurgyik <matthew@pyther.net>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2012 at 9:42 PM, Matthew Gyurgyik <matthew@pyther.net> wrote:
>> I would try running "lsusb -v" and send the output.  Make sure that
>> it's not expecting to use bulk mode for DVB (which would require
>> driver changes to support).
>>
>> Devin
>>
> Here is the output of lsusb -v
> http://pyther.net/a/digivox_atsc/patch2/lsusb.txt

Hmmm, it's isoc, so that should be ok.  Maybe the 3305 TS
configuration is mismatched (serial vs. parallel).  I don't recall off
the top of my head, but I think em2875 is pretty much always in serial
mode, so check the lgdt3305 config block passed in the dvb_attach()
call and see if it's the same.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
