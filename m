Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB2CC04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15A1421479
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544110162;
	bh=1NFOhZvaIk9JpC9e78wXlet8uKg3wctLID0Ajn1928g=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:List-ID:From;
	b=LPwBHgrPJsSFCLmzYc/UY2f+h/TrhNz7UvMo7uxVYKzlHHSNlFzsB2Qh9XeOXIl08
	 fOn3a5ZKS8LbVt3K7tHJ4da3rECsTAQtzQR1Gt7+C6d4uXvktt3OwLCVcy8sKtMilm
	 VJ3TTAzJP5FJq1nHSlMSqollbLNalMUXj+Bk3aAc=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15A1421479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbeLFP3Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbeLFP3Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 10:29:16 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B7DE20878;
        Thu,  6 Dec 2018 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544110155;
        bh=1NFOhZvaIk9JpC9e78wXlet8uKg3wctLID0Ajn1928g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qKnE2guRFUgBv0YRtoscuv5RdN2Jw3QJc7RtKXN/Yw6ErgAQrFMdJbRPkklgTQjBM
         oyMeY/K4X7oqDtIJY6CEeu/cNjVW+Xp3x6X8Pq7QMarQUu9Hvp0E1j05pjZ/SYIVke
         6ThS4PlKinfM470Dn8GwWAXTtBPertw0/z/DRtKM=
Subject: Re: [RFC PATCH v8 3/4] media: media.h: Enable ALSA MEDIA_INTF_T*
 interface types
To:     Hans Verkuil <hverkuil@xs4all.nl>, mchehab@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, shuah <shuah@kernel.org>
References: <cover.1541118238.git.shuah@kernel.org>
 <0f47952fd84fd275646e3c9a18e208ced08dd6bb.1541109584.git.shuah@kernel.org>
 <76e1a986-fb47-869d-ee7e-8c9b919718cb@xs4all.nl>
From:   shuah <shuah@kernel.org>
Message-ID: <bfab725e-f283-cb71-f1df-d6444b7b81f7@kernel.org>
Date:   Thu, 6 Dec 2018 08:29:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <76e1a986-fb47-869d-ee7e-8c9b919718cb@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On 11/20/18 4:22 AM, Hans Verkuil wrote:
> On 11/02/2018 01:31 AM, shuah@kernel.org wrote:
>> From: Shuah Khan <shuah@kernel.org>
>>
>> Move ALSA MEDIA_INTF_T* interface types back into __KERNEL__ scope
>> to get ready for adding ALSA support to the media controller.
>>
>> Signed-off-by: Shuah Khan <shuah@kernel.org>
>> ---
>>   include/uapi/linux/media.h | 25 ++++++++++---------------
>>   1 file changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 36f76e777ef9..07be07263597 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -262,6 +262,16 @@ struct media_links_enum {
>>   #define MEDIA_INTF_T_V4L_SWRADIO		(MEDIA_INTF_T_V4L_BASE + 4)
>>   #define MEDIA_INTF_T_V4L_TOUCH			(MEDIA_INTF_T_V4L_BASE + 5)
>>   
>> +#define MEDIA_INTF_T_ALSA_BASE			0x00000300
>> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE		(MEDIA_INTF_T_ALSA_BASE)
>> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK		(MEDIA_INTF_T_ALSA_BASE + 1)
>> +#define MEDIA_INTF_T_ALSA_CONTROL		(MEDIA_INTF_T_ALSA_BASE + 2)
>> +#define MEDIA_INTF_T_ALSA_COMPRESS		(MEDIA_INTF_T_ALSA_BASE + 3)
>> +#define MEDIA_INTF_T_ALSA_RAWMIDI		(MEDIA_INTF_T_ALSA_BASE + 4)
>> +#define MEDIA_INTF_T_ALSA_HWDEP			(MEDIA_INTF_T_ALSA_BASE + 5)
>> +#define MEDIA_INTF_T_ALSA_SEQUENCER		(MEDIA_INTF_T_ALSA_BASE + 6)
>> +#define MEDIA_INTF_T_ALSA_TIMER			(MEDIA_INTF_T_ALSA_BASE + 7)
>> +
> 
> I would only enable those defines that you need for the next patch.
> 

Good plan. I fixed this to move just the ones I need for this work.

thanks,
-- Shuah
