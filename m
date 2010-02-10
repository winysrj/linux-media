Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:44907 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab0BJDMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 22:12:32 -0500
Received: by bwz23 with SMTP id 23so870475bwz.1
        for <linux-media@vger.kernel.org>; Tue, 09 Feb 2010 19:12:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B722266.4070805@cooptel.qc.ca>
References: <4B70E7DB.7060101@cooptel.qc.ca>
	 <1265768091.3064.109.camel@palomino.walls.org>
	 <4B722266.4070805@cooptel.qc.ca>
Date: Tue, 9 Feb 2010 22:12:30 -0500
Message-ID: <829197381002091912h5391129dpbf075485ab011936@mail.gmail.com>
Subject: Re: Driver crash on kernel 2.6.32.7. Interaction between cx8800
	(DVB-S) and USB HVR Hauppauge 950q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Richard Lemieux <rlemieu@cooptel.qc.ca>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 9, 2010 at 10:05 PM, Richard Lemieux <rlemieu@cooptel.qc.ca> wrote:
> Andy,
>
> This is a great answer!  Thanks very much.  When I get into this situation
> again
> I will know what to look for.
>
> A possible reason why I got into this problem in the first place is that I
> tried
> many combinations of parameters with mplayer and azap in order to learn how
> to use the USB tuner in both the ATSC and the NTSC mode.  I will look back
> in the terminal history to see if I can find anything.

I think the key to figuring out the bug at this point is you finding a
sequence where you can reliably reproduce the oops.  If we have that,
then I can start giving you some code to try which we can see if it
addresses the problem.

For example, I would start by giving you a fix which results in us not
calling the firmware release if the request_firmware() call failed,
but it wouldn't be much help if you could not definitively tell me if
the problem is fixed.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
