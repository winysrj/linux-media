Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65086 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab0BHRDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 12:03:31 -0500
Received: by bwz19 with SMTP id 19so2038935bwz.28
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 09:03:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7e5e0d9a1002060914l11e6d0baje575675dd8b21404@mail.gmail.com>
References: <7e5e0d9a1002060914l11e6d0baje575675dd8b21404@mail.gmail.com>
Date: Mon, 8 Feb 2010 12:03:29 -0500
Message-ID: <829197381002080903q1dfabd80qa53a738068ce5a87@mail.gmail.com>
Subject: Re: [Bugme-new] [Bug 15087] New: hauppauge nova-t 500 remote
	controller cause usb halt with Via usb controller
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: edm <fuffi.il.fuffo@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 6, 2010 at 12:14 PM, edm <fuffi.il.fuffo@gmail.com> wrote:
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).

<snip>

> Hi, using the last version of v4l-dvb driver from hg, solved this
> issue. I tested the card in the last days and it seems to work well
> now; the IR receiver works, I tested it using irw, all the keys are
> recognised.
> I can't test the IR receiver with a specific program because the
> .lircrc is ignored but I think it's a gnome-related problem :)
> Is the option "dvb_usb_dib0700 force_lna_activation=1" still
> necessary? Why this option is not activated at default?

Hello edm,

Sorry for the delayed response on this.

Glad to hear it's now working for you.

With regards to the force_lna_activation option, this was never
actually related to the dib0700 firmware changes.  That option simply
may or may not be required depending on what your signal conditions
are.  Enabling the low noise amplifier is something that you will
typically do only if your signal conditions are poor, which is why it
is not enabled by default.

The fix referred to in this bug report was strictly for the dib0700
problem introduced as a result to changes for IR required to support
the 1.20 firmware.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
