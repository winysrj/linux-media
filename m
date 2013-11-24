Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:43681 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3KXRVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Nov 2013 12:21:35 -0500
Received: by mail-la0-f53.google.com with SMTP id ea20so2264846lab.40
        for <linux-media@vger.kernel.org>; Sun, 24 Nov 2013 09:21:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130603172150.1aaf1904@endymion.delvare>
References: <20130603171607.73d0b856@endymion.delvare>
	<20130603172150.1aaf1904@endymion.delvare>
Date: Sun, 24 Nov 2013 22:51:33 +0530
Message-ID: <CAHFNz9LX0WzmO1zvn51Ge8VQkfiPrao3AQVLprhqrp1V-0h=fQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] femon: Display SNR in dB
From: Manu Abraham <abraham.manu@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Sorry, that I came upon this patch quite late.

On Mon, Jun 3, 2013 at 8:51 PM, Jean Delvare <khali@linux-fr.org> wrote:
> SNR is supposed to be reported by the frontend drivers in dB, so print
> it that way for drivers which implement it properly.


Not all frontends do report report the SNR in dB. Well, You can say quite
some frontends do report it that way. Making the application report it in
dB for frontends which do not will show up as incorrect results, from what
I can say.

Best Regards,

Manu
