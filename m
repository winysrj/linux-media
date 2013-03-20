Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49958 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3CTW7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 18:59:11 -0400
Received: by mail-qa0-f52.google.com with SMTP id bs12so1360548qab.18
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 15:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303202020.09575.hverkuil@xs4all.nl>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
	<6d4b25c7bfc65cfff4937133bed3e60828c20174.1363035203.git.hans.verkuil@cisco.com>
	<CAGoCfiyYRwjb-+i84MrxBXaxJT=Fy7ucj02N1Lvy8n4LC0FBKw@mail.gmail.com>
	<201303202020.09575.hverkuil@xs4all.nl>
Date: Wed, 20 Mar 2013 18:59:10 -0400
Message-ID: <CAGoCfiwv7YmMy1UJk2FuPT1ACxX=tke8ccAqAiWWYqqs9RTTyg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/15] au0828: fix disconnect sequence.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 20, 2013 at 3:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I want to make a pull request for this. Can I have your Acked-by or do you
> want to look at this some more?

I *looked* at all the patches, and they all look fine.  That said, I
haven't actually installed them at all and seen if anything got
broken.  The logic is so convoluted that it's entirely possible there
is breakage that wouldn't be obvious simply by reviewing the patches
without actual testing with real application (and no, v4l-2ctl and
v4l2-compliance do *not* count as real applications).

Did you try the resulting patches with anything other than
v4l2-compliance/v4l2-ctl?  tvtime?  xawtv?  mythtv?

Hence, for what it's worth:

Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
