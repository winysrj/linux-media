Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BE7C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D792082F
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 09:19:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0D792082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbeLKJTw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 04:19:52 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38334 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726117AbeLKJTv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 04:19:51 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WeCigFAGmQMWUWeCjg6R09; Tue, 11 Dec 2018 10:19:49 +0100
Subject: Re: [PATCH 1/2] media: tegra-cec: Support Tegra186 and Tegra194
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20181210160038.16122-1-thierry.reding@gmail.com>
 <643e8da6-a8ed-145a-604d-f028e501add9@xs4all.nl>
 <20181210205945.GB325@mithrandir>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <96df2b5f-e388-b933-8823-c718290bd5e3@xs4all.nl>
Date:   Tue, 11 Dec 2018 10:19:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181210205945.GB325@mithrandir>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPX6vfK1G/wsAYQ6j3Oucq9tLtQDPBrjeibaD9DT4hbt+HJKxqei5WV0wPIRBsIlz6f1tP457tZ+/zTB8JU4mQw/3GyGfB8sGU7Wb0UVGKnA1l9PA9xI
 aLD76GjaxGQ6fOyc2JeoDLBQ3PvKrGC4eTJWbcCUtc9WruP0q0gK16PbhwoqrplfeayBYXBNDBHwNxqtgdCzMc7YsWept062sHcpY07PTdoJiRpeNdUvxnEK
 gw5y+BiRRXR6OdLTPRjM2rjl5ml2xk/bViuN9nD0TfpVDlxhyddghdztuBqOlOVD0CY9pPNeN0YXpo5vXnydtsaOmLw3g+6Q1A7pjKWrftoY2mv/31ATiSAz
 tjOsgGZgNpMGJDe2UZ6eag72scuz9ST9VD/GZHLWV3OUDKa2xIrClNsXsgO/RC7GkDAFxv9XUmzzpM12hygwdFKC3sNmfns90WZIbRlvcHjyu8IkU1U=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 9:59 PM, Thierry Reding wrote:
> On Mon, Dec 10, 2018 at 06:07:10PM +0100, Hans Verkuil wrote:
>> Hi Thierry,
>>
>> On 12/10/18 5:00 PM, Thierry Reding wrote:
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> The CEC controller found on Tegra186 and Tegra194 is the same as on
>>> earlier generations.
>>
>> Well... at least for the Tegra186 there is a problem that needs to be addressed first.
>> No idea if this was solved for the Tegra194, it might be present there as well.
>>
>> The Tegra186 hardware connected the CEC lines of both HDMI outputs together. This is
>> a HW bug, and it means that only one of the two HDMI outputs can use the CEC block.
> 
> I don't know where you got that information from, but I can't find any
> indication of that in the documentation. My understanding is that there
> is a single CEC block that is completely independent and it is merely a
> decision of the board designer where to connect it. I'm not aware of any
> boards that expose more than a single CEC.

Sorry, my memory was not completely correct.

The problem is that the 186 can be configured with two HDMI outputs, but it has
only one CEC block. So CEC can be used for only one of the two. I checked the TRM
for the Tegra194 and that has up to four HDMI outputs, but still only one CEC
block.

And yes, it is the responsibility for the board designer to hook up the CEC pin
to only one of the outputs, but the TRM never explicitly mentions this and given
the general lack of knowledge about CEC it wouldn't surprise me at all if there
will be wrong board designs.

But be that as it may, the core problem remains: you cannot allow multiple
HDMI outputs to be connected to the same CEC device.

However, I now realize that your patches will actually work fine since each
HDMI connector tries to get a cec notifier for its own HDMI device, but the
tegra-cec driver will only register a notifier for the HDMI device pointed
to by the hdmi-phandle property. So only one of the HDMI devices will actually
get a working CEC.

Although if board designers mess this up and connect multiple CEC lines to
the same CEC pin, this would still break, but there is nothing that can be
done about that. I still believe the TRM should have made this clear since
it is not obvious. Even better would be to have the same number of CEC blocks
as there are configurable HDMI outputs. Typically, if you support CEC on one
HDMI output, you want to support it for all. And today that's not possible
without adding external CEC devices (as we - Cisco - do).

Apologies for the confusion, I should never send emails after 5pm :-)

Regards,

	Hans

> 
> You may already have access to the schematics, if not you can download
> them here:
> 
> 	https://developer.nvidia.com/embedded/dlc/jetson-tx1-tx2-developer-kit-carrier-board-c02-design-files
> 
> It's slightly annoying because it requires registration. But in those
> schematics you'll see that the HDMI_CEC pin is just routed directly from
> the processor module to the connector on the carrier board via the
> connector.
> 
>> HDMI inputs CAN share the CEC line, but never outputs. There should have been two
>> CEC blocks, one for each HDMI output.
> 
> Like I said, I don't think these are shared. The board design will have
> to choose which connector gets the SOR and CEC pins for HDMI. Typically
> the other SOR will be used for DisplayPort, not HDMI, though that would
> technically be possible. I think in case where there really were two
> HDMI connectors on a design, a decision would have to be made as to
> which one gets the CEC pin.
> 
>> It should not be possible to use the same CEC block for both HDMI
>> outputs on the 186. Ideally it should be a required dts property that
>> determines this. I'm not sure where that should happen. One option
>> might be to use the cec_notifier_get_conn() function so you can
>> register the CEC adapter for a specific connector only. For older
>> tegra versions the connector name would be NULL (i.e. don't care), for
>> the 186 (and perhaps 194) it would be a required property that tells
>> the CEC driver which connector it is associated with.
>>
>> Just a suggestion, there might be other ways to implement this as well.
> 
> Given the documentation that I have, I don't think we need to take any
> additional precautions. We just to hook up the CEC controller to the
> correct HDMI connector via the hdmi-phandle property.
> 
>> So before I can merge this I need to know first how you plan to handle
>> this HW bug.
> 
> I don't think this is an actual bug. It's more of a restriction of the
> SoC that allows only a single HDMI connector with CEC support.
> 
> Thierry
> 

