Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:58110 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdCMLoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 07:44:14 -0400
Subject: Re: [PATCH v3 4/6] drm: bridge: dw-hdmi: Switch to V4L bus format and
 encodings
To: Neil Armstrong <narmstrong@baylibre.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <dri-devel@lists.freedesktop.org>,
        <laurent.pinchart+renesas@ideasonboard.com>,
        <architt@codeaurora.org>, <mchehab@kernel.org>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
 <1488904944-14285-5-git-send-email-narmstrong@baylibre.com>
 <977cfb29-af7a-2e28-7a7f-396d9ccf3eb8@synopsys.com>
 <28fe7ecf-cf4a-568a-b853-0506c088884d@baylibre.com>
 <f73a3cee-3336-2562-696d-dd4e0e7ac680@synopsys.com>
CC: <kieran.bingham@ideasonboard.com>,
        <linux-amlogic@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <hans.verkuil@cisco.com>,
        <sakari.ailus@linux.intel.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <dfc1e19f-8b83-fc1a-3653-7e95bcc3c7f0@synopsys.com>
Date: Mon, 13 Mar 2017 11:43:44 +0000
MIME-Version: 1.0
In-Reply-To: <f73a3cee-3336-2562-696d-dd4e0e7ac680@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,


On 09-03-2017 14:27, Jose Abreu wrote:
> Hi Neil,
>
>
> On 08-03-2017 12:12, Neil Armstrong wrote:
>> Hi Jose,
>>
>> It seems here that we only have the RGB444<->YUV444 8bit tables, from the Amlogic
>> source I have the following for 10bit, 12bit and 16bit for itu601 :
>>
>> static const u16 csc_coeff_rgb_out_eitu601_10b[3][4] = {
>> 	{ 0x2000, 0x6926, 0x74fd, 0x043b },
>> 	{ 0x2000, 0x2cdd, 0x0000, 0x7a65 },
>> 	{ 0x2000, 0x0000, 0x38b4, 0x78ea }
>> };
>>
>> static const u16 csc_coeff_rgb_out_eitu601_12b_16b[3][4] = {
>> 	{ 0x2000, 0x6926, 0x74fd, 0x10ee },
>> 	{ 0x2000, 0x2cdd, 0x0000, 0x6992 },
>> 	{ 0x2000, 0x0000, 0x38b4, 0x63a6 }
>> };
> These two do not match anything I have here.
>
>> static const u16 csc_coeff_rgb_in_eitu601_10b[3][4] = {
>> 	{ 0x2591, 0x1322, 0x074b, 0x0000 },
>> 	{ 0x6535, 0x2000, 0x7acc, 0x0800 },
>> 	{ 0x6acd, 0x7534, 0x2000, 0x0800 }
>> };
> This is more or less correct, I have small offsets. Note that I
> even have offsets with the values that are in dw-hdmi driver,
> which can be caused because I'm seeing the latest document that
> contain these values. I guess they were updated.
>
>> static const u16 csc_coeff_rgb_in_eitu601_12b_16b[3][4] = {
>> 	{ 0x2591, 0x1322, 0x074b, 0x0000 },
>> 	{ 0x6535, 0x2000, 0x7acc, 0x2000 },
>> 	{ 0x6acd, 0x7534, 0x2000, 0x2000 }
>> };
> The same for this.
>
>> But I miss the itu709 values.
>>
>> Could you confirm these values and maybe provide the itu709 values ?
> I will have to check if I can provide you the values. I will get
> back to you.

Sorry but looks like I won't be able to provide you the correct
values :/ If you are working for a Synopsys customer you can
contact our CAE (If so I can guide you to the correct CAE).

Anyway, unless you can test the values you have I suggest you
don't use them, they do not match what I have here and I can't
test them because right now I don't have a setup (I'm assuming
that your CSC block within the controller was not modified).

Best regards,
Jose Miguel Abreu
