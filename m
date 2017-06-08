Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:53459 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750937AbdFHK4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 06:56:32 -0400
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Alexandre Courbot <acourbot@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
References: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com>
 <816ba2d8-f1e7-ce34-3524-b2a3f1bf3d74@xs4all.nl>
 <fb4a4815-e1ff-081e-787a-0213e32a5405@st.com>
 <8f93f4f2df49431cb2750963c2f7b168@SFHDAG5NODE2.st.com>
 <48b04997-bd80-5640-4272-2c4d69c25a97@st.com>
 <CACHYQ-pb9tRaWq9c0h7OXTmpUVH16i3d6-8B_Y+YSzAqWGPEqA@mail.gmail.com>
 <CAPBb6MWtOaOKm5aaRTx2afFW=NOBk_NZz6-d2JiUS2DtXaW_EQ@mail.gmail.com>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>,
        "florent.revest@free-electrons.com"
        <florent.revest@free-electrons.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "randy.li@rock-chips.com" <randy.li@rock-chips.com>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0dfd7fb-112a-a395-452d-5bc15e1edb06@xs4all.nl>
Date: Thu, 8 Jun 2017 12:56:29 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWtOaOKm5aaRTx2afFW=NOBk_NZz6-d2JiUS2DtXaW_EQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

On 08/06/17 11:59, Alexandre Courbot wrote:
> On Thu, Jun 8, 2017 at 5:56 PM, Pawel Osciak <posciak@chromium.org> wrote:
>> Hi,
>>
>> On Fri, May 19, 2017 at 1:08 AM, Hugues FRUCHET <hugues.fruchet@st.com> wrote:
>>> Before merging this work Hans would like to have feedback from peers, in
>>> order to be sure that this is inline with other SoC vendors drivers
>>> expectations.
>>>
>>> Thomasz, Pawel, could you give your view regarding ChromeOS and Rockchip
>>> driver ?
>>
>> The drivers for Rockchip codecs are submitted to the public Chromium OS kernel
>> and working on our RK-based platforms. We have also since added a VP9 API as
>> well, which is also working on devices that support it. This gives us
>> a set of H.264,
>> VP8 and VP9 APIs on both kernel and userspace side (in the open source
>> Chromium browser) that are working currently and can be used for
>> further testing.
>>
>> We are interested in merging the API patches as well as these drivers upstream
>> (they were posted on this list two years ago), however we've been blocked by the
>> progress of request API, which is required for this. Alexandre Courbot
>> is currently
>> looking into creating a minimal version of the request API that would provide
>> enough functionality for stateless codecs, and also plans to further work on
>> re-submitting the particular codec API patches, once the request API
>> is finalized.
> 
> Hi everyone,
> 
> It is a bit scary to start hacking on V4L with something as disruptive
> as the request API, so please bear with me as I will inevitably post
> code that will go from cutely clueless to downright offensive.

Yeah, you went straight into the deep end of the pool :-)

I am very, very pleased to see Google picking up this work. We need more
core V4L2 developers, so welcome!

> Thankfully Pawel is not too far from my desk, and we (Pawel, Tomasz
> and myself) had a very fruitful in-person brainstorming session last
> week with Laurent, so this should limit the damage.
> 
> In any case, I think that everybody agrees that this needs to be
> pushed forward. Chromium OS in particular has a big interest to see
> this feature landing upstream, so I will dedicate some cycles to this.

Absolutely!

> From reading the meetings reports (e.g.
> https://www.spinics.net/lists/linux-media/msg106699.html) I understand
> that we want to support several use-cases with this and we already
> have several proposals with code. Chromium in a first time is
> interested in stateless codecs support, and this use-case also seems
> to be the simplest to implement, so we would like to start pushing in
> that direction first. This should give us a reasonably sized code base
> to rely upon and implement the other use-cases as we see clearer
> through this.
> 
> I still need to study a bit the existing proposals and to clearly lay
> out the conclusions of our meeting with Laurent, but the general idea
> has not changed too much, except maybe that we thought it may be nice
> to make state management less explicit to userspace by default. I
> would be interested in knowing whether there are updated versions of
> the implementations mentioned in the meeting report above, and/or a
> merge of these work? Also, if someone is actively working on this at
> the moment, we will definitely want to sync on IRC or anywhere else.

Laurent has been the last one working on this, but his code doesn't have
the control handling :-(

My latest (well, December 2015) tree with the control request code
is here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=requests2

It's AFAIK a slightly newer version from what ChromeOS uses.

> Excited to work with you all! :)

Looking forward to your code!

Regards,

	Hans
