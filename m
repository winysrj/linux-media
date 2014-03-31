Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:41432 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaCaOAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 10:00:19 -0400
Received: by mail-yk0-f174.google.com with SMTP id 20so6163233yks.33
        for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 07:00:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53374174.4000909@podiumbv.nl>
References: <533731B9.7030805@PodiumBV.com>
	<53374174.4000909@podiumbv.nl>
Date: Mon, 31 Mar 2014 10:00:18 -0400
Message-ID: <CALzAhNVKtF60VGUUR8wYjZq6FTLum6SLH1mfbXh=a853vtZuTw@mail.gmail.com>
Subject: Re: FireDTV / w_scan / no data from NIT(actual)
From: Steven Toth <stoth@kernellabs.com>
To: mailinglist@podiumbv.nl
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> But I guess demuxing is necessary to get the "NIT(actual) table", isn't it ?

Generally speaking applications configure the demux to pass all pids,
so yes - the demux is typically mandatory. Data is received from the
dvr0 device.

Assuming the card is tuning and delivering complete unfiltered
transport payload reliably, then if no NIT is appearing then I can
only assume either the application isn't waiting long enough, or it
doesn't existing on that frequency.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
