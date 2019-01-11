Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB12C43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 14:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB8E20874
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547218688;
	bh=vM62qAnFecUmuvbBauVtw/rgXu/Ayyo1Tcq01BHNOqc=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=a3wLqJ9fXzK2Hec/q8/pIVw9JHesFN0T7NsUlzIojMsXg3kV/PvKxM19EexoNQu7f
	 uSLtA1zVb7lZDrpKtQwzPiJB9fCflosGMIxT6VznxWEzDOLOIEFxR2vO+CIV51+3x2
	 xZcZYg6pIdrteUWPWpEv3jwYGDiHPyuELreGfygI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390349AbfAKO6B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732297AbfAKO6B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 09:58:01 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F31A20872;
        Fri, 11 Jan 2019 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547218680;
        bh=vM62qAnFecUmuvbBauVtw/rgXu/Ayyo1Tcq01BHNOqc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=H+c8H2xbBV2GJbv6W8q0tntOtku01zGG3Us1bbygJhgUYmD0mTG91Litxfekc/pp2
         h6enL8vWpYlg7d+P34tYkXRHqDCpkIvBp1mlcZR6cvJPx3Q6BrqApm5A1D7CNoorNX
         FStvnL1VwIjf/XTCFf822Wo7d7CE9+17EOv4Jk7o=
Subject: Re: [alsa-devel] [PATCH v9 4/4] sound/usb: Use Media Controller API
 to share media resources
To:     mchehab@kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, perex@perex.cz, tiwai@suse.com,
        hverkuil@xs4all.nl, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <cover.1545154777.git.shuah@kernel.org>
 <2fb40852e4035b2a58010ce7416448918f12804f.1545154778.git.shuah@kernel.org>
 <s5hefadbp5m.wl-tiwai@suse.de>
From:   shuah <shuah@kernel.org>
Message-ID: <5f9588b5-657a-78ee-9614-ed0ef1fc5839@kernel.org>
Date:   Fri, 11 Jan 2019 07:57:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <s5hefadbp5m.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/19/18 6:51 AM, Takashi Iwai wrote:
> On Tue, 18 Dec 2018 18:59:39 +0100,
> shuah@kernel.org wrote:
>>
>> From: Shuah Khan <shuah@kernel.org>
>>
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
>> Change the ALSA driver to use the Media Controller API to share media
>> resources with DVB, and V4L2 drivers on a AU0828 media device.
>>
>> The Media Controller specific initialization is done after sound card is
>> registered. ALSA creates Media interface and entity function graph nodes
>> for Control, Mixer, PCM Playback, and PCM Capture devices.
>>
>> snd_usb_hw_params() will call Media Controller enable source handler
>> interface to request the media resource. If resource request is granted,
>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>> returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuah@kernel.org>
> 
> Feel free to take my ack regarding the sound stuff:
>    Reviewed-by: Takashi Iwai <tiwai@suse.de>
> 
> 
> Thanks!
> 
> Takashi
> 

Hi Mauro,

Any update on this patch series?

thanks,
-- Shuah
