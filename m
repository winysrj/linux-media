Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44247 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753307AbdLNRJR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:09:17 -0500
Received: by mail-pf0-f194.google.com with SMTP id m26so4034598pfj.11
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 09:09:17 -0800 (PST)
Subject: Re: [GIT PULL FOR v4.16] media: imx: Add better OF graph support
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4fa72331-0b80-1df6-ed58-d907e585bd50@xs4all.nl>
 <20171208143801.14319617@vento.lan>
 <ae03ac33-198d-a641-d021-33b2a9238a70@gmail.com>
 <bfd31c3b-bf80-b658-02e6-3af2abbb37a2@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <afe9be18-a281-a9d3-70af-0f4026bc5eba@gmail.com>
Date: Thu, 14 Dec 2017 09:09:12 -0800
MIME-Version: 1.0
In-Reply-To: <bfd31c3b-bf80-b658-02e6-3af2abbb37a2@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/14/2017 04:13 AM, Hans Verkuil wrote:
> On 08/12/17 23:48, Steve Longerbeam wrote:
>>
>> On 12/08/2017 08:38 AM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 8 Dec 2017 11:56:58 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> Note: the new v4l2-async work makes it possible to simplify this. That
>>>> will be done in follow-up patches. It's easier to do that if this is in
>>>> first.
>>>>
>>>> Regards,
>>>>
>>>>      Hans
>>>>
>>>> The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:
>>>>
>>>>     media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>     git://linuxtv.org/hverkuil/media_tree.git imx
>>>>
>>>> for you to fetch changes up to 82737cbb02f269b8eb608c7bd906a79072f6adad:
>>>>
>>>>     media: staging/imx: update TODO (2017-12-04 14:05:19 +0100)
>>>>
>>>> ----------------------------------------------------------------
>>>> Steve Longerbeam (9):
>>>>         media: staging/imx: get CSI bus type from nearest upstream entity
>>> There are some non-trivial conflicts on this patch.
>>> Care to rebase it?
>> Attached is fixed-up version.
> That still doesn't apply against the latest media_tree master.

Yeah, more merge conflicts from latest commits. I will just post a new
series.

Steve
