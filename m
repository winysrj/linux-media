Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822FBC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 474A521479
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544110402;
	bh=oZay8sKemTn/mmuYoPe+FoNPQnrMLMl+aHG9oz4Mi5M=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=yDE0SiU7sHBiFlx1pR+FXgNOcjZF77nbblPhzT/rKITT4M9gSwHTKJaQg2F5Y7945
	 5w1DILWLkDED+DYSL1PDmBkBGVfb0y4+2gStQAUC9eNNMeDiv1ZfD9pnJiN9F9apus
	 WYLnUrlZ3dBsGKx2VYlvwaLumVRnphrZ9JHepFr8=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 474A521479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbeLFPdQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbeLFPdQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 10:33:16 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F68720989;
        Thu,  6 Dec 2018 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544110395;
        bh=oZay8sKemTn/mmuYoPe+FoNPQnrMLMl+aHG9oz4Mi5M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=112gr6qTJ96jz/iURdZ2/Wij8t7IWp+iYeqylm5s/s+hcy484GpDBPTLjIyUaSSbW
         Rqfl6EUrnzaW7UDuoPk4+r0h79RKXQiQhNmuzzqteNne9fJsf/T6ZPy45Rx6bOD8A/
         gsZTDhPTIrN+bPf317xouNZgAmQPi9ASDwGffh8M=
Subject: Re: [RFC PATCH v8 1/4] media: Media Device Allocator API
To:     Pavel Machek <pavel@ucw.cz>
Cc:     mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1541109584.git.shuah@kernel.org>
 <e474dd16f1d6443c12b1361376193c9d0efcced6.1541109584.git.shuah@kernel.org>
 <20181119085931.GA28607@amd>
From:   shuah <shuah@kernel.org>
Message-ID: <73c22137-9c7a-75c8-8cd1-3736c63c2d40@kernel.org>
Date:   Thu, 6 Dec 2018 08:33:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181119085931.GA28607@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 11/19/18 1:59 AM, Pavel Machek wrote:
> On Thu 2018-11-01 18:31:30, shuah@kernel.org wrote:
>> From: Shuah Khan <shuah@kernel.org>
>>
>> Media Device Allocator API to allows multiple drivers share a media device.
>> Using this API, drivers can allocate a media device with the shared struct
>> device as the key. Once the media device is allocated by a driver, other
>> drivers can get a reference to it. The media device is released when all
>> the references are released.
> 
> Sounds like a ... bad idea?
> 
> That's what new "media control" framework is for, no?
> 
> Why do you need this?
> 								Pavel
> 

Media control framework doesn't address this problem of ownership of the 
media device when non-media drivers have to own the pipeline. In this 
case, snd-usb owns the audio pipeline when an audio application is using 
the device. Without this work, media drivers won't be able to tell if 
snd-usb is using the tuner and owns the media pipeline.

I am going to clarify this in the commit log.

thanks,
-- Shuah
