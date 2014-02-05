Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39600 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaBEJqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 04:46:16 -0500
Received: by mail-qc0-f172.google.com with SMTP id c9so201971qcz.3
        for <linux-media@vger.kernel.org>; Wed, 05 Feb 2014 01:46:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F1D497.4010509@gmail.com>
References: <52F1D497.4010509@gmail.com>
Date: Wed, 5 Feb 2014 04:46:15 -0500
Message-ID: <CAGoCfiy-EdA4pbcCB6uLBSp7HUBW+=2vRYG8m+Q8V4tQmGTRag@mail.gmail.com>
Subject: Re: au0828 errors and mangled video with Hauppauge 950Q
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Connor Behan <connor.behan@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 5, 2014 at 1:05 AM, Connor Behan <connor.behan@gmail.com> wrote:
> Ccing Devin. I'm pretty sure the analog side has a problem at the driver
> level.
>
> On most days, one cannot pickup an ATSC signal where I am, so I am
> trying to capture analog video with a Hauppauge WinTV HVR 950Q. Whether
> I use Television, Composite or S-Video, I see the same corrupted video
> such as this: http://imgur.com/c398F4v

Looks like insufficient USB bandwidth available to support the 24
MB/second required for uncompressed analog video.

Is this on an x86 PC?  Or some embedded target such as ARM?  If the
latter, then the answer is almost certainly that the USB host
controller implementation is garbage and cannot handle the throughput.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
