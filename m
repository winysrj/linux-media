Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54406 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751196AbeEVOiW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 10:38:22 -0400
Subject: Re: cron job: media_tree daily build: ERRORS
To: "Jasmin J." <jasmin@anw.at>, linux-media@vger.kernel.org
References: <8d75cb205142a3739a2d30f03ffe9fae@smtp-cloud9.xs4all.net>
 <00d1da95-726a-46d3-b6e2-f18a540af579@anw.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8f9ccbc5-20ac-d2ab-cac0-e521b1f6e48e@xs4all.nl>
Date: Tue, 22 May 2018 16:38:18 +0200
MIME-Version: 1.0
In-Reply-To: <00d1da95-726a-46d3-b6e2-f18a540af579@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/05/18 16:26, Jasmin J. wrote:
> Hello Hans!
> 
>> linux-4.9.91-x86_64: ERRORS
>> /home/hans/work/build/media_build/v4l/dw9807.c:321:3: error
> The build works in my tree ... ?!?
> I can't find the file in media_tree:
>    find . -name "*9807*"
> 
> Can you please check if there is something wrong with your
> media_tree version which is used for the daily build.
> I have 8ed8bba70b43 as top commit.

Hmm, I wonder if Mauro rebased the tree. Anyway, I've fixed this.

> 
> And another thing:
>  ./prepare_kernel.sh 3.2 x86_64
> fails with
>  fatal error: linux/compiler-gcc8.h: No such file or directory
> this leads to a build error in the daily build also.

Copied compiler-gcc7.h to compiler-gcc8.h, so be OK now.

Regards,

	Hans

> 
> BR,
>    Jasmin
> 
