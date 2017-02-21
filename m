Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35704 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdBUF4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 00:56:14 -0500
Received: by mail-oi0-f65.google.com with SMTP id z13so3751053oig.2
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 21:56:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
References: <DB5PR0701MB19091F43803C514055C4592A885D0@DB5PR0701MB1909.eurprd07.prod.outlook.com>
From: Ajay kumar <ajaynumb@gmail.com>
Date: Tue, 21 Feb 2017 11:26:13 +0530
Message-ID: <CAEC9eQMreAGiZW-p457YeR1csfBbrhLBD+RSFKr3oMt0re1mJA@mail.gmail.com>
Subject: Re: v4l2: Adding support for multiple MIPI CSI-2 virtual channels
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Cc: Thomas Axelsson <Thomas.Axelsson@cybercom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

On Fri, Feb 17, 2017 at 7:27 PM, Thomas Axelsson
<Thomas.Axelsson@cybercom.com> wrote:
> Hi,
>
> I have a v4l2_subdev that provides multiple MIPI CSI-2 Virtual Channels. =
I want to configure each virtual channel individually (e.g. set_fmt), but t=
he v4l2 interface does not seem to have a clear way to access configuration=
 on a virtual channel level, but only the v4l2_subdev as a whole. Using one=
 v4l2_subdev for multiple virtual channels by extending the "reg" tag to be=
 an array looks like the correct way to do it, based on the mipi-dsi-bus.tx=
t document and current device tree endpoint structure.
>
> However, I cannot figure out how to extend e.g. set_fmt/get_fmt subdev io=
ctls to specify which virtual channel the call applies to. Does anyone have=
 any advice on how to handle this case?
This would be helpful for my project as well since even I need to
support multiple streams using Virtual Channels.
Can anyone point out to some V4L2 driver, if this kind of support is
already implemented?

Thanks.
>
> Previous thread: "Device Tree formatting for multiple virtual channels in=
 ti-vpe/cal driver?"
>
>
> Best Regards,
> Thomas Axelsson
>
> PS. First e-mail seems to have gotten caught in the spam filter. I apolog=
ize if this is a duplicate.
