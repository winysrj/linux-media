Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:38629 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZFHCVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 22:21:51 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1164981wfd.4
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2009 19:21:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net>
References: <4f363d5e6b409da696b35f7e2a966952.squirrel@mail.voxel.net>
Date: Sun, 7 Jun 2009 22:21:53 -0400
Message-ID: <829197380906071921g54469ee7uac77c10d380a7e0a@mail.gmail.com>
Subject: Re: funny colors from XC5000 on big endian systems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "W. Michael Petullo" <mike@flyn.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 7, 2009 at 10:12 PM, W. Michael Petullo<mike@flyn.org> wrote:
>> Do you see the issue using tvtime?  This will help isolate whether it's
>> an application compatibility issue or whether it's related to endianness
>> (and I do almost all my testing with tvtime).
>
> Tvtime works like a charm. The colors look fine. This is the first I've
> seen tvtime and it seems great. Now we may be getting off the topic, but
> does anyone know why xawtv, streamer and GStreamer's v4l2src would muck up
> the colors?

Ok, that's good to know.  Perhaps it's some difference in the way the
v4l stream is read and the frames are dequeued (mmap versus read(),
etc).

>> You indicated that you had reason to believe it's a PowerPC issue.  Is
>> there any reason that you came to that conclusion other than that you're
>> running on ppc?  I'm not discounting the possibility, but it would be
>> good to know if you have other information that supports your theory.
>
> It was a hypothesis, but based on experience in "seeing" endian bugs in
> video code and "hearing" endian bugs in audio code. After using PowerPC
> long enough, you learn to jump to the endian conclusion pretty quickly. I
> was wrong!

Ok, well that's good to know.  I did look at the code and couldn't see
how it could possibly be an endianness bug.

Bear in mind that the analog support for the 950q is still relatively
new, and its entirely possible there are some application specific
bugs to be worked out as there is more testing.

Could you please describe in more detail the *exact* configuration you
are attempting, including the versions of the applications you are
using and command line arguments you are passing.  If I can reproduce
the issue here then I can probably debug it much faster.

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
