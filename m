Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33643 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab1JDUCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 16:02:09 -0400
Received: by eya28 with SMTP id 28so853694eya.19
        for <linux-media@vger.kernel.org>; Tue, 04 Oct 2011 13:02:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8B61FF.8000505@iki.fi>
References: <4E8B61FF.8000505@iki.fi>
Date: Tue, 4 Oct 2011 16:02:07 -0400
Message-ID: <CALzAhNW2=KBqVp69Stoc2AVp9QiW6=0pzyFwjS8A5xJ-vrpqVA@mail.gmail.com>
Subject: Re: Cypress EZ-USB FX2 firmware development
From: Steven Toth <stoth@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

> I would like to made own firmware for Cypress FX2 based DVB device. Is there
> any sample to look example?

I've done multiple FX2 firmware projects in the past, including DVB-T.

The technical reference manual for the FX2 explains the GPIF waveform
sampling engine very well. It also shows sample firmware listings for
operating the fifo engine in the different input or output modes.
You'll find it via google.

If you have specific questions then I'd be happy to answer them on the
mailing-list.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
