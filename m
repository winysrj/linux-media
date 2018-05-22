Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:56124 "EHLO smtp.amw.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751196AbeEVO0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 10:26:50 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <8d75cb205142a3739a2d30f03ffe9fae@smtp-cloud9.xs4all.net>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <00d1da95-726a-46d3-b6e2-f18a540af579@anw.at>
Date: Tue, 22 May 2018 16:26:48 +0200
MIME-Version: 1.0
In-Reply-To: <8d75cb205142a3739a2d30f03ffe9fae@smtp-cloud9.xs4all.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans!

> linux-4.9.91-x86_64: ERRORS
> /home/hans/work/build/media_build/v4l/dw9807.c:321:3: error
The build works in my tree ... ?!?
I can't find the file in media_tree:
   find . -name "*9807*"

Can you please check if there is something wrong with your
media_tree version which is used for the daily build.
I have 8ed8bba70b43 as top commit.

And another thing:
 ./prepare_kernel.sh 3.2 x86_64
fails with
 fatal error: linux/compiler-gcc8.h: No such file or directory
this leads to a build error in the daily build also.

BR,
   Jasmin
