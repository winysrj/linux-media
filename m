Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:44482 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZGQVDH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 17:03:07 -0400
To: James Guo <jinp65@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] saa7134 - ir remote for sinovideo 1300
References: <674891.7036.qm@web39105.mail.mud.yahoo.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 17 Jul 2009 23:03:05 +0200
In-Reply-To: <674891.7036.qm@web39105.mail.mud.yahoo.com> (James Guo's message of "Thu\, 16 Jul 2009 17\:58\:33 -0700 \(PDT\)")
Message-ID: <m3eisfaupi.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James Guo <jinp65@yahoo.com> writes:

> Have a tv tuner believe to be sinovideo 1300, and the remote has h-338 in the
> back, the tuner is detected as saa7134 proteus 2309, and working fine, the
> patch is for the remote.
>
> following buttons supposed to be working: all the number button, channel up and
> down, volumn up and down, off, mute, full screen, recall, snapshot, tv.  Some
> buttons do not have valid entry for tvtime, so I did not map them(record, stop
> ...)
>
> to apply, use command
> modprobe saa7134 card=157
> if it does not work, use
> modprobe saa7134 card=157 ir_debug=1
> and send me the output of dmesg(after modprobe and after a button is pressed)

I think we should add something printing changes on the GPIO line (and
current time). That should be easy, will try to have something soon.
That would show what code exactly a remote is using, at last.
-- 
Krzysztof Halasa
