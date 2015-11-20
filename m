Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36030 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161977AbbKTN1D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 08:27:03 -0500
Received: by oiww189 with SMTP id w189so64300601oiw.3
        for <linux-media@vger.kernel.org>; Fri, 20 Nov 2015 05:27:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564EFD40.8050504@southpole.se>
References: <564EFD40.8050504@southpole.se>
Date: Fri, 20 Nov 2015 14:27:02 +0100
Message-ID: <CAJbz7-2=-ufqdE0YyPUAhV+UybMsmEv7=FuFhrn6o9G7yvXZOg@mail.gmail.com>
Subject: Re: PID filter testing
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-11-20 12:00 GMT+01:00 Benjamin Larsson <benjamin@southpole.se>:
> Hi, what tools can I use to test pid filter support in the drivers ?

Zap utility from dvbapps seems to be some simpler way - you can pass them
the fixed pids and record filtered data by simple command.

See at:
http://www.linuxtv.org/wiki/index.php/Zap

/Honza
