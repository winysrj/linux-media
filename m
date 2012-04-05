Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65527 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2DEU5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 16:57:24 -0400
Received: by gghe5 with SMTP id e5so1008628ggh.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 13:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
References: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
Date: Thu, 5 Apr 2012 16:57:23 -0400
Message-ID: <CAGoCfiwKU1doqvdcHFpVoc2xuRQKdQirWze0oB2QQyXSQcYrKw@mail.gmail.com>
Subject: Re: Unknown eMPIA tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 5, 2012 at 3:30 PM, Stefan Monnier <monnier@iro.umontreal.ca> wrote:
> I just got a USB tuner ("HD TV ATSC USB stick") which lsusb describes as
> "ID eb1a:1111 eMPIA Technology, Inc." and was wondering how to try to
> get it working.
>
> Would the em28xx driver be able to handle it?  If so, how should I modify
> it to try it out?

You would probably have to start by taking it apart and seeing which
demodulator and tuner chips it contained.  Once those are known, we
can assess whether there are drivers for those components under Linux
today.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
