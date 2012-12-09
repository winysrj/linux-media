Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57808 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab2LIPqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2012 10:46:18 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so837154qad.19
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2012 07:46:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50C4A520.6020908@pyther.net>
References: <50B5779A.9090807@pyther.net>
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
	<50C12302.80603@pyther.net>
	<50C34628.5030407@googlemail.com>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
Date: Sun, 9 Dec 2012 10:46:17 -0500
Message-ID: <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Matthew Gyurgyik <matthew@pyther.net>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 9, 2012 at 9:50 AM, Matthew Gyurgyik <matthew@pyther.net> wrote:
> Just to make sure I'm not misunderstanding, the messages should get logged
> to dmesg, correct?

I wrote the original IR support for the em2874, but it seems to have
changed a bit since I submitted it.  One thing that jumps out at me is
if you specify a remote control of the wrong *type* (e.g. the driver
is configured for RC5 but the actual remote is configured for NEC),
then you're likely to get no events from the device.

You may wish to lookup what type of remote RC_MAP_KWORLD_315U is, and
try a remote that is of the other protocol type (e.g. if
RC_MAP_KWORLD_315U is RC5 then try a remote which is NEC).  Then see
if you get events.  If so, then you know you have the correct RC
protocol and just need to adjust the RC profile specified.

Also, it's possible the remote control is an RC6 remote, which I never
got around to adding em2874 driver support for.  Take a look at the
windows trace and see what register R50 is being set to.  In
particular, bits [3-2] will tell you what RC protocol the Windows
driver expects the remote to be.  I'm pretty sure I put the definition
for the relevant bits in em28xx-reg.h.

Devin

--
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
