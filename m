Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38198 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaFUB6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 21:58:20 -0400
Received: by mail-qa0-f42.google.com with SMTP id dc16so3891452qab.29
        for <linux-media@vger.kernel.org>; Fri, 20 Jun 2014 18:58:19 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Jun 2014 21:58:19 -0400
Message-ID: <CAGoCfiyeHbYYTSYY_VPEXJ4z8668w6LdjprW1+FbMJCOoCekwA@mail.gmail.com>
Subject: Best way to add subdev that doesn't use I2C or SPI?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm in the process of adding support for a new video decoder.  However
in this case it's an IP block on a USB bridge as opposed to the
typical case which is an I2C device.  Changing registers for the
subdev is the same mechanism as changing registers in the rest of the
bridge (a specific region of registers is allocated for the video
decoder).

Doing a subdev driver seems like the logical approach to keep the
video decoder related routines separate from the rest of the bridge.
It also allows the reuse of the code if we find other cases where the
IP block is present in other devices.  However I'm not really sure
what the mechanics are for creating a subdev that isn't really an I2C
device.

I think we've had similar cases with the Conexant parts where the Mako
was actually a block on the main bridge (i.e. cx23885/7/8, cx231xx).
But in that case the cx25840 subdev just issues I2C commands and
leverages the fact that you can talk to the parts over I2C even though
they're really on-chip.

Are there any other cases today where we have a subdev that uses
traditional register access routines provided by the bridge driver to
read/write the video decoder registers?  In this case I would want to
reuse the register read/write routines provided by the bridge, which
ultimately are send as USB control messages.

Any suggestions welcome (and in particular if you can point me to an
example case where this is already being done).

Thanks in advance,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
