Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:38814 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEOwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 10:52:42 -0400
Received: by mail-ot0-f174.google.com with SMTP id o9-v6so27496473otj.5
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 07:52:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1522938992.4009.14.camel@pengutronix.de>
References: <CAPQseg3c+jVBRv7nu9BZXFi2V+afrDUq+YR-0jEDGevgwa-NWw@mail.gmail.com>
 <CAOMZO5DKPaBwHEtr2DbOWfx7VU-5j9PKS6iCzpbx8B+Fwf2Wiw@mail.gmail.com>
 <CAPQseg0g-64dPGoCFopiNJZPf9qjvdETOz=U-dLS_D0y+HrNHA@mail.gmail.com> <1522938992.4009.14.camel@pengutronix.de>
From: Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com>
Date: Thu, 5 Apr 2018 16:52:41 +0200
Message-ID: <CAPQseg3puHqfNth2V73_rbmQquOTuRSKiwWpRW2OXLAkpSF3qg@mail.gmail.com>
Subject: Re: IMX6 Media dev node not created
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 5, 2018 at 4:36 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Ibtsam,
>
> On Thu, 2018-04-05 at 16:24 +0200, Ibtsam Ul-Haq wrote:
>> Hi Fabio,
>>
>> Thanks for your reply.
>>
>> On Thu, Apr 5, 2018 at 3:31 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> > Hi Ibtsam,
>> >
>> > [Adding Steve and Philipp in case they can provide some suggestions]
>> >
>> > On Thu, Apr 5, 2018 at 9:30 AM, Ibtsam Ul-Haq <ibtsam.haq.0x01@gmail.com> wrote:
>> > > Greetings everyone,
>> > >
>> > > I'm running Linux 4.14.31 on an IMX6 QuadPlus based Phytec board
>> > > (PCM-058). I have connected an mt9p031 sensor to ipu1_csi0. The
>> > > problem is that I am not seeing the /dev/media0 node.
>> >
>> > Can you share your dts?
>> >
>>
>> Certainly. The dts provided by the board manufacturer was meant to
>> work with their own kernel, I tried to modify it to work with the
>> mainline kernel.
>>
>> The sensor related nodes are:
>>
> [...]
>>     mt9p031_1: cam1@5d {
>>         compatible = "aptina,mt9p031";
>>         reg = <0x5d>;
>>         status = "okay";
> [...]
>> I intend to use two cameras simultaneously. In my current setup
>> however only one camera is physically connected.
>
> Try disabling this camera as long as it is not present, otherwise the
> imx-media driver will wait forever for it to appear before creating
> /dev/media0.
>

That worked like a charm! Thanks a lot guys, I would have never thought of that!

> regards
> Philipp


Best regards,
Ibtsam Haq
