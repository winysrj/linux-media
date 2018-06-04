Return-path: <linux-media-owner@vger.kernel.org>
Received: from conssluserg-04.nifty.com ([210.131.2.83]:20979 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbeFDAxd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2018 20:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <005d01d3fb98$20711900$61534b00$@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
 <20180530090946.1635-7-suzuki.katsuhiro@socionext.com> <CAK7LNAS8JT8+MAuH+eYUJ3Xa4r07=ecJS0E=SX-tgmV7db_FKw@mail.gmail.com>
 <005d01d3fb98$20711900$61534b00$@socionext.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Mon, 4 Jun 2018 09:52:39 +0900
Message-ID: <CAK7LNAQT-yigu83t7xOF_4-G1_0DX9OXz_YhJ3SAMH_CkGJcrw@mail.gmail.com>
Subject: Re: [PATCH 6/8] media: uniphier: add common module of DVB adapter drivers
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-06-04 9:08 GMT+09:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>=
:
> Hello Yamada-san,
>
>> -----Original Message-----
>> From: Masahiro Yamada <yamada.masahiro@socionext.com>
>> Sent: Saturday, June 2, 2018 9:00 PM
>> To: Suzuki, Katsuhiro/=E9=88=B4=E6=9C=A8 =E5=8B=9D=E5=8D=9A <suzuki.kats=
uhiro@socionext.com>
>> Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>;
>> linux-media@vger.kernel.org; Masami Hiramatsu <masami.hiramatsu@linaro.o=
rg>;
>> Jassi Brar <jaswinder.singh@linaro.org>; linux-arm-kernel
>> <linux-arm-kernel@lists.infradead.org>; Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org>
>> Subject: Re: [PATCH 6/8] media: uniphier: add common module of DVB adapt=
er drivers
>>
>> 2018-05-30 18:09 GMT+09:00 Katsuhiro Suzuki <suzuki.katsuhiro@socionext.=
com>:
>> > This patch adds common module for UniPhier DVB adapter drivers
>> > that equipments tuners and demod that connected by I2C and
>> > UniPhier demux.
>> >
>> > Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
>> > ---
>> >  drivers/media/platform/uniphier/Makefile      |  5 ++
>> >  drivers/media/platform/uniphier/hsc-core.c    |  8 ---
>> >  .../platform/uniphier/uniphier-adapter.c      | 54 ++++++++++++++++++=
+
>> >  .../platform/uniphier/uniphier-adapter.h      | 42 +++++++++++++++
>> >  4 files changed, 101 insertions(+), 8 deletions(-)
>> >  create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.c
>> >  create mode 100644 drivers/media/platform/uniphier/uniphier-adapter.h
>> >
>> > diff --git a/drivers/media/platform/uniphier/Makefile
>> b/drivers/media/platform/uniphier/Makefile
>> > index 0622f04d9e68..9e75ad081b77 100644
>> > --- a/drivers/media/platform/uniphier/Makefile
>> > +++ b/drivers/media/platform/uniphier/Makefile
>> > @@ -3,3 +3,8 @@ uniphier-dvb-y +=3D hsc-core.o hsc-ucode.o hsc-css.o h=
sc-ts.o
>> hsc-dma.o
>> >  uniphier-dvb-$(CONFIG_DVB_UNIPHIER_LD11) +=3D hsc-ld11.o
>> >
>> >  obj-$(CONFIG_DVB_UNIPHIER) +=3D uniphier-dvb.o
>> > +
>> > +ccflags-y +=3D -Idrivers/media/dvb-frontends/
>> > +ccflags-y +=3D -Idrivers/media/tuners/
>>
>>
>> Please add $(srctree)/ like
>>
>> ccflags-y +=3D -I$(srctree)/drivers/media/dvb-frontends/
>> ccflags-y +=3D -I$(srctree)/drivers/media/tuners/
>>
>>
>> Currently, it works $(srctree)/,
>> but I really want to rip off the build system hack.
>
> Thanks, I agree with your opinion, but other Makefiles in drivers/media u=
se
> same hack. I don't know other way to include headers of demodulators and
> tuners...
>
> Do you have any good ideas?
>
>


My suggestion is to add '$(srctree)/'.

For clarification,



Bad:

ccflags-y +=3D -Idrivers/media/dvb-frontends/
ccflags-y +=3D -Idrivers/media/tuners/



Good:

ccflags-y +=3D -I$(srctree)/drivers/media/dvb-frontends/
ccflags-y +=3D -I$(srctree)/drivers/media/tuners/





I want to fix this tree-wide,
then remove the 'addtree' from scripts/Kbuild.include
but I have not been able to find time for that.

This is a new file, so just suggested to add '$(srctree)/'



If you want to know the context:
https://patchwork.kernel.org/patch/9632347/


--=20
Best Regards
Masahiro Yamada
