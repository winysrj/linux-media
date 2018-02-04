Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:47947 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbeBDWpl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Feb 2018 17:45:41 -0500
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        arnd@arndb.de
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
 <1778442.ouJt2D3mk7@avalon> <f2e313c8-6013-bd1b-09da-8fa4fc12814e@anw.at>
 <e67396cf-c048-b915-d998-306fe44f7186@xs4all.nl>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <b70bdd87-0c1c-da98-e2dc-00bf29014973@anw.at>
Date: Sun, 4 Feb 2018 23:45:34 +0100
MIME-Version: 1.0
In-Reply-To: <e67396cf-c048-b915-d998-306fe44f7186@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-ZA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> We're waiting for the end of the 4.16 merge window.
Ahh, this is the reason for the delay.

> For me that meant that I simply did (and still don't) have time to look at
> fixing the media_build.
No problem, I do it when I have time ;)

> The media_build is also broken worse than usual AFAIK, so it isn't a quick fix
> I can do in between other jobs.
I will look into that, when I fixed the current problem in uvcvideo
temporarily.

> I'm OK to take a patch and then revert it later when the real fix has been merged.
So ... just sent a patch for media_build.

> BTW, if you are interested then I would be more than happy to hand over media_build
> maintenance to you.
I am not sure if I know enough to completely do this. But I can be a substitute
and continue what I did the last month. This means I would prefer that you keep
the head of media_build and I do the work.
But I would need write access to the media_build GIT tree. Please contact me
off list for details.

BR,
   Jasmin
