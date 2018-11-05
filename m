Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36793 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728973AbeKEWb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 17:31:59 -0500
Subject: Re: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap drivers
To: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
        tfiga@chromium.org
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <CAB_H8ru9KzstY4-qByAdfNKeDW23U93e0TRc71-knmrDOike4g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <058d84c9-38fd-3fb8-83bd-fb31e1e79042@xs4all.nl>
Date: Mon, 5 Nov 2018 14:12:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAB_H8ru9KzstY4-qByAdfNKeDW23U93e0TRc71-knmrDOike4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 11/02/2018 05:16 PM, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On Fri, 5 Oct 2018 at 09:49, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch series converts the last remaining drivers that use g/s_crop and
>> cropcap to g/s_selection.
> 
> Thank you for this clean up! I remember attempting conversion of those remaining
> drivers to selection API long time ago but I didn't have a good idea
> then how to address
> that crop and compose target inversion mess so I abandoned that efforts then.

Thank you for the review. One question: have you also tested this with at least
one of the affected drivers?

I'd like to have at least one Tested-by line.

Regards,

	Hans
