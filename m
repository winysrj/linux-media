Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab3ASMFR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 07:05:17 -0500
Date: Sat, 19 Jan 2013 10:04:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Simon Farnsworth <simon.farnsworth@onelan.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130119100417.49da9f10@redhat.com>
In-Reply-To: <20130116200153.3ec3ee7d@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Jan 2013 20:01:53 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Wed, 16 Jan 2013 19:29:28 +0000
> Simon Farnsworth <simon.farnsworth@onelan.com> escreveu:
...
> > So, how do you provide such information? 
...

I just finished to code it on my experimental tree:
	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/stats

The code there is tested, and it should be displaying all stats at dvbv5-zap
code. While I didn't test yet, backward compatibility with DVBv3 stats is
provided.

What's missing:

a) a routine to calculate and return PER

I didn't write it just because I need to first make UCB/PER measurements to
work with mb86a20s. The userspace code, however, is trivial.

b) display only one layer for the statistics.

It is relatively easy to detect if the displayed program is 1-seg. 
All the code needs is to read the NIT table and check if the Partial TS 
descriptor is present at NIT table and matches the service ID of the
displayed program. If so, only the statistics for the 1-seg layer applied.
This descriptor is mandatory. So, a code for doing it shouldn't be hard
to code, and should work fine if just 2 layers (1-seg and 12-seg) are
present on a given channel (that's the most usual usecase).

However, I couldn't find yet a way to do the same for the 3-seg layer when
present. In thesis, the TS Information Descriptor would be carrying this
data, inside the Transmission Type field, but both ARIB and ABNT specs
I read lacks a table with the possible values for it. The ABNT spec
mentions that a latter document would carry that info, but I couldn't
find it yet. Also, the TS Information Descriptor is optional, although
I never find any broadcaster that don't implement it in Brazil, as, on
ISDB, the Remote Control channel uses this descriptor as well.
This is less critical than the first case, as most broadcasters use
2 layers. However, I've seen already a few broadcasters using 3 layers
(generally, 1-seg, 3-seg and 9-seg) on some cities.

So, for now, if multiple layers are found, the dvbv5-zap program on my
experimental tree will just display data for all existing layers.
I'll address it there later.

-

The following changes since commit 28178e74681db0d0d924b1c2cc69e0d7a9295b16:

  v4l2-compliance: add check whether the timestamp is monotonic. (2013-01-10 13:47:15 +0100)

are available in the git repository at:
  git://linuxtv.org/mchehab/experimental-v4l-utils.git stats

for you to fetch changes up to b20f43e723fa8fd5f1ed74f1566d314490946fa6:

  dvbv5-zap: better display BER (2013-01-19 09:30:18 -0200)

----------------------------------------------------------------
Mauro Carvalho Chehab (9):
      dvbv5-zap: Allow to enable FE debug
      Sync with kernel, with DVB stats
      dvb-fe: add support for DVBv5 stats
      dvbv5-zap: use the new DVBv5 stats API
      dvb-fe: Add a flag to indicate if DVBv5 stats is in use
      dvb-fe: Move the logic that calculates BER measures
      dvb-fe: Improve BER measurements for DVBv5
      dvb-fe: Allow returning BER in a float value
      dvbv5-zap: better display BER

 contrib/freebsd/include/linux/dvb/frontend.h |  77 +++++++++++++++++++++++++++++++++++++++++-
 contrib/freebsd/include/linux/dvb/version.h  |   2 +-
 lib/include/dvb-fe.h                         |  39 ++++++++++++++++------
 lib/include/dvb-frontend.h                   |  77 +++++++++++++++++++++++++++++++++++++++++-
 lib/include/dvb-v5-std.h                     |  12 ++++++-
 lib/libdvbv5/dvb-fe.c                        | 265 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 lib/libdvbv5/dvb-file.c                      |  24 ++------------
 lib/libdvbv5/dvb-v5-std.c                    |  19 ++++++++---
 lib/libdvbv5/dvb-v5.c                        |  10 ++++--
 lib/libdvbv5/dvb-v5.h                        |   2 +-
 utils/dvb/Makefile.am                        |   2 +-
 utils/dvb/dvbv5-zap.c                        | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 12 files changed, 590 insertions(+), 116 deletions(-)


Cheers,
Mauro
