Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab1L3QpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 11:45:10 -0500
Message-ID: <4EFDEA8E.4070603@redhat.com>
Date: Fri, 30 Dec 2011 14:45:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com> <4EFDE8A6.5080903@gmail.com>
In-Reply-To: <4EFDE8A6.5080903@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30-12-2011 14:36, Sylwester Nawrocki wrote:
> Hi Mauro,
> 
> On 12/30/2011 04:06 PM, Mauro Carvalho Chehab wrote:
>> This patch series comes after the previous series of 47 patches.
>> Basically, changes all DVB frontend drivers to work directly with
>> the DVBv5 structure. This warrants that all drivers will be
> 
> Is there any git tree available with all these patches ? It would be easier
> to pull rather than applying almost 150 patches. :) I know I don't need
> them all, but just to be sure I have all the relevant changes in place for
> testing.

Forgot to mention, and to update them on my tree. The latest version are at
the branch "DVB_v5_v5" on my experimental tree:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/DVB_v5_v5

(yeah, I know: the name become weird... It were "DVB_v5", meaning DVB API v5,
 then, for each rebase, I added a new branch there)


> 
> --
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

