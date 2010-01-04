Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:64757 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab0ADRg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 12:36:29 -0500
Received: by fg-out-1718.google.com with SMTP id 22so6239891fge.1
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2010 09:36:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 4 Jan 2010 12:36:27 -0500
Message-ID: <829197381001040936w3bc9b4e0w22eecded4687d9d3@mail.gmail.com>
Subject: Call for Testers - dib0700 IR improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have done some refactoring of the dib0700 IR code for firmware 1.20,
which should address concerns about the high load average when devices
are connected.  It might also address people's reports of mt2060
errors on the Nova-T 500 after several hours of operation (which would
occur unless they used the disable_ir_polling modprobe option).

I am looking for feedback from users who have dib0700 based devices
and have reported problems with IR support in the past.  The tree can
be found here:

http://www.kernellabs.com/hg/~dheitmueller/dib0700_ir

More info can be found here:

http://www.kernellabs.com/blog/?p=1292

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
