Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35595 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbcAVHXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 02:23:45 -0500
Received: by mail-ob0-f170.google.com with SMTP id yo10so30908834obb.2
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2016 23:23:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1707301.3M6CagkYeP@avalon>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5CF5@SAFEX1MAIL1.st.com>
	<1707301.3M6CagkYeP@avalon>
Date: Fri, 22 Jan 2016 08:23:44 +0100
Message-ID: <CAJbz7-3ffWJTD-NH=JWAsUVWKGbuBm7g_OTEZ1R010X5aS_VbQ@mail.gmail.com>
Subject: Re: mediacontroller for framebuffer
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sebastien LEDUC <sebastien.leduc@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

>> I have seen that a long time ago you had done some prototyping work for
>> exposing framebuffer devices as media entities:
>> http://www.spinics.net/lists/linux-fbdev/msg04408.html
>>
>> What did happen to this prototyping ?
>> Seems it has never been merged, so could you please explain why ?
>>
>> We have some similar needs, so I'd like to understand the right way to go
>
> The prototype has been dropped as the framebuffer subsystem got deprecated.
> Display drivers should now use DRM/KMS.

FB is deprecated? Can you, please, provide some links regarding such talk?
Sorry for my ignorance, I was never so deep in DRM/KMS (as I treat that
as big gun for my small embedded systems I was working on) and I'm
still happy with simple FB support which I get from kernel.

Thanks.
/Honza
