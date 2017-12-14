Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48144 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751755AbdLNMNN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 07:13:13 -0500
Subject: Re: [GIT PULL FOR v4.16] media: imx: Add better OF graph support
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <4fa72331-0b80-1df6-ed58-d907e585bd50@xs4all.nl>
 <20171208143801.14319617@vento.lan>
 <ae03ac33-198d-a641-d021-33b2a9238a70@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bfd31c3b-bf80-b658-02e6-3af2abbb37a2@xs4all.nl>
Date: Thu, 14 Dec 2017 13:13:10 +0100
MIME-Version: 1.0
In-Reply-To: <ae03ac33-198d-a641-d021-33b2a9238a70@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/17 23:48, Steve Longerbeam wrote:
> 
> 
> On 12/08/2017 08:38 AM, Mauro Carvalho Chehab wrote:
>> Em Fri, 8 Dec 2017 11:56:58 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> Note: the new v4l2-async work makes it possible to simplify this. That
>>> will be done in follow-up patches. It's easier to do that if this is in
>>> first.
>>>
>>> Regards,
>>>
>>>     Hans
>>>
>>> The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:
>>>
>>>    media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)
>>>
>>> are available in the git repository at:
>>>
>>>    git://linuxtv.org/hverkuil/media_tree.git imx
>>>
>>> for you to fetch changes up to 82737cbb02f269b8eb608c7bd906a79072f6adad:
>>>
>>>    media: staging/imx: update TODO (2017-12-04 14:05:19 +0100)
>>>
>>> ----------------------------------------------------------------
>>> Steve Longerbeam (9):
>>>        media: staging/imx: get CSI bus type from nearest upstream entity
>> There are some non-trivial conflicts on this patch.
>> Care to rebase it?
> 
> Attached is fixed-up version.

That still doesn't apply against the latest media_tree master.

Regards,

	Hans
