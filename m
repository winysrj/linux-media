Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55430 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZGJMJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 08:09:46 -0400
Message-ID: <4A572F7E.6010701@iki.fi>
Date: Fri, 10 Jul 2009 15:09:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
References: <4A4481AC.4050302@powercraft.nl> <4A4D34B3.8050605@iki.fi>	 <4A4E2B45.8080607@powercraft.nl> <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>
In-Reply-To: <829197380907091805h10bcf548kbf5435feeb30e067@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hei Devin,
Thank you for debugging this issue.

Devin Heitmueller wrote:
> Thanks to Jelle providing an environment to debug the issue in, I
> isolated the problem.  This is actually a combination of bugs in
> mplayer and the af9013 driver not handling the condition as gracefully
> as some other demods.
> 
> First the bugs in mplayer:
> 
> The following is the line from the channels.conf where tuning failed:
> 
> Frequency in question:
> 3FM(Digitenne):722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_AUTO:TRANSMISSION_MODE_AUTO:GUARD_INTERVAL_AUTO:HIERARCHY_AUTO:0:7142:1114
> 
> Mplayer does not support "TRANSMISSION_MODE_AUTO",
> "GUARD_INTERVAL_AUTO" and "QAM_AUTO" (for the constellation).  In the
> case of the transmission mode and constellation, mplayer does not
> populate the field at all in the struct sent to the ioctl(), so you
> get whatever garbage is on the stack.  For the guard interval field,
> it defaults to GUARD_INTERVAL_1_4 if it is an unrecognized value.
> 
> I confirmed the mplayer behavior with the version Jelle has, as well
> as checking the source code in the svn trunk for the latest mplayer.
> 
> So, why does it work with some tuners but not the af9013?  Well, some
> demodulators check to see if *any* of the fields are "_AUTO" and if
> any of them are, then it puts the demod into auto mode and disregards
> whatever is in the other fields.  However, the af9013 looks at each
> field, and if any of them are an unrecognized value, the code bails
> out in af9013_set_ofdm_params().   As a result, the tuning never
> actually happens.
> 
> The behavior should be readily apparent if you were to put the above
> line into your channels.conf and try to tune (note I had to add
> printk() lines to af9013_set_ofdm_params() to see it bail out in the
> first switch statement.
> 
> Anitti, do you want to take it from here, or would you prefer I rework
> the routine to put the device into auto mode if any of the fields are
> auto?

af9013 is correct in my mind. af9013 will return -EINVAL (error invalid 
value) in case of first garbage value met (maybe better to switch auto 
mode when garbage value meet and print debug log?).

Of course there should be at least debug printing to inform that... but 
fix you suggest is better for compatibility. You can do that, it is ok 
for me.

> 
> Devin

Antti
-- 
http://palosaari.fi/
