Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42659 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0FGVcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 17:32:21 -0400
Received: by iwn37 with SMTP id 37so3866835iwn.19
        for <linux-media@vger.kernel.org>; Mon, 07 Jun 2010 14:32:21 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Jun 2010 14:32:20 -0700
Message-ID: <AANLkTimL7XvSCrjsLBy81YmbTft8904kJJyauLmwn8Sr@mail.gmail.com>
Subject: zvbi-atsc-cc Time-stamps?
From: Santino Chianti <sonnychianti@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

I need help figure out a way to get accurate time stamps on my closed
captioning files using zvbi-atsc-cc.

I have Hauppauge HVR-1850 cards working in digital mode.  I need
separate recordings of the video/audio file (mpeg2) and the closed
captioning (plain text).  I can capture a plain mpeg stream by issuing
this in one console:

* azap -r KOCE-HD

And this in a second console:

* cat /dev/dvb/adapter0/dvr0 > test-cat3.mpeg

I tested this file and it plays fine.  To generate the closed
captioning, I feed this file into zvbi-atsc-cc:

* zvbi-atsc-cc --atsc -c KCAL-HD -T < test-cat3.mpeg

"KCAL-HD" being the the channel in my channels.conf that I captured from.


The problem: I need accurate time stamps.  Normally, I add the time
stamps during capture, so they match reality. If I get the closed
captioning from a file, the information is still in the file (I just
need to set the start time), but how do I get that information out?

Our system relies on the time stamps in the closed captioning to cue
the video, so they need to be accurate.  One-second accuracy is
adequate, so if I can get the STT information from the PSIP info, that
would be good enough. I'm using an off-air signal, so these are ATSC
8VSB channels:

LA18.8:497000000:8VSB:161:164:8
KBEH-DT:533000000:8VSB:49:52:1
KCET-HD:557000000:8VSB:49:52:1

A typical closed captioning file should end up looking like this:

2010-05-02_1100_CNN_Amanpour_2010-05-02_11:00:02
% Communication Studies Archive, UCLA
% 87e70c70-5614-11df-b2f7-00e0815fe826
% Video length 0:59:54.024
% Christiane Amanpour
2010-05-02_1100_CNN_Amanpour_2010-05-02_11:00:12
2010-05-02_1100_CNN_Amanpour_2010-05-02_11:00:22
A HIGH STAKES INVESTIGATION
IS STARTED AFTER A CAR BOMB IS 2010-05-02_1100_CNN_Amanpour_2010-05-02_11:00:32
FOUND IN NEW YORK'S TIMES
SQUARE.
WHO WANTED TO ATTACK THE
CROSSROADS OF THE WORLD AND WHY.
PRESIDENT OBAMA HEADS TO THE
GULF COAST FOR A FIRSTHAND LOOK 2010-05-02_1100_CNN_Amanpour_2010-05-02_11:00:42
AT DESPERATE EFFORTS TO MAINTAIN
AN OIL SPILL.

-- in other words, a time stamp every ten seconds, which is then used
by our search engine to link to the video. The header (%) is added
afterward. Ideally for us, then, I would get the STT stamp at
ten-second intervals inserted into the closed captioning file. Are
there command-line Linux tools for reading PSIP?

(There are also other possible uses of PSIP. xds information is too
unreliable and inconsistent for us to use, but if PSIP is reliable,
I'd like to use it to verify that I'm getting the recording I intended
to get (channel and program name). I could potentially use this
information to crop the video to the exact program -- but it would
have to be reliable enough to be automated, I don't have staff to do
anything manual with individual recordings.)

Alternatively, Devin Heitmueller tells us that there is also the PTS
(presentation timestamp), which should be pretty easy to modify
zlib-atsc-cc to show.  Since the PTS can be used to synchronize the
video to the CC info is it possible to make a small modification to
zvbi-atsc-cc to log the CC info with the PTS, and then write a really
simple utility to seek to a given PTS and play the video?

Could someone help me out with accurate timestamps in relation to PSIP
info and PTS?

Warm wishes,
Santino
