Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:59518 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755792AbeFOIBb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 04:01:31 -0400
Subject: Re: [PATCH v3 00/20] v4l2 core: push ioctl lock down to ioctl handler
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com, Abylay Ospan <aospan@netup.ru>
References: <20180524203520.1598-1-ezequiel@collabora.com>
 <bcb16fa2-e915-9329-de37-3bbdddd84f30@xs4all.nl>
 <fc4b8760c8f61fcee758b28574d25bd0143f90ce.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ea748445-2987-0f15-0230-53cc6f54a204@xs4all.nl>
Date: Fri, 15 Jun 2018 10:01:27 +0200
MIME-Version: 1.0
In-Reply-To: <fc4b8760c8f61fcee758b28574d25bd0143f90ce.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/18 15:24, Ezequiel Garcia wrote:
> On Fri, 2018-06-08 at 14:11 +0200, Hans Verkuil wrote:
>> Hi Ezequiel,
>>
>> On 05/24/2018 10:35 PM, Ezequiel Garcia wrote:
>>> Third spin of the series posted by Hans:
>>>
>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg131363.html
>>
>> Can you rebase this? Several patches have already been merged, so it would
>> be nice to have a new clean v4. Can you also move patch 11/20 (dvb-core) to
>> after patch 16/20? It makes it a bit easier for me to apply the patches before
>> that since the dvb patch needs an Ack from Mauro at the very least.
>>
>> But I can take the v4l patches, that should be no problem.
>>
>>
> 
> No problem.

Haven't seen a v4 yet. I'm processing patches today and Monday, so if I have
a clean patch series I can merge most of it quickly.

Regards,

	Hans
