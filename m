Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04680C31680
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3060217D4
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhMbxlAJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfAUSny (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:43:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40381 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfAUSny (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:43:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so24587118wrt.7;
        Mon, 21 Jan 2019 10:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=FHN5/PCe3aat40H4Gv9HHjgJcOmlJGmHzaX3d+taWhk=;
        b=ZhMbxlAJXdSCgajmyTpA11w57eZNlsxBHBEk8LJ5f14iV8FjOrn+F26Rw09+z9rgG+
         qhEf8l6N832Ygxw5sGyh5XI5y/LkQbdsEZxapQpW5+sT9gHzMUFqvZ+6vYwcaoCIf2Aw
         UeLTs68pLUihce2bZhre9NrsJczlTGftBFzil1hczNkSSGA5tko0eSn2kniy6DVV3jfK
         X5vaE5D144/1nWltnTyL/njV5YEnfENtSycXBguI2Lsy9i68KCY+MTIKoN9pGWUZxNnh
         mQAFfYqcHv7JABW2ioGESfS7HtdP2rypYp0NEh2Bel+w10mfcfv5hKXrLmUxeaNEQezY
         9npA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FHN5/PCe3aat40H4Gv9HHjgJcOmlJGmHzaX3d+taWhk=;
        b=Kue6oNxyTt13XMyxsb0AZgb8t38DwP5SGMRzvv3gTfDKoj69AyZKl8g9Ocl1Kj81IX
         EM9e+5O3btJnF1hoBq9sM64skdyM8mYFIXaTU54FMVnKAcW82HdIWs9UXFOHvKFYplpl
         NDy1HXIHRsSZBdBO2u52fW1Qbw7HZJoWNN1KFVM1k4v0ThXqf/rbJ8PbUKvON9dlr4z+
         jl2l5VwhXlz46XL/RJMYajJq4V42MBDYOuYrXdN5qhmcx2vs4MsrdkfqaKrfWMytUAbi
         nMyQOlG81kq9vILfUkGdO7c4iqnAoXrxnQMFCykYSKQM1tSRDZOyJZni2hJLGJ9tLven
         /m3w==
X-Gm-Message-State: AJcUukdoVD4QIbMzJvShLQAJKZXh5V76NFEzn46SKB7UOxvTVMtdcGeb
        qclLkdOhcVl16663TmLVnBT3EZyj
X-Google-Smtp-Source: ALg8bN48p05FIUHHXogHd1ypRPLcSwHWr+dxAxnDGUAxzv583spSd/KFie4KUfW1M9caXlxFCS/AKw==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr28018363wrv.308.1548096231344;
        Mon, 21 Jan 2019 10:43:51 -0800 (PST)
Received: from [172.30.88.24] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id c65sm50413180wma.24.2019.01.21.10.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:43:50 -0800 (PST)
Subject: Re: [PATCH v3 1/2] media: imx: csi: Disable SMFC before disabling
 IDMA channel
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Gael PORTAY <gael.portay@collabora.com>,
        Peter Seiderer <ps.report@gmx.net>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190119010457.2623-1-slongerbeam@gmail.com>
 <20190119010457.2623-2-slongerbeam@gmail.com>
 <1548071350.3287.3.camel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <7432d18b-12fc-34c6-832f-576fc1b8e2e8@gmail.com>
Date:   Mon, 21 Jan 2019 10:43:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1548071350.3287.3.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/21/19 3:49 AM, Philipp Zabel wrote:
> Hi,
>
> On Fri, 2019-01-18 at 17:04 -0800, Steve Longerbeam wrote:
>> Disable the SMFC before disabling the IDMA channel, instead of after,
>> in csi_idmac_unsetup().
>>
>> This fixes a complete system hard lockup on the SabreAuto when streaming
>> from the ADV7180, by repeatedly sending a stream off immediately followed
>> by stream on:
>>
>> while true; do v4l2-ctl  -d4 --stream-mmap --stream-count=3; done
>>
>> Eventually this either causes the system lockup or EOF timeouts at all
>> subsequent stream on, until a system reset.
>>
>> The lockup occurs when disabling the IDMA channel at stream off. Stopping
>> the video data stream entering the IDMA channel before disabling the
>> channel itself appears to be a reliable fix for the hard lockup. That can
>> be done either by disabling the SMFC or the CSI before disabling the
>> channel. Disabling the SMFC before the channel is the easiest solution,
>> so do that.
>>
>> Fixes: 4a34ec8e470cb ("[media] media: imx: Add CSI subdev driver")
>>
>> Suggested-by: Peter Seiderer <ps.report@gmx.net>
>> Reported-by: Gaël PORTAY <gael.portay@collabora.com>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Gaël, could we get a Tested-by: for this as well?
>
>> Cc: stable@vger.kernel.org
>> ---
>> Changes in v3:
>> - switch from disabling the CSI before the channel to disabling the
>>    SMFC before the channel.
>> Changes in v2:
>> - restore an empty line
>> - Add Fixes: and Cc: stable
>> ---
>>   drivers/staging/media/imx/imx-media-csi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
>> index e18f58f56dfb..8610027eac97 100644
>> --- a/drivers/staging/media/imx/imx-media-csi.c
>> +++ b/drivers/staging/media/imx/imx-media-csi.c
>> @@ -560,8 +560,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>>   static void csi_idmac_unsetup(struct csi_priv *priv,
>>   			      enum vb2_buffer_state state)
>>   {
>> -	ipu_idmac_disable_channel(priv->idmac_ch);
>>   	ipu_smfc_disable(priv->smfc);
>> +	ipu_idmac_disable_channel(priv->idmac_ch);
> Steve, do you have any theory why this helps? It's a bit weird to
> disable the SMFC module while the DMA channel is still enabled.

It does fix the hang, but I only have a vague theory as to why. That by 
disabling the DMA channel while its internal FIFO is getting filled is 
causing the hang, maybe due to a simultaneous update of the channel's 
internal FIFO write pointer and the channel disable bit. By disabling 
the SMFC (or the CSI), writes to the channel's internal FIFO stop.

>   I think
> this warrants a big comment, given that enable order is SMFC_EN before
> IDMAC channel enable.
>
> Also ipu_smfc_disable is refcounted, so if the other CSI is capturing
> simultaneously, this change has no effect.

Sigh, you're right. Let me go back to disabling the CSI before the 
channel, the CSI enable/disable is not refcounted (it doesn't need to be 
since it is single use) so it doesn't have this problem.

Should we drop this patch or keep it (with a big comment)? By only 
changing the disable order to "CSI then channel", the hang is reliably 
fixed from my and Gael's testing, but my concern is that by not 
disabling the SMFC before the channel, the SMFC could still empty its 
FIFO to the channel's internal FIFO and still create a hang.

Steve

