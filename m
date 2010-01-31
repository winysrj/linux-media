Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.211.179]:55619 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab0AaQZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 11:25:34 -0500
Received: by ywh9 with SMTP id 9so3688258ywh.19
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 08:25:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264951975.28401.8.camel@alkaloid.netup.ru>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
	 <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
	 <1264951975.28401.8.camel@alkaloid.netup.ru>
Date: Sun, 31 Jan 2010 17:25:32 +0100
Message-ID: <b36f333c1001310825n6ae6e5dbg45a0cf135d2e89e@mail.gmail.com>
Subject: Re: CAM appears to introduce packet loss
From: Marc Schmitt <marc.schmitt@gmail.com>
To: Abylai Ospan <aospan@netup.ru>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compiling from source made me stumble across
http://www.mail-archive.com/ubuntu-devel-discuss@lists.ubuntu.com/msg09422.html
I just left out the firedtv driver as recommended.

I'm getting the following kernel output after enabling dvb_demux_speedcheck:
[  330.366115] TS speed 40350 Kbits/sec
[  332.197693] TS speed 40085 Kbits/sec
[  334.011856] TS speed 40528 Kbits/sec
[  335.843466] TS speed 40107 Kbits/sec
[  337.665411] TS speed 40261 Kbits/sec
[  339.496959] TS speed 40107 Kbits/sec
[  341.318289] TS speed 40350 Kbits/sec

Do you think the CI/CAM can not handle that?

On Sun, Jan 31, 2010 at 4:32 PM, Abylai Ospan <aospan@netup.ru> wrote:
> On Sun, 2010-01-31 at 16:23 +0100, Marc Schmitt wrote:
>> Looks like I need to build the DVB subsystem from the latest sources
>> to get this option as it was recently added only
>> (http://udev.netup.ru/cgi-bin/hgwebdir.cgi/v4l-dvb-aospan/rev/1d956b581b02).
>> On it.
> yes.
>
> this option should show "raw" bitrate coming from demod and which passed
> to CI. In user level you may be measuring bitrate after software PID
> filtering ( may be not ).
>
> --
> Abylai Ospan <aospan@netup.ru>
> NetUP Inc.
>
>
