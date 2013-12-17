Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:34830 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3LQFjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 00:39:31 -0500
Received: by mail-we0-f177.google.com with SMTP id u56so5629788wes.36
        for <linux-media@vger.kernel.org>; Mon, 16 Dec 2013 21:39:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52AFE107.4040705@gmail.com>
References: <1386969579.3914.13.camel@piranha.localdomain>
	<20131214092443.622b069d@samsung.com>
	<52ACE809.1000406@gmail.com>
	<CAGoCfiwxGU-j14oGDfvoYTA5WZUkQdM_3=80gfpWUjXVNN_nng@mail.gmail.com>
	<52AFE107.4040705@gmail.com>
Date: Tue, 17 Dec 2013 00:39:29 -0500
Message-ID: <CAGoCfiztzv-QFjmKXdiJreTPCYN1RTe5bPTO0awx5a-ER161qQ@mail.gmail.com>
Subject: Re: stable regression: tda18271_read_regs: [1-0060|M] ERROR:
 i2c_transfer returned: -19
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Connor Behan <connor.behan@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Frederik Himpe <fhimpe@telenet.be>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Connor,

On Tue, Dec 17, 2013 at 12:28 AM, Connor Behan <connor.behan@gmail.com> wrote:
> Thanks for the detailed answer. I have tried your patch and updated the
> wiki page. Would a 950 or 950Q be safer to buy next time?

The 950 has long since been obsoleted.  You cannot buy them anymore.
The 950q though is well supported and doesn't have this issue as it
uses a different chip.

> On 14/12/13 05:17 PM, Devin Heitmueller wrote:
>> I had a patch kicking around which fixed part of the issue, but it
>> didn't completely work because of the lgdt3305 having AGC enabled at
>> chip powerup (which interferes with analog tuning on the shared
>> tuner), and the internal v4l-dvb APIs don't provide any easy way to
>> reset the AGC from the analog side of the device.
>
> By this do you mean that the functions exist but they aren't part of the
> public API? Maybe this problem can be addressed if there is ever "v4l3"
> or some other reason to break compatibility.

No, these are internal APIs that dictate how the various driver
components talk to each other.  Because the V4L and DVB subsystems
were developed independently of each other, they do a really crappy
job of communicating between them (a problem which manifests itself in
particular when sharing hardware resources such as tuners).

The problem *can* be fixed, but it would likely require
extensions/changes to the basic frameworks used to communicate between
the different drivers.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
