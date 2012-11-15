Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35568 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768407Ab2KOQfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 11:35:30 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so1223838qat.19
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 08:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A518E8.8060002@googlemail.com>
References: <loom.20121111T054512-795@post.gmane.org>
	<50A3CDCD.6020900@googlemail.com>
	<CAGoCfiwd0Dt49sZO_XEkv5rGwCj+nEDz0sGxw_j8oxKXE=NQAQ@mail.gmail.com>
	<50A518E8.8060002@googlemail.com>
Date: Thu, 15 Nov 2012 11:35:29 -0500
Message-ID: <CAGoCfiw6zPmFbMRMXZEE1NTGfc3cBJqwdh55S9Hk50fmktbEJQ@mail.gmail.com>
Subject: Re: The em28xx driver error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Michael Yang <yze007@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2012 at 11:31 AM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> Hmm... I've made some experiments to find out what gcc does on x86 and
> it seems to ignore bit shifting > 32.
> I also noticed that this line has been removed in 3.7-rc.
> So we do NOT want to halve the height for interlaced devices here, right ?

Even with the datasheets, it was never clear to me what role the
accumulator size played.  It appeared to work regardless of whether it
was halved (although making it zero obviously caused problems).

Hence, since we couldn't see any visible difference, Mauro just
removed the code.  My guess is that it effects the on-chip internal
buffering hence it's possible that performance/reliability could be
effected under extreme load or some edge case, but I don't have any
data to back up that assertion at this time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
