Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32868 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdFIWfa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 18:35:30 -0400
Subject: Re: [PATCH v8 14/34] ARM: dts: imx6-sabreauto: add the ADV7180 video
 decoder
To: Pavel Machek <pavel@ucw.cz>
Cc: Tim Harvey <tharvey@gateworks.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        mchehab@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Nick Dyer <nick@shmanahar.org>, markus.heiser@darmarit.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, Arnd Bergmann <arnd@arndb.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        minghsiu.tsai@mediatek.com, Tiffany Lin <tiffany.lin@mediatek.com>,
        Jean-Christophe TROTIN <jean-christophe.trotin@st.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
 <1496860453-6282-15-git-send-email-steve_longerbeam@mentor.com>
 <CAJ+vNU0C0=4hUq+g1P7yTzLzFPidfauQROPOVr4WQWKNZz_xmQ@mail.gmail.com>
 <dd5b29b7-bf92-5f03-caef-1843a9f32cd3@gmail.com> <20170609213843.GB28596@amd>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <cb9d79e9-fa36-d0ad-3df6-27f1b8790f78@gmail.com>
Date: Fri, 9 Jun 2017 15:35:26 -0700
MIME-Version: 1.0
In-Reply-To: <20170609213843.GB28596@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/09/2017 02:38 PM, Pavel Machek wrote:
> On Thu 2017-06-08 13:36:12, Steve Longerbeam wrote:
>>
>>
>> On 06/08/2017 01:25 PM, Tim Harvey wrote:
>>>
>>>
>>> Steve,
>>>
>>> You need to remove the fim node now that you've moved this to V4L2 controls.
>>>
>>
>> Yep, I caught this just after sending the v8 patchset. I'll send
>> a v9 of this patch.
> 
> This needs ack from devicetree people, then it can be merged. Can you
> be a bit more forceful getting the ack?

OK, I need an Ack please, he said, in a forceful way. :)

In fact Ack's are needed for all the changes to dts sources,
patches 4-14.


> 
> I don't think it makes sense to resubmit v9 before that. This is not a
> rocket science.

I guess that makes sense, I'll wait for Ack's from all these patches
before submitting the entire patchset as v9.

Steve
