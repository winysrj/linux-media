Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43987 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab0DWFbx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 01:31:53 -0400
Received: by gyg13 with SMTP id 13so4945395gyg.19
        for <linux-media@vger.kernel.org>; Thu, 22 Apr 2010 22:31:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100423042314.GA14468@joro.homelinux.org>
References: <u2u6e8e83e21004212214i8c186922he28162cbed66d292@mail.gmail.com>
	 <20100422202017.GA13005@joro.homelinux.org>
	 <s2i6e8e83e21004221905pe0f079ddye1477c26f6b9f712@mail.gmail.com>
	 <20100423042314.GA14468@joro.homelinux.org>
Date: Fri, 23 Apr 2010 13:31:52 +0800
Message-ID: <t2l6e8e83e21004222231rf66fe4f6seca17b0fc715dd2d@mail.gmail.com>
Subject: Re: tm6000: Patch that will fixed analog video (tested on tm5600)
From: Bee Hock Goh <beehock@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

its a tm6010 chipset. I guess there might still be some missing
initialisation in the mainstream codes.

I think Stefan Ringel have that and he is working on the analog code
as well. We will probably have to wait for him.

If you have the full usb snoop data, I will consider looking into it
but its a very long tedious process and working without the device
will be difficult.


On Fri, Apr 23, 2010 at 12:23 PM, George Tellalov <gtellalov@bigfoot.com> wrote:
> On Fri, Apr 23, 2010 at 10:05:25AM +0800, Bee Hock Goh wrote:
>> George,
>>
>> Which device are you using?
>>
>
> A Hauppauge HVR-900H (usb id 2040:6600).
>
