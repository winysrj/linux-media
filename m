Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37864 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KKXQV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 18:16:21 -0500
Received: by wyh15 with SMTP id 15so4333204wyh.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 15:16:19 -0800 (PST)
Message-ID: <4ebdacc2.04c6e30a.29e4.58ff@mx.google.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	Tim Draper <veehexx@gmail.com>, linux-media@vger.kernel.org
Date: Fri, 11 Nov 2011 23:16:13 +0000
In-Reply-To: <CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	 <CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	 <CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
	 <CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-11-12 at 09:51 +1100, Jason Hecker wrote:
> I concur.  I have been using Malcolm Priestly's patches with both my
> AF9015 dual tuner cards (which are PCI but still look like USB to the
> kernel) for a few weeks now and have (finally!) got consistently
> perfect recordings in MythTV simultaneously with both tuners on a
> card. Malcolm, when do you think you'll submit these patches to the
> tree for inclusion?  Is there anything else to test?
> 
> I agree about the power cycling.  Every time I reboot I disconnect the
> AC supply for 20secs to be sure the cards are power cycled properly -
> you do the same thing by pulling out the stick.

Yes, this is what is holding up the patches to media_build.

The bug appears to be a race condition that appears in get config with
some usb controllers.

Josu, your patch is for the older hg version on s2, so this will not
work on media_build.

I have being trying to a way to do it without the bus lock, but can't

I will try and finish the patches tomorrow.

Regards


Malcolm

