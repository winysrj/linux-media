Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.132]:43620 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbcL3IWY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 03:22:24 -0500
Subject: The update of RockChip media framework plan
To: Christian Hewitt <chewitt@libreelec.tv>
References: <SN2PR17MB08610AA7196487D55060A3BDB4920@SN2PR17MB0861.namprd17.prod.outlook.com>
 <1DF5F386-2C0D-4A69-A34C-C57CD16501EA@libreelec.tv>
Cc: LongChair <LongChair@hotmail.com>,
        Keith Herrington <keith@kodi.tv>,
        Lukas Rusak <lrusak@libreelec.tv>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        "lkcl ." <luke.leighton@gmail.com>,
        "ayaka@soulik.info" <ayaka@soulik.info>,
        florent.revest@free-electrons.com, hugues.fruchet@st.com
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <b7a376dd-eade-d4ed-df8a-8dbc635b39a2@rock-chips.com>
Date: Fri, 30 Dec 2016 16:22:04 +0800
MIME-Version: 1.0
In-Reply-To: <1DF5F386-2C0D-4A69-A34C-C57CD16501EA@libreelec.tv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To those guy who cares Rockchip

There is a update about Rockchip media framework, I decided not to 
continue of developing the VA-API driver for produces purpose(both 
official and private plan). As there is really to much problem with 
VA-API with V4L2. But I may develop the VA-API driver to know how to 
expend the parser in Gstreamer.
The currently Gstreamer plugins using a rockchip video parser and HAL 
layer library could be located here
https://github.com/rockchip-linux/gstreamer-rockchip

For the future develop plan, I would try to move all the thing to 
Gstreamer V4L2 plugin, maybe I would create a new plugin. But it would 
be a long time to go. As there is no critical need of the Media 
framework for Rockchip in Linux, the official plan would be paused, if 
the kodi or LibreELEC is not interesting to my supervisor, this plan 
will become my private plan, but good news is that my plan about the ISP 
support would become official.

Any the result would be there is a standard V4L2 API and a driver for 
those stateless video driver(Do remember we don't need firmware). And I 
would use the Gstreamer in userspace and welcome the other to offer the 
support in the other project.

For the those project who have supported the ffmpeg, I would suggest you 
to add support for Gstreamer, the role of Gstreamer in a player is not 
different to the ffmpeg. The support of ffmpeg of Rockchip project would 
be dropped, as we need a power way to rendering decoding result for 
those 4K video. The Gstreamer is the only Media Framework who could 
offer a static interface and easy to extend. Even the Gstreamer, 
currently I found it could only cover the 80% solution of I would meet,
but it is enough for Linux.

On 12/23/2016 07:17 PM, Christian Hewitt wrote:
> Hello Randy,
>
> I would like LibreELEC to run great on a wide range of devices including
> rockchip so it is good to have direct contact - thanks Lionel.
>
> Our core focus is Kodi so I have cc'd Keith Herrington from the Kodi
> project board. Keith and senior developers on Kodi’s team can guide you
> on their technical direction and requirements for Linux. Once there is
> agreement on the right approach for your developers we can start looking
> at hardware support.
>
> Kind regards,
>
> Christian
>
> --
> Christian Hewitt
> Project Lead
> chewitt@libreelec.tv <mailto:chewitt@libreelec.tv>
> +971 50 3570 499
>
> On 22 Dec 2016, at 07:49 pm, LongChair . <LongChair@hotmail.com
> <mailto:LongChair@hotmail.com>> wrote:
>
>> Hi Christian,
>>
>> I have been looking around recently to RockChip latest SoCs, which are
>> RK3288 and RK3399.
>> They seem great on paper, and I have some interest in those.
>>
>> What i know about those so far is that :
>> - They Run Linux 4.4
>> - They Have some V4L2 compliance which was made by rockChip for
>> Google/chromium
>> - They also have a va-api wrapper (only supporting h264 so far, but
>> intended to be extended in a near future to other codecs)
>> - They have some muscles (A72 for RK3399) and Mali 8XX as GPU which
>> makes them probably snappier than AML SoCs.
>>
>> I am considering investigating this as a potential platform for US,
>> which means integrating it into LE.
>> I am not sure if that would be a valid approach, or if that would meet
>> any kodi eventual requirements as well.
>>
>> I'm available to discuss that with you anytime.
>> I will cc also Ayaka to this email. He's a Rockchip employee in charge
>> of Linux Support.
>> Should you have deeper technical questions about this, he will
>> probably be able to answer that :)
>>
>> Cheers,
>>
>> Lionel
>>
>>
>

-- 
Randy Li
The third produce department

