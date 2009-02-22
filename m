Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp123.rog.mail.re2.yahoo.com ([206.190.53.28]:20603 "HELO
	smtp123.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751994AbZBVTfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 14:35:03 -0500
Message-ID: <49A1A8E4.8030307@rogers.com>
Date: Sun, 22 Feb 2009 14:35:00 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: David Engel <david@istwok.net>
CC: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
References: <20090217155335.GB6196@opus.istwok.net> <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net> <499B1E19.80302@linuxtv.org> <20090218051945.GA12934@opus.istwok.net> <499C218D.7050406@linuxtv.org> <20090218153422.GC15359@opus.istwok.net> <20090219162820.GA23759@opus.istwok.net>
In-Reply-To: <20090219162820.GA23759@opus.istwok.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Engel wrote:
> I'll start with what worked.
>
> ... [test results of BER and UNC under varying configurations ] ...
>   

Steven Toth wrote:
> I think CityK confirmed that the nxt2004 driver statistics are
> probably bogus so I doubt you're going to get your 115's running with
> BER 0 regardless, which is unfortunate. 

FWIW:

I'm not seeing any UNC, just the BER (which seems consistent to most,
but not all, of David's results with varying configurations).

Presently (and a situation that is unlikely to change), I don't have an
older kernel built/installed with which I can test/confirm, but from
memory, IIRC, I believe that it must have been from around ~2.6.22 that
I recall error free femon output.

