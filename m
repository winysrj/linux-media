Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34703 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbbLBOJc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 09:09:32 -0500
Received: by ioir85 with SMTP id r85so46331405ioi.1
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2015 06:09:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <565EE51C.2010509@xs4all.nl>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
	<1411310909-32825-5-git-send-email-hverkuil@xs4all.nl>
	<20141114154433.GF8907@valkosipuli.retiisi.org.uk>
	<5469B5EF.6070408@xs4all.nl>
	<CAFqH_52f6Nh7LsjpkWavFXUAMDMqHX3E4DFYzMGonHDzucsasA@mail.gmail.com>
	<565EE51C.2010509@xs4all.nl>
Date: Wed, 2 Dec 2015 15:09:31 +0100
Message-ID: <CAFqH_50PpEha6ms+LoNXCb_d5vetPWNitkZX7a+qDRVw2pq3jg@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] v4l2-ctrls: add config store support
From: Enric Balletbo Serra <eballetbo@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	pawel@osciak.com, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2015-12-02 13:33 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 12/02/15 13:03, Enric Balletbo Serra wrote:
>> Dear Hans,
>>
>> We've a driver that uses your confstore stuff and we'd like to push
>> upstream. I'm wondering if there is any plan to upstream the confstore
>> patches or if this was abandoned for some reason. Thanks
>
> Ouch, that's really old code you're using.
>
> The latest version is here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=requests
>
> But that too won't be the final version.
>
> There is still work going on in this area (specifically by Laurent Pinchart)
> since we really need this functionality. But we need to make sure that the
> API is good enough to handle complex hardware before it can be upstreamed.
>
> I suspect that once Laurent has it working for his non-trivial use-case we
> can start looking at upstreaming it.
>
> I recommend rebasing to at least the version in my git tree as that will
> be much closer to the final version. I'll try to rebase that branch to
> the latest kernel, but that's a bit difficult and takes more time than I
> have at the moment.
>

Thanks to point me in the right direction.

Regards,
    Enric

> Regards,
>
>         Hans
