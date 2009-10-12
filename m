Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:32953 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbZJLVsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 17:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <f326ee1a0910121420j59d4f63dy1ffcb1636a9a63d1@mail.gmail.com>
References: <f326ee1a0910121420j59d4f63dy1ffcb1636a9a63d1@mail.gmail.com>
Date: Mon, 12 Oct 2009 17:48:08 -0400
Message-ID: <829197380910121448l1a9f35fmff276ad14afd9ac4@mail.gmail.com>
Subject: Re: Kworld Analog TV 305U without audio - updated
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	lauri.laanmets@proekspert.ee, grythumn@gmail.com,
	jarod@wilsonet.com, ridzevicius@gmail.com, xwang1976@email.it,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 5:20 PM, Dênis Goes <denishark@gmail.com> wrote:
> Hi...
>
> I updated the driver to latest in repository, but I having audio problems
> yet:
>
> I'm testing a USB TV "Kworld PlusTV Analog TV stick VS-PVR-TV 305U" the TV
> video works fine, but without audio...
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> I tried to pipe the audio via sox:
> tvtime -d /dev/video1 & sox -v 1 -V4 -S -t ossdsp /dev/dsp1 -t ossdsp
> /dev/dsp
>

Just as a test, try opening two console windows, run tvtime in one,
and then once the video is showing run the sox command in the other
window.  I just want to rule out this being some sort of race
condition.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
