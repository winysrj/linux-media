Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:53472 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0EDNg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 09:36:29 -0400
Received: by ywh36 with SMTP id 36so1667285ywh.4
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 06:36:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005041400.10530.jan_moebius@web.de>
References: <201005041400.10530.jan_moebius@web.de>
Date: Tue, 4 May 2010 09:36:27 -0400
Message-ID: <z2q829197381005040636vbd2d7254n4674dcc21cc751f4@mail.gmail.com>
Subject: Re: Hauppauge HVR-4400
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Jan_M=F6bius?= <jan_moebius@web.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 4, 2010 at 8:00 AM, Jan Möbius <jan_moebius@web.de> wrote:
> Hi,
>
> im trying to get a Hauppauge HVR-4400 working on a Debian squeeze. It seems to
> be unsopported yet. Is there any driver which i don't know about?

There is no support currently for that card, and since it uses a
demodulator for which there is not currently a driver, much more work
will be required than simply adding a new board profile.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
