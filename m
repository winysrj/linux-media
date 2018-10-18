Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45534 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725735AbeJSE2d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 00:28:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id y15-v6so14811756plr.12
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 13:25:51 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4 01/12] media: ov5640: Adjust the clock based on the expected rate
From: Samuel Bobrowicz <sam@elite-embedded.com>
In-Reply-To: <20181018100332.GE17549@w540>
Date: Thu, 18 Oct 2018 13:25:43 -0700
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D62DB82-AE43-44F3-8FA6-485105E1C351@elite-embedded.com>
References: <20181011092107.30715-1-maxime.ripard@bootlin.com> <20181011092107.30715-2-maxime.ripard@bootlin.com> <20181016165450.GB11703@w540> <CAFwsNOHpZ+Kf6YQnENuYLtwenjGzWfy=TYqaEC5tjLmaoeTA+g@mail.gmail.com> <20181017194835.GA17549@w540> <20181018093152.q5yusjycwbzxnyfq@flea> <20181018100332.GE17549@w540>
To: jacopo mondi <jacopo@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> On Oct 18, 2018, at 3:03 AM, jacopo mondi <jacopo@jmondi.org> wrote:
>=20
>> On Thu, Oct 18, 2018 at 11:31:52AM +0200, Maxime Ripard wrote:
>>> On Wed, Oct 17, 2018 at 09:51:43PM +0200, jacopo mondi wrote:
>>> Hello Sam and Maxime (and other ov5640-ers :)
>>>=20
>>>> On Wed, Oct 17, 2018 at 10:54:01AM -0700, Sam Bobrowicz wrote:
>>>> Hello Maxime and Jacopo (and other ov5640-ers),
>>>>=20
>>>> I just submitted my version of this patch to the mailing list as RFC.
>>>> It is working on my MIPI platform. Please try it if you have time.
>>>> Hopefully we can merge these two into a single patch that doesn't
>>>> break any platforms.
>>>=20
>>> Thanks, I have seen your patch but it seems to contain a lot of things
>>> already part of Maxime's series. Was this intentional?
>>>=20
>>> Now the un-pleaseant part: I have just sent out my re-implementation
>>> of the MIPI clock tree configuration, based on top of Maxime's series.
>>> Both you and me have spent a looot of time on this I'm sure, and now
>>> we have two competing implementations.
>>>=20
>>> I had a quick look at yours, and for sure there are things I am not
>>> taking care of (I'm thinking about the 0x4837 register that seems to
>>> be important for your platform), so I think both our implementations
>>> can benefits from a comparison. What is important to me is that both
>>> you and me don't feel like our work has been wasted, so let's try to
>>> find out a way to get the better of the two put together, and possibly
>>> applied on top of Maxime's series, so that a v5 of this will work for
>>> both MIPI and DVP interfaces. How to do that I'm not sure atm, I think
>>> other reviewers might help in that if they want to have a look at both
>>> our series :)
>>=20
>> IIRC, Sam's system has never worked with the ov5640 driver, and his
>> patches now make it work.
>>=20
>> Your patches on the other hand make sure that the current series
>> doesn't break existing users. So I guess we could merge your current
>> patches into the v5 of my rework, and have Sam send his work on top of
>> that.
>>=20
>> Does that make sense?
>=20
> It does for me, but it puts the burden on Sam to re-apply his work
> on top of [yours+mine] (which is something he would have had to do
> anyhow to have his patches accepted, as he would have had to rebase on
> top of your series).
>=20
Don=E2=80=99t worry about it :)

> I hope to find some more time to look into his series and find out how
> hard it would be to add his changes on top of mine, and hopefully help
> with this.
> Also, testing my patches with DVP would be nice (it should not be
> affected at all, but still...)
>=20
> Thanks
>   j
>=20
>>=20
>> Maxime
>>=20
>> --
>> Maxime Ripard, Bootlin
>> Embedded Linux and Kernel engineering
>> https://bootlin.com
>=20
>=20

I=E2=80=99m fine with this approach, but it takes my ability to easily test y=
our changes on my MIPI platform off the table. I will be around to run some m=
anual tests on your algorithms and answer tech details about my experiments w=
ith the sensor, but it will fall on Jacobi to ensure that whatever patch you=
 land on doesn=E2=80=99t introduce a regression for MIPI platforms. I can th=
en submit a PCLK period patch on top of what you end up with, which will the=
n put my platform in the game.=20

Sam=
