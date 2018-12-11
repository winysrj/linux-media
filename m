Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95183C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60DF12084C
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:40:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60DF12084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbeLKJk6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:40:58 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:44866 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbeLKJk6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:40:58 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WeX9gFOAvQMWUWeXAg6YxV; Tue, 11 Dec 2018 10:40:56 +0100
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
 <20181210205945.GB325@mithrandir>
 <96df2b5f-e388-b933-8823-c718290bd5e3@xs4all.nl>
 <20181211093807.GA14426@ulmo>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <26035940-2364-1fa0-68ab-8b9327705eb4@xs4all.nl>
Date:   Tue, 11 Dec 2018 10:40:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181211093807.GA14426@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOhpUDgxHYXTNFjJbdK1ivaweHE1ltRmUEWP1MGuCGCLktx30fPprlLu2AJngsc7edx1Bw0T6yibq2MuE7brfEzn7g9ZHDfTRgVZhWQsQ1QUFj0Q6Uc1
 JxMR5ys4I5jggvf26k3Se3Lcgjj68DDSXyRmciwB2Ajl7tmS2jl9KKxKT9f12dSF39oVhbxhzSLQrXsScHnNrfJf7Hg9S8EUSIsDNy6+VgzhFlvAV03eGlnd
 N8wJE+n6CVkzI6bjVybVDm9HnWj+ww4yTdSY8Fph62C0uq05YhihqrYpmn6Vn9UgNT+J1TCL5KNqpJEnaXCtS+Hi5k/FUmmLnp6nL6mNaDAAhArQr2zNnehi
 Bg8ChoTx8jxauJOxSPSjS28fsZgGW8JiZnszWTmmnOTjFaVxUFo5Q3TI9uSFwCjwnxBQ5NQanT3fgAD8g7v8jcnN2hzitgyw5hQ1Q6rywJKi0WasrnQ=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

(Resend, this time with a proper reply)

On 12/11/18 10:38 AM, Thierry Reding wrote:
> On Tue, Dec 11, 2018 at 10:19:48AM +0100, Hans Verkuil wrote:
>> On 12/10/18 9:59 PM, Thierry Reding wrote:
>>> On Mon, Dec 10, 2018 at 06:07:10PM +0100, Hans Verkuil wrote:
>>>> Hi Thierry,
>>>>
>>>> On 12/10/18 5:00 PM, Thierry Reding wrote:
>>>>> From: Thierry Reding <treding@nvidia.com>
>>>>>
>>>>> The CEC controller found on Tegra186 and Tegra194 is the same as on
>>>>> earlier generations.
>>>>
>>>> Well... at least for the Tegra186 there is a problem that needs to be addressed first.
>>>> No idea if this was solved for the Tegra194, it might be present there as well.
>>>>
>>>> The Tegra186 hardware connected the CEC lines of both HDMI outputs together. This is
>>>> a HW bug, and it means that only one of the two HDMI outputs can use the CEC block.
>>>
>>> I don't know where you got that information from, but I can't find any
>>> indication of that in the documentation. My understanding is that there
>>> is a single CEC block that is completely independent and it is merely a
>>> decision of the board designer where to connect it. I'm not aware of any
>>> boards that expose more than a single CEC.
>>
>> Sorry, my memory was not completely correct.
>>
>> The problem is that the 186 can be configured with two HDMI outputs, but it has
>> only one CEC block. So CEC can be used for only one of the two. I checked the TRM
>> for the Tegra194 and that has up to four HDMI outputs, but still only one CEC
>> block.
>>
>> And yes, it is the responsibility for the board designer to hook up the CEC pin
>> to only one of the outputs, but the TRM never explicitly mentions this and given
>> the general lack of knowledge about CEC it wouldn't surprise me at all if there
>> will be wrong board designs.
>>
>> But be that as it may, the core problem remains: you cannot allow multiple
>> HDMI outputs to be connected to the same CEC device.
>>
>> However, I now realize that your patches will actually work fine since each
>> HDMI connector tries to get a cec notifier for its own HDMI device, but the
>> tegra-cec driver will only register a notifier for the HDMI device pointed
>> to by the hdmi-phandle property. So only one of the HDMI devices will actually
>> get a working CEC.
>>
>> Although if board designers mess this up and connect multiple CEC lines to
>> the same CEC pin, this would still break, but there is nothing that can be
>> done about that. I still believe the TRM should have made this clear since
>> it is not obvious. Even better would be to have the same number of CEC blocks
>> as there are configurable HDMI outputs. Typically, if you support CEC on one
>> HDMI output, you want to support it for all. And today that's not possible
>> without adding external CEC devices (as we - Cisco - do).
> 
> I wasn't aware that anyone was using a Tegra with support for multiple
> HDMI outputs. Do you have a contact that you can forward this kind of
> request to? It certainly sounds like something that would be useful to
> add in future chips if there's a customer need.

We have contacts, and we did report it, but nothing happened with it
AFAIK. It was likely too late for changes to the Tegra194 design in any
case.

Regards,

	Hans

> 
> I can also forward this internally, but I expect it to have more weight
> coming directly from Cisco. =)
> 
>> Apologies for the confusion, I should never send emails after 5pm :-)
> 
> No worries.
> 
> Thierry
> 

