Return-path: <linux-media-owner@vger.kernel.org>
Received: from zero.voxel.net ([69.9.191.6]:41109 "EHLO zero.voxel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZFHCMv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 22:12:51 -0400
Message-ID: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net>
Date: Sun, 7 Jun 2009 22:12:53 -0400 (EDT)
Subject: Re: funny colors from XC5000 on big endian systems
From: "W. Michael Petullo" <mike@flyn.org>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Is it possible that the XC5000 driver does not work properly on big
>> endian systems? I am using Linux/PowerPC 2.6.29.4. I have tried to view
>> an analog NTSC video stream from a Hauppauge 950Q using various
>> applications (including GStreamer v4lsrc and XawTV). The video is
>> always present, but in purple and green hues.

> Do you see the issue using tvtime?  This will help isolate whether it's
> an application compatibility issue or whether it's related to endianness
> (and I do almost all my testing with tvtime).

Tvtime works like a charm. The colors look fine. This is the first I've
seen tvtime and it seems great. Now we may be getting off the topic, but
does anyone know why xawtv, streamer and GStreamer's v4l2src would muck up
the colors?

> You indicated that you had reason to believe it's a PowerPC issue.  Is
> there any reason that you came to that conclusion other than that you're
> running on ppc?  I'm not discounting the possibility, but it would be
> good to know if you have other information that supports your theory.

It was a hypothesis, but based on experience in "seeing" endian bugs in
video code and "hearing" endian bugs in audio code. After using PowerPC
long enough, you learn to jump to the endian conclusion pretty quickly. I
was wrong!

Thanks.

Mike

