Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1JMDUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 23:20:25 -0400
Received: by bkbzt4 with SMTP id zt4so847233bkb.19
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2011 20:20:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DCC39C6.30802@lockie.ca>
References: <4DCC39C6.30802@lockie.ca>
Date: Wed, 12 Oct 2011 23:20:23 -0400
Message-ID: <CAGoCfiysOxEgpMhGSDOjo3Utg8AH6kUjRkkO2wF__KB_0i-zvQ@mail.gmail.com>
Subject: Re: digital tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: James <bjlockie@lockie.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 12, 2011 at 3:49 PM, James <bjlockie@lockie.ca> wrote:
>
> I have an analog: Hauppauge WinTV-Go PLUS which has a lineout.
>
> I'm considering a digital card.
> The Hauppauge WinTV-HVR-1250 does NOT have a lineout so how does it do
> sound?
> Does PCIe pass through the sound to the OS sound system?
> I read on the linuxtv wiki that only the digital works on this card.

You've probably already figured this out by now, but the cx23885 does
have an ALSA driver, which isn't yet upstream.  Igor actually just
rebased Steven's tree with the support against the latest kernel, so
hopefully it will make it upstream soon (see the linux-media mailing
list for the last couple of days to find the thread).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
