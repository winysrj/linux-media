Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33375 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZE1TMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 15:12:31 -0400
Received: by ewy24 with SMTP id 24so5717173ewy.37
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 12:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1E0DA7.6040702@gatech.edu>
References: <4A1E0DA7.6040702@gatech.edu>
Date: Thu, 28 May 2009 15:12:31 -0400
Message-ID: <37219a840905281212i6707a718t3b1e3c9b03d4ac3b@mail.gmail.com>
Subject: Re: "Unknown symbol __udivdi3" with rev >= 11873
From: Michael Krufky <mkrufky@kernellabs.com>
To: David Ward <david.ward@gatech.edu>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 28, 2009 at 12:05 AM, David Ward <david.ward@gatech.edu> wrote:
> Revision 11873 (committed earlier today) has broken the cx18 driver for me,
> with the line "cx18: Unknown symbol __udivdi3" appearing in dmesg when the
> module tries to load.  I'm using Ubuntu 8.04.2 which uses kernel 2.6.24 and
> gcc 4.2.4.
>
> I also wanted to express my appreciation to Mauro for fixing the build for
> older kernels today, as it is very desirable for me to use a
> distribution/kernel which has long-term support and updates, but I simply
> need to add a DVB driver that wasn't part of the older kernel.
>
> Thanks so much.
>
> David Ward

Let it be known that this issue only affects 32bit kernels.  I believe
the offending line of code is here:

fsc = ((((u64)sc) * 28636360)/src_decimation) >> 13L;

(cc added to Andy Walls)

-Mike Krufky
