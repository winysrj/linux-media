Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58295 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3AHS7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 13:59:12 -0500
Received: by mail-qa0-f50.google.com with SMTP id cr7so28537qab.16
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 10:59:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EC6828.1070300@googlemail.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
	<1357333186-8466-16-git-send-email-dheitmueller@kernellabs.com>
	<50EC6828.1070300@googlemail.com>
Date: Tue, 8 Jan 2013 13:59:11 -0500
Message-ID: <CAGoCfiySM5xz=OFOQ6nvsram8MjFMWqx45YTXgwdjz20s=yewg@mail.gmail.com>
Subject: Re: [PATCH 15/15] em28xx: convert to videobuf2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 8, 2013 at 1:40 PM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Bad news. :(
> The patch seems to break USB bulk transfer mode. The framerate is zero.
> I've tested with the Silvercrest webcam and the Cinergy 200. Both
> devices work fine when selecting isoc transfers.

I'll take a look.  I cannot actively debug it since I don't have any
devices which do bulk, but I'll at least see if anything jumps out at
me.

If I had to guess, probably something related to the setting up of the
USB alternate.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
