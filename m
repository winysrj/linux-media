Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47164 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeKDINm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 03:13:42 -0500
Subject: Re: linux-next: Tree for Nov 2 (compiler-gcc.h)
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Rohdewald <wolfgang@rohdewald.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20181102143018.09feb051@canb.auug.org.au>
 <CANiq72m65bQZefAoFF5dTUB-rPzm4vofZFnDn0nYBG3MsGrjZg@mail.gmail.com>
 <20181103002218.3bd015b3@canb.auug.org.au>
 <CANiq72=kHErmujzMgM4akXeoWkSR0Q3VLd-6Mwiaj5mGan8yZw@mail.gmail.com>
 <20227164-2ef3-d684-bf4e-fb69ac828789@infradead.org>
 <CANiq72kBx4+R4SVFZ_iTfk61=oHMLwvhHdmBDe=cBFP5Lp7bSQ@mail.gmail.com>
 <6ecaed34-eb66-24ed-e6c7-e33f9583be5e@infradead.org>
 <CANiq72mqO36FotJ6pHQpAB18DLEYV+kSL64Sc+A6yoqDu47bAg@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <36ee26a8-af2a-823a-1aa0-f5531c612ff7@infradead.org>
Date: Sat, 3 Nov 2018 16:00:51 -0700
MIME-Version: 1.0
In-Reply-To: <CANiq72mqO36FotJ6pHQpAB18DLEYV+kSL64Sc+A6yoqDu47bAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/3/18 3:58 PM, Miguel Ojeda wrote:
> On Sat, Nov 3, 2018 at 5:10 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> No plugins are enabled.
>> The failing randconfig file (for x86_64) is attached.
> 
> Confirmed with a built-from-sources 4.8.5 on current master
> (d2ff0ff2c23f). The ICE also happens with 4.6.4. With 8.1.0, however,
> we get an error instead:
> 
> In file included from drivers/media/usb/dvb-usb/pctv452e.c:20:
> drivers/media/usb/dvb-usb/pctv452e.c: In function 'pctv452e_frontend_attach':
> ./drivers/media/dvb-frontends/stb0899_drv.h:151:36: error: weak
> declaration of 'stb0899_attach' being applied to a already existing,
> static definition
>  static inline struct dvb_frontend *stb0899_attach(struct
> stb0899_config *config,
>                                     ^~~~~~~~~~~~~~
> 
> Which seems to have been spotted by kbuild months ago:
> 
>   https://lkml.org/lkml/2018/3/10/358
> 
> The problem is in pctv452e_frontend_attach():
> 
> /*
> * dvb_frontend will call dvb_detach for both stb0899_detach
> * and stb0899_release but we only do dvb_attach(stb0899_attach).
> * Increment the module refcount instead.
> */
> symbol_get(stb0899_attach);
> 
> Here symbol_get() is declaring a weak function (due to
> !CONFIG_MODULES) while this definition in stb0899_drv.h occurs (due to
> !CONFIG_DVB_STB0899):
> 
> static inline struct dvb_frontend *stb0899_attach(struct stb0899_config *config,
>   struct i2c_adapter *i2c)
> {
> printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
> return NULL;
> }
> 
> I guess pctv452e should require CONFIG_DVB_STB0899, or similar. CC'ing
> Mauro, Wolfgang, linux-media.
> 
> Hope that helps!

Thanks for digging into this.  :)

cheers.
-- 
~Randy
