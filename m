Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1JPMkH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 08:40:07 -0400
Received: by bkbzt19 with SMTP id zt19so2346567bkb.19
        for <linux-media@vger.kernel.org>; Sun, 16 Oct 2011 05:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111016122359.GA19023@jak-linux.org>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E9992F9.7000101@poczta.onet.pl>
	<4E99F313.4050103@poczta.onet.pl>
	<20111016122359.GA19023@jak-linux.org>
Date: Sun, 16 Oct 2011 08:40:06 -0400
Message-ID: <CAGoCfixB553TtwrHFu4pmqk05zeJV6w0-2a1=sfy48Zg_t-65Q@mail.gmail.com>
Subject: Re: [PATCH 4/7] staging/as102: cleanup - formatting code
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	devel@driverdev.osuosl.org, Patrick Dickey <pdickeybeta@gmail.com>,
	Greg KH <gregkh@suse.de>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 16, 2011 at 8:23 AM, Julian Andres Klode <jak@jak-linux.org> wrote:
> On Sat, Oct 15, 2011 at 10:54:43PM +0200, Piotr Chmura wrote:
>> staging as102: cleanup - formatting code
>>
>> Cleanup code: change double spaces into single, put tabs instead of spaces where they should be.
>>
>> Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
>> Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
>> Cc: Greg HK<gregkh@suse.de>
>
> Just a few hints from my side. Most of my comments apply to multiple other parts
> of the code, but I did not want to quote everything and you should be able to
> find the other parts I did not mention explicitely as well.
>
> I don't have much knowledge of kernel code style, but wanted to point out a few
> things that seem to be obviously wrong or uncommon, and stuff I wouldn't do. There
> may be a few false positives and some things missing.
>
> [And yes, I actually only wanted to comment on the two-space thing, but I somehow
> ended up reading the complete patch or the first half of it].

I think that rather than having Piotr rework the whitespace fifty
times until everybody is satisfied, let's get a functional patch
series into the staging tree and then people can submit whitespace
cleanup patches to their hearts content.

That said, Piotr, I would not spend effort reworking the existing
patch per Julian's request.  Fix the issues related to the history
that I mentioned in my previous email (which would be required to get
it into staging), and then the people who have nothing better to do
than obsess about whitespace can submit incremental patches on top of
yours which address their concerns.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
