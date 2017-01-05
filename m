Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33573 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939045AbdAEWby (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 17:31:54 -0500
Subject: Re: [PATCH v2 09/19] ARM: dts: imx6-sabreauto: add the ADV7180 video
 decoder
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
 <1483477049-19056-10-git-send-email-steve_longerbeam@mentor.com>
 <acbdc873-3166-f56d-e6d1-948becb1a57c@mentor.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <3ac69119-d0aa-2758-ea67-991ad31fef84@gmail.com>
Date: Thu, 5 Jan 2017 14:31:52 -0800
MIME-Version: 1.0
In-Reply-To: <acbdc873-3166-f56d-e6d1-948becb1a57c@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/04/2017 04:41 AM, Vladimir Zapolskiy wrote:
> On 01/03/2017 10:57 PM, Steve Longerbeam wrote:
>> +
>> +			camera: adv7180@21 {
> adv7180: camera@21

done.

>>   
>> +		pinctrl_ipu1_csi0: ipu1grp-csi0 {
> Please rename node name to ipu1csi0grp.

done.


Steve

