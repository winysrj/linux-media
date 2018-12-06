Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614A6C64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2512C214F1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544110504;
	bh=s6WY+tz5c2+iQ4QYO3iULWxTQFADQnGBAVuv6cbweuQ=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=fks79S4rf9OBB4e+nTo9hsIvzkO3vTG/tlBEp8QfHhhOE8GHE8E6xxnNcD8rhP8ga
	 JVix8oIQBy8Gwd+px38ElzKPsxguKMlHPQZrdRFCF/M2CrYyHREyU69Xoagn1GRpHj
	 5nGnFU20EZ9iCUNRRzaDbw14n67ykjReNqtYBJZU=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2512C214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbeLFPe7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbeLFPe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 10:34:59 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F4F821479;
        Thu,  6 Dec 2018 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544110498;
        bh=s6WY+tz5c2+iQ4QYO3iULWxTQFADQnGBAVuv6cbweuQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dLU9M3MP0sQIITtAPC46Bdgv7+xQCcDQpwfsmnbWmzw9EksexUHwtFFFff9WODOhY
         EaBz4lJi+nMxnt5dV1oUONtNVcyzHtXYtg4Lt6mhmkvDwPfSoc6i2UTkA9OLxVRJc7
         3S5gObvzs9jMIKbZuv39IRGR433iUyYMc8b66isA=
Subject: Re: [RFC PATCH v8 4/4] sound/usb: Use Media Controller API to share
 media resources
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1541118238.git.shuah@kernel.org>
 <ba3bb65b4250fa470c7319d50ebdf1047793efad.1541109584.git.shuah@kernel.org>
 <0b919080-669a-a266-c85c-66dc724a536b@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <3aef49a1-2dd7-c6c6-7c2e-5ba3cc76a695@kernel.org>
Date:   Thu, 6 Dec 2018 08:34:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <0b919080-669a-a266-c85c-66dc724a536b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 11/20/18 4:54 AM, Hans Verkuil wrote:
> On 11/02/2018 01:31 AM, shuah@kernel.org wrote:
>> From: Shuah Khan <shuah@kernel.org>
>>
>> Change ALSA driver to use Media Controller API to share media resources
>> with DVB, and V4L2 drivers on a AU0828 media device.
>>
>> Media Controller specific initialization is done after sound card is
>> registered. ALSA creates Media interface and entity function graph
>> nodes for Control, Mixer, PCM Playback, and PCM Capture devices.
>>
>> snd_usb_hw_params() will call Media Controller enable source handler
>> interface to request the media resource. If resource request is granted,
>> it will release it from snd_usb_hw_free(). If resource is busy, -EBUSY is
>> returned.
>>
>> Media specific cleanup is done in usb_audio_disconnect().
>>
>> Signed-off-by: Shuah Khan <shuah@kernel.org>

Thanks for the review. Fixing them all in the next revision.

-- Shuah

