Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7683C10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 11:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A95C20851
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 11:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIP9twyf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCGLZk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:25:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42884 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfCGLZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 06:25:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id r5so16975587wrg.9;
        Thu, 07 Mar 2019 03:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VT+D2bCwr7paAn9CPq2Pst56j1rUGa0sbNZq6zVIofI=;
        b=IIP9twyfmljK2dvGrYoKYsrVIURkHbYG1om6i2E1onN1GiHCdY/Rp4IQ+ndfKNq8Jv
         RxCPvvFKvKz5650EOBkzo0lRTmjZ8Q/PwP4OVNPZ7hL5F1tscso56tOd+ZkYbVRuWPz4
         gb8Ko2pLo3c2GP+dtl2kULXflVKZQ7iyCn31BBn+9W97ZLq5nmLeKTAuKHtn7QyLFSO2
         Qc6+Axi2dX3sgKl88Jm8jfbdR9yMTlf7XxkaHkGViOWK4Me3vSZK0pbR/ukNmVn/wJ8A
         2YfbuYyxCL60K9FiTZiUsmH13xDdxZO7+P2/7d6oFfQmmWfNWc+mPkAMXLr01yb2YQa2
         bOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VT+D2bCwr7paAn9CPq2Pst56j1rUGa0sbNZq6zVIofI=;
        b=tp0B+s3kyU2dM+miaF+4HCgibCzrMGdgcLTjkCM/H62FA+QlRMOEjhRkK9dzrfvL4F
         uwEaLd46tl53bJGk4CVCpQpErTjUzKrOSIKqAPcT9OYBfjlTC/g1LyDx3ZLAR7Iyb1w8
         XqSy44vAlG3h3BP67biraLnxGfg1LTpPSt86i4jA9/LC6HJWsaz0J/n21Sw1smaXtgjE
         lX+eOVl72TGPUWokdVxpgg6QCTfGdIajNIyQhF7KRYPnQN6M95pS1FaghT/90OoHfAqr
         6XLVY27SD5jGdDCoRaY2VaQcCjzUdJv6yRtAJnPPhpOKvpSgc1UUpLQv2O5i1qhuoBQJ
         oEiA==
X-Gm-Message-State: APjAAAW4MgmSTR7Xw4XM3sQJ4pSIw2Yiizk/LIGhYMkb0dhbnuJf0ixm
        Gyi9pBwyF7Xq3abzXQfwIuYGnVzr
X-Google-Smtp-Source: APXvYqwDAshO2Jed3KwVnADRKyvG3uLDv91s5bG3wTrViwAFoEVgDG19zqH6n1VlEtb64T0TfXHshQ==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr6794690wrr.218.1551957937353;
        Thu, 07 Mar 2019 03:25:37 -0800 (PST)
Received: from [192.168.19.12] (host86-147-153-76.range86-147.btcentralplus.com. [86.147.153.76])
        by smtp.googlemail.com with ESMTPSA id c10sm1142740wrr.1.2019.03.07.03.25.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 03:25:36 -0800 (PST)
Subject: Re: [PATCH] media: adv748x: Don't disable CSI-2 on link_setup
To:     Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund+renesas@ragnatech.se,
        kieran.bingham@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190306112659.8310-1-jacopo+renesas@jmondi.org>
 <20190306191521.GE4791@pendragon.ideasonboard.com>
 <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <60d196dc-9795-7360-536e-4df5ca2b5adb@gmail.com>
Date:   Thu, 7 Mar 2019 11:25:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190307103511.wtx2c7jecyx4nmms@uno.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On 07/03/2019 10:35, Jacopo Mondi wrote:
> Hi Laurent,
> 
> On Wed, Mar 06, 2019 at 09:15:21PM +0200, Laurent Pinchart wrote:
>> Hi Jacopo,
>>
>> On Wed, Mar 06, 2019 at 12:26:59PM +0100, Jacopo Mondi wrote:
>>> When both the media links between AFE and HDMI and the two TX CSI-2 outputs
>>> gets disabled, the routing register ADV748X_IO_10 gets zeroed causing both
>>> TXA and TXB output to get disabled.
>>>
>>> This causes some HDMI transmitters to stop working after both AFE and
>>> HDMI links are disabled.
>>
>> Could you elaborate on why this would be the case ? By HDMI transmitter,
>> I assume you mean the device connected to the HDMI input of the ADV748x.
>> Why makes it fail (and how ?) when the TXA and TXB are both disabled ?
>>
> 
> I know, it's weird, the HDMI transmitter is connected to the HDMI
> input of adv748x and should not be bothered by CSI-2 outputs
> enablement/disablement.
> 
> BUT, when I developed the initial adv748x AFE->TXA patches I was
> testing HDMI capture using a laptop, and things were smooth.
> 
> I recently started using a chrome cast device I found in some drawer
> to test HDMI, as with it I don't need to go through xrandr as I had to
> do when using a laptop for testing, but it seems the two behaves differently.
> 
> Failures are of different types: from detecting a non-realisting
> resolution from the HDMI subdevice, and then messing up the pipeline
> configuration, to capture operations apparently completing properly
> but resulting in mangled images.
> 
> Do not deactivate the CSI-2 ouputs seems to fix the issue for the
> Chromecast, and still work when capturing from laptop. There might be
> something I am missing about HDMI maybe, but the patch not just fixes
> the issue for me, but it might make sense on its own as disabling the
> TXes might trigger some internal power saving state, or simply mess up
> the HDMI link.

Maybe disabling the device is clearing the EDID RAM and the Chromecast 
rereads this, but the laptop doesn't? Just a thought.

Regards,
Ian.

> 
> As disabling both TXes usually happens at media link reset time, just
> before enabling one of them (or both), going through a full disable
> makes little sense, even more if it triggers any sort of malfunctioning.
> 
> Does this make sense to you?
> 
> Thanks
>    j
> 
>>> Fix this by preventing writing 0 to
>>> ADV748X_IO_10 register, which gets only updated when links are enabled
>>> again.
>>>
>>> Fixes: 9423ca350df7 ("media: adv748x: Implement TX link_setup callback")
>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>> ---
>>> The issue presents itself only on some HDMI transmitters, and went unnoticed
>>> during the development of:
>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
>>>
>>> Patch intended to be applied on top of latest media-master, where the
>>> "[PATCH v3 0/6] media: adv748x: Implement dynamic routing support"
>>> series is applied.
>>>
>>> The patch reports a "Fixes" tag, but should actually be merged with the above
>>> mentioned series.
>>>
>>> ---
>>>   drivers/media/i2c/adv748x/adv748x-core.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>>> index f57cd77a32fa..0e5a75eb6d75 100644
>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>>> @@ -354,6 +354,9 @@ static int adv748x_link_setup(struct media_entity *entity,
>>>
>>>   	tx->src = enable ? rsd : NULL;
>>>
>>> +	if (!enable)
>>> +		return 0;
>>> +
>>>   	if (state->afe.tx) {
>>>   		/* AFE Requires TXA enabled, even when output to TXB */
>>>   		io10 |= ADV748X_IO_10_CSI4_EN;
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
