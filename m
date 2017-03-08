Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58818 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752266AbdCHNqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 08:46:14 -0500
Subject: Re: [PATCH] atomisp2: unify some ifdef cases caused by format changes
To: Greg KH <greg@kroah.com>
References: <148879924465.10733.17814546240558419917.stgit@acox1-desk1.ger.corp.intel.com>
 <90583522-0afb-e556-b1a6-dea0efc5392d@xs4all.nl>
 <20170308133947.GB5221@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b13609bf-0e14-685a-01a7-0ba88e15db8c@xs4all.nl>
Date: Wed, 8 Mar 2017 14:45:35 +0100
MIME-Version: 1.0
In-Reply-To: <20170308133947.GB5221@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/17 14:39, Greg KH wrote:
> On Wed, Mar 08, 2017 at 01:49:23PM +0100, Hans Verkuil wrote:
>> OK, so I discovered that these patches are for a driver added to linux-next
>> without it ever been cross-posted to linux-media.
>>
>> To be polite, I think that's rather impolite.
>
> They were, but got rejected due to the size :(
>
> Mauro was cc:ed directly, he knew these were coming...
>
> I can take care of the cleanup patches for now, you don't have to review
> them if you don't want to.

Please do.

For the next time if the patches are too large: at least post a message with
a link to a repo for people to look at. I would like to know what's going
on in staging/media, especially since I will do a lot of the reviewing (at
least if it is a V4L2 driver) when they want to move it out of staging.

Thanks,

	Hans
