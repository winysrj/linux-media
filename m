Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61616 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0IJBho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 21:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <1284079254.4828.6.camel@maxim-laptop>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-6-git-send-email-maximlevitsky@gmail.com>
	<AANLkTi=EFZys7NnxixmQL3hqqGfin_VOV7XAWCm0BkwT@mail.gmail.com>
	<1284079254.4828.6.camel@maxim-laptop>
Date: Thu, 9 Sep 2010 21:37:43 -0400
Message-ID: <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
Subject: Re: [PATCH 5/8] IR: extend MCE keymap.
From: Jarod Wilson <jarod@wilsonet.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, Sep 9, 2010 at 8:40 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Wed, 2010-09-08 at 10:47 -0400, Jarod Wilson wrote:
>> On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> > These keys are found on remote bundled with
>> > Toshiba Qosmio F50-10q.
>> >
>> > Found and tested by, Sami R <maesesami@gmail.com>
>> >
>> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>> > ---
>> >  drivers/media/IR/keymaps/rc-rc6-mce.c |    3 +++
>> >  1 files changed, 3 insertions(+), 0 deletions(-)
>
> Tommorow I will resend that patch with even more scancodes.

Saw the discussion on irc. Feel your pain big-time on the X server
limitation on keycodes. Its put a big damper on efforts to add native
support to mythtv. Peter Hutterer's libXi2 cookbook tutorials talk a
good game about how libXi2 supports 32-bit keycodes, but neglects to
mention that the X server still gobbles up anything above 248 or 255
or whatever it is, and remedying that is no small task. :(

I think for mythtv, we're going to end up having a daemon process with
elevated privs that reads directly from input devices to get around
this annoyance, until such time as the annoyance is gone.

-- 
Jarod Wilson
jarod@wilsonet.com
