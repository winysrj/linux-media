Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.micronovasrl.com ([212.103.203.10]:57220 "EHLO
        mail.micronovasrl.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751565AbdK1NDr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 08:03:47 -0500
Received: from mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1])
        by mail.micronovasrl.com (Postfix) with ESMTP id 26F76B00D75
        for <linux-media@vger.kernel.org>; Tue, 28 Nov 2017 14:03:46 +0100 (CET)
Received: from mail.micronovasrl.com ([127.0.0.1])
        by mail.micronovasrl.com (mail.micronovasrl.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3ShwJob0yMdt for <linux-media@vger.kernel.org>;
        Tue, 28 Nov 2017 14:03:45 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [linux-sunxi] Cedrus driver
From: Giulio Benetti <giulio.benetti@micronovasrl.com>
In-Reply-To: <20171128125203.h7cnu3gkfmogqhxu@flea.home>
Date: Tue, 28 Nov 2017 14:03:43 +0100
Cc: Thomas van Kleef <thomas@vitsch.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A617A27-DBE8-4537-A122-6ACA98B8A6B4@micronovasrl.com>
References: <1511868558-1962148761.366cc20c7e@prakkezator.vehosting.nl> <d8135c3d-7ba8-2b88-11cb-5b81dfa04be2@vitsch.nl> <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com> <20171128125203.h7cnu3gkfmogqhxu@flea.home>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> Il giorno 28 nov 2017, alle ore 13:52, Maxime Ripard <maxime.ripard@free-e=
lectrons.com> ha scritto:
>=20
> On Tue, Nov 28, 2017 at 12:54:08PM +0100, Giulio Benetti wrote:
>>>>> Should I be working in sunxi-next I wonder?
>>>>=20
>>>> Yes, this is the best way, cedrus is very specific to sunxi.
>>>> So before working on mainline, I think the best is to work un sunxi-nex=
t branch.
>>>=20
>>> Is the requests2 api in sunxi-next?
>>=20
>> It should be there,
>> take a look at latest commit of yesterday:
>> https://github.com/linux-sunxi/linux-sunxi/commit/df7cacd062cd84c551d7e72=
f15b1af6d71abc198
>=20
> No, it shouldn't. sunxi-next is about patches that are related to
> sunxi that have been accepted in their respective maintainers'
> branches.
>=20
> While we could argue about the first criteria, the second one is not
> respected.
>=20
> And really, just develop against 4.14. sunxi-next is rebased, and it's
> just not something you can base some work on.

Where do we can work on then?
Should Thomas setup his own github repo?
What about the one you=E2=80=99ve set up @free-electrons?

>=20
> Maxime
>=20
> --=20
> Maxime Ripard, Free Electrons
> Embedded Linux and Kernel engineering
> http://free-electrons.com
