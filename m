Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:34176 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752457AbdGJJrS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 05:47:18 -0400
Received: by mail-qt0-f181.google.com with SMTP id 32so67924667qtv.1
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 02:47:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL4ntm9X1k4eXiEM4YE74zs46bqNhG0xS=dYcymW4sGbzCX=1A@mail.gmail.com>
References: <CAL4ntm9X1k4eXiEM4YE74zs46bqNhG0xS=dYcymW4sGbzCX=1A@mail.gmail.com>
From: Kumar Vivek <kv2000inn@gmail.com>
Date: Mon, 10 Jul 2017 05:47:16 -0400
Message-ID: <CACEBzGSYP5_P9LoeX_Rh=K142iaS1F7QwjvY6nyGTy0chFO6Dw@mail.gmail.com>
Subject: Re: Support for Linux driver for GENIATECH Mygica ATSC USB TV Stick A681
To: =?UTF-8?B?7LWc7Yq56rec?= <heartily0421@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could you provide us the details of the following:
1) After attaching the device to your usb port - output of lsusb and
dmesg commands. (name@computer$ lsusb ) and (name@computer$ dmesg)
2) Information regarding the chips present on this board - USB bridge,
Demodulator and Tuner chips.

I have a device from Mygica - A680 with usb id 05e1:0480 with Au0828
usb bridge, au8522 demodulator and tda18271hdc2 tuner and it is fully
supported.

On Mon, Jul 10, 2017 at 5:13 AM, =EC=B5=9C=ED=8A=B9=EA=B7=9C <heartily0421@=
gmail.com> wrote:
> Dear all
>
> (I have no experience in mailing list and linux programming, so please
> be patient of my first request mail.)
>
> By chance I (may) got linux driver for GENIATECH Mygica A681.
> Can any one verify it and include it to LinuxTV project?
>
> I saw http://mygicasupport.com/index.php?/topic/2484-linux-support/
> It said no linux driver for A681.
>
> But I saw A681's specification document
> (http://file.geniatech.com/thcdownloads/geniatech/specification/A681.pdf
> )
> It says linux driver is supported.
>
> So I request it to Geniatech.
> Their respond as follow:
> ************************************************************
> Hi sir,
> Please try this driver:
> https://mega.nz/#!utlmUA4L!A_AA-obMjiVJA3fOTLe_kZuml1tYPDGHtaQCuMv6bpQ
>
>
> Thanks & Best regards
> ************************************************************
> Claire
> Geniatech Anhui LLC
> Tel: +86-551-65553836
> Mob:+86-18226641675
> Email.: claire.chen@geniatech.com
> Website: www.geniatech.com
> Skype: claire.chen@geniatech.com
>
> Office address:Room 906,Building F5,Innovation Industrial Park,NO.2800
> InnovationRoad,High Tech Zone,Hefei,Anhui,China
>
> Factory address: 2~3 Floor, Block A, Yinghaosheng Industrial Park,
> Dayang Street, Fuyong, Bao=E2=80=99an District, Shenzhen, China
> ************************************************************
>
> Maybe this person(Claire) cannot know prior technical issue
> (http://mygicasupport.com/index.php?/topic/2484-linux-support/).
> But I surely have no proper programming skill for verify or develop
> this driver, Please help.
>
> Sincerely
