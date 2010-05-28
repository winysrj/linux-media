Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:49149 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0E1Erz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 00:47:55 -0400
Received: by qyk13 with SMTP id 13so1232734qyk.1
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 21:47:55 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 May 2010 00:47:52 -0400
Message-ID: <AANLkTinpzNYueEczjxdjAo3IgToM42NwkHhm97oz2Koj@mail.gmail.com>
Subject: ir-core multi-protocol decode and mceusb
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So I'm inching closer to a viable mceusb driver submission -- both a
first-gen and a third-gen transceiver are now working perfectly with
multiple different mce remotes. However, that's only when I make sure
the mceusb driver is loaded w/only the rc6 decoder loaded. When
ir-core comes up, it requests all decoders to load, starting with the
nec decoder, followed by the rc5 decoder, then the rc6 decoder and so
on (init_decoders() in ir-raw-event.c). When I call
ir_raw_event_handle, all decoders get run on the ir data buffer,
starting with nec. Well, the nec decoder doesn't like the rc6 data, so
it pukes. The RUN_DECODER macro break's out of the routine when that
happens, and the rc6 decoder never gets a chance to run. (Similarly,
if only ir-nec-decoder has been removed, the rc5 decoder pukes on the
rc6 data, same problem). If I'm thinking clearly, rather than breaking
out of the loop in RUN_DECODER, we really ought to be issuing a
continue to go on to the next decoder, and possibly be accumulating
failures, though I don't know that _sumrc actually matters other than
"greater than zero" (i.e., at least one decoder was successfully able
to decode the signal). If I'm not thinking clearly, a pointer to what
I'm missing would be appreciated. :)

The next fun thing I'm starting to look at is this MCE IR
keyboard/mouse combo device I've got here[1]... It uses a Philips RC
variant (I suspect RC-MM at first glance[2]) for the mouse
functionality and most of the keyboard keys (except many of the
multimedia keys, which are RC6 like their matching counterparts on the
MCE remotes). There's a hack atop an old version of lirc_mceusb out
there that supports this thing[3], which actually has some pretty
decent looking documentation on its site (though the code itself is...
well, its hacked in atop an old lirc driver...).

Support for the keyboard can wait though. I think the issue
w/RUN_DECODER is really all that still needs to be resolved for an
initial submission.

[1] http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8
[2] http://www.sbprojects.com/knowledge/ir/rcmm.htm
[3] http://mod-mce.sourceforge.net/

-- 
Jarod Wilson
jarod@wilsonet.com
