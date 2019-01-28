Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B47C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FEE621783
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 23:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548719336;
	bh=T1JDq569bCa0/O5mBZjLGYp4h1D1NWq0r8sxhNDCcMA=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=GNr4K6LM1BpjqcmQE8szq2kvG5Fjd+7c7FoZ3kgzvpeYLMeLOHmngtBO0TK2PaAtU
	 ywUOEjCeBYZYziitP+voFvOfr2O+qt1BvashRstptP0QURiCH8zy65jlAwN6TSF/mG
	 Ref4dul6AC18PIZucf941UufUJaHS5Z8ISAznlR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfA1Xsv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 18:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfA1Xsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 18:48:51 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510172171F;
        Mon, 28 Jan 2019 23:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548719330;
        bh=T1JDq569bCa0/O5mBZjLGYp4h1D1NWq0r8sxhNDCcMA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fXscI4SdJeERU8D6a9kuQE3hwveJK+EAuVzcTPjiEK9QLxHlmGBOJI5y4hhLK/MRQ
         U7ZZydhToGojnem53lL8YrTJSOsYkIsHPQfJGvwFmGQtYtZ05ol/wF3ql9RqRQbmUs
         uxl/TAicsLSlbvnmGyjO2bcnSxjQxBcoxddAJGK4=
Subject: Re: [PATCH v10 0/4] Media Device Allocator API
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1548360791.git.shuah@kernel.org>
 <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <481787e7-112a-80dd-228c-2497a12547b9@kernel.org>
Date:   Mon, 28 Jan 2019 16:48:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <e8717d11-1eff-2e07-53d5-6cd55356c66a@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 1/28/19 5:03 AM, Hans Verkuil wrote:
> Hi Shuah,
> 
> On 1/24/19 9:32 PM, Shuah Khan wrote:
>> Media Device Allocator API to allows multiple drivers share a media device.
>> This API solves a very common use-case for media devices where one physical
>> device (an USB stick) provides both audio and video. When such media device
>> exposes a standard USB Audio class, a proprietary Video class, two or more
>> independent drivers will share a single physical USB bridge. In such cases,
>> it is necessary to coordinate access to the shared resource.
>>
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
>>
>> - This patch series is tested on 5.0-rc3 and addresses comments on
>>    v9 series from Hans Verkuil.
>> - v9 was tested on 4.20-rc6.
>> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>>    arecord. When analog is streaming, digital and audio user-space
>>    applications detect that the tuner is busy and exit. When digital
>>    is streaming, analog and audio applications detect that the tuner is
>>    busy and exit. When arecord is owns the tuner, digital and analog
>>    detect that the tuner is busy and exit.
> 
> I've been doing some testing with my au0828, and I am confused about one
> thing, probably because it has been too long ago since I last looked into
> this in detail:
> 

Great.

> Why can't I change the tuner frequency if arecord (and only arecord) is
> streaming audio? If arecord is streaming, then it is recording the audio
> from the analog TV tuner, right? So changing the analog TV frequency
> should be fine.
> 

Changing analog TV frequency would be s_frequency. The way it works is
any s_* calls would require holding the pipeline. In Analog TV case, it
would mean holding both audio and video pipelines for any changes
including TV.

As I recall, we discussed this design and the decision was to make all
s_* calls interfaces to hold the tuner. A special exception is g_tuner
in case of au0828. au0828 initializes the tuner from s_* interfaces and
its g_tuner interfaces. Allowing s_frequency to proceed will disrupt the
arecord audio stream.

Query (q_*) works just fine without holding the pipeline. I limited the
analog holds to just the ones that are required. The current set is
required to avoid audio stream disruptions.

I made sure v4l-ctl --all works when the pipeline is locked by any one
of the 3 (audio, video, DVB).

Hope this helps.

thanks,
-- Shuah


