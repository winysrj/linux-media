Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:35314 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbbGNPmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 11:42:53 -0400
Received: by ykdu72 with SMTP id u72so11369265ykd.2
        for <linux-media@vger.kernel.org>; Tue, 14 Jul 2015 08:42:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAM_ZknU-emTOt3c2mS1cC+YZ4hTbev-W-z9GLAP5wHuqF2pfCw@mail.gmail.com>
References: <CAM_ZknV+AEpxbPkKjDo68kRq-5fg1b7p77s+gfF3XGLZS9Tvyg@mail.gmail.com>
	<CAM_ZknWEjUTy0btqFYhJvSJiAFV6uTJzB3ceZzEMxNkKHr2dTg@mail.gmail.com>
	<CAM_ZknU-emTOt3c2mS1cC+YZ4hTbev-W-z9GLAP5wHuqF2pfCw@mail.gmail.com>
Date: Tue, 14 Jul 2015 18:42:52 +0300
Message-ID: <CAM_ZknWx8fAZAsUJLATY-As9yRWBos8JcuP_G4Z2r_MWS6GpjA@mail.gmail.com>
Subject: Re: tw5864 driver development, help needed
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Linux Media <linux-media@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An update with a request for help.

Asking for help with h264 headers generation. Both copying headers
from similar videos and porting headers generation code from reference
driver don't work for me (ref driver is weird and very complicated, so
porting involved importing of lots of code, but still in my case the
generated header differs from the one produced by reference driver,
and resulting files are not decodable).
Wireshark seems not able to dissect raw h264 files, so that I could
compare headers bitfield-wise.
I have dumped 64 first encoded frames as they appear from hardware, so
that you could look at it.
This is archive: http://lizard.bluecherry.net/~autkin/vlc.tar.gz and
this is contents list of archive
http://lizard.bluecherry.net/~autkin/vlc.contents

Only one camera is attached to this multi-channel video grabber and
encoder, and i don't know which chip has it (4, 5, 6 or 7).
The produced frames should have the same settings as this file:
http://lizard.bluecherry.net/~autkin/test_main.h264
This is PAL D1, 720x576.
Thanks in advance for any help. At last, the ability to look at
visualization of those h264 streams would be great.

-- 
Bluecherry developer.
