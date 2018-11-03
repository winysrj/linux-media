Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37930 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbeKDILT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 03:11:19 -0500
MIME-Version: 1.0
References: <20181102143018.09feb051@canb.auug.org.au> <CANiq72m65bQZefAoFF5dTUB-rPzm4vofZFnDn0nYBG3MsGrjZg@mail.gmail.com>
 <20181103002218.3bd015b3@canb.auug.org.au> <CANiq72=kHErmujzMgM4akXeoWkSR0Q3VLd-6Mwiaj5mGan8yZw@mail.gmail.com>
 <20227164-2ef3-d684-bf4e-fb69ac828789@infradead.org> <CANiq72kBx4+R4SVFZ_iTfk61=oHMLwvhHdmBDe=cBFP5Lp7bSQ@mail.gmail.com>
 <6ecaed34-eb66-24ed-e6c7-e33f9583be5e@infradead.org>
In-Reply-To: <6ecaed34-eb66-24ed-e6c7-e33f9583be5e@infradead.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 3 Nov 2018 23:58:24 +0100
Message-ID: <CANiq72mqO36FotJ6pHQpAB18DLEYV+kSL64Sc+A6yoqDu47bAg@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 2 (compiler-gcc.h)
To: Randy Dunlap <rdunlap@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 3, 2018 at 5:10 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> No plugins are enabled.
> The failing randconfig file (for x86_64) is attached.

Confirmed with a built-from-sources 4.8.5 on current master
(d2ff0ff2c23f). The ICE also happens with 4.6.4. With 8.1.0, however,
we get an error instead:

In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:
drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
./drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak
declaration of 'stb0899_attach' being applied to a already existing,
static definition
 static inline struct dvb_frontend *stb0899_attach(struct
stb0899_config *config,
                                    ^~~~~~~~~~~~~~

Which seems to have been spotted by kbuild months ago:

  https://lkml.org/lkml/2018/3/10/358

The problem is in pctv452e_frontend_attach():

/*
* dvb_frontend will call dvb_detach for both stb0899_detach
* and stb0899_release but we only do dvb_attach(stb0899_attach).
* Increment the module refcount instead.
*/
symbol_get(stb0899_attach);

Here symbol_get() is declaring a weak function (due to
!CONFIG_MODULES) while this definition in stb0899_drv.h occurs (due to
!CONFIG_DVB_STB0899):

static inline struct dvb_frontend *stb0899_attach(struct stb0899_config *config,
  struct i2c_adapter *i2c)
{
printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
return NULL;
}

I guess pctv452e should require CONFIG_DVB_STB0899, or similar. CC'ing
Mauro, Wolfgang, linux-media.

Hope that helps!

Cheers,
Miguel
