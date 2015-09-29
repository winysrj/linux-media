Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:52542 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbbI2GuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 02:50:16 -0400
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com [209.85.215.52])
	by imap.netup.ru (Postfix) with ESMTPA id 5EC41732021
	for <linux-media@vger.kernel.org>; Tue, 29 Sep 2015 09:50:14 +0300 (MSK)
Received: by laer8 with SMTP id r8so56194806lae.2
        for <linux-media@vger.kernel.org>; Mon, 28 Sep 2015 23:50:13 -0700 (PDT)
MIME-Version: 1.0
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 29 Sep 2015 09:49:54 +0300
Message-ID: <CAK3bHNWkeakZP0cEi+U=GjmPa0jN9qWC4seyS6+ih8inzvmbXQ@mail.gmail.com>
Subject: Re: [kbuild-all] drivers/media/dvb-frontends/cxd2841er.c:2393:1:
 warning: the frame size of 2992 bytes is larger than 2048 bytes
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Kozlov Sergey <serjk@netup.ru>, kbuild-all@01.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Andrey Ryabinin <a.ryabinin@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fengguang,

This is about 'Kernel Address sanitizer (KASan)'.

not only cxd2841 affected but some others:

drivers/media/tuners/r820t.c:1333:1: warning: the frame size of 2904
bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:1858:1: warning: the frame size
of 3008 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:2141:1: warning: the frame size
of 2104 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:2513:1: warning: the frame size
of 2304 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:4565:1: warning: the frame size
of 2096 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:1956:1: warning: the frame size
of 3264 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:1599:1: warning: the frame size
of 5296 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:1211:1: warning: the frame size
of 2080 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:4250:1: warning: the frame size
of 4840 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:4759:1: warning: the frame size
of 2056 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:1168:1: warning: the frame size
of 2080 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:2073:1: warning: the frame size
of 2552 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:3095:1: warning: the frame size
of 5864 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv090x.c:3436:1: warning: the frame size
of 6816 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/stv0367.c:3147:1: warning: the frame size
of 4144 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/cxd2841er.c:2404:1: warning: the frame
size of 2984 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/cxd2841er.c:2282:1: warning: the frame
size of 4336 bytes is larger than 2048 bytes [-Wframe-larger-than=]
drivers/media/dvb-frontends/si2165.c:683:1: warning: the frame size of
2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]

cause of this 'Kernel Address sanitizer (KASan)' is enabled in your
config. With gcc-4.9 kasan was disabled in compile time because of:
"scripts/Makefile.kasan:23: CONFIG_KASAN: compiler does not support
all options. Trying minimal configuration"

but with gcc-5 it's enabled.

and
objdump -d drivers/media/dvb-frontends/cxd2841er.o

shows that KASan adds some instructions to 'cxd2841er_sleep_tc' which
writes necessary data to -fasan-shadow-offset=0xdffffc0000000000:
    1476:       48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
...
    14d3:       c7 00 f1 f1 f1 f1       movl   $0xf1f1f1f1,(%rax)
    14d9:       c7 40 04 01 f4 f4 f4    movl   $0xf4f4f401,0x4(%rax)
    14e0:       c7 40 08 f2 f2 f2 f2    movl   $0xf2f2f2f2,0x8(%rax)
    14e7:       c7 40 0c 01 f4 f4 f4    movl   $0xf4f4f401,0xc(%rax)
...

and function will grow and we get '-Wframe-larger-than=2048' warnings.

So, this warning looks normal  (until they less than 8K I think) for
configurations with KASan enabled.

I can suggest:
* ignore this warning if KASan enabled
* Increase -Wframe-larger-than=2048 to -Wframe-larger-than=8192 if
KASan enabled ( CONFIG_FRAME_WARN=8192 in kernel .config)


2015-09-25 12:46 GMT+03:00 Fengguang Wu <fengguang.wu@intel.com>:
> Hi Abylay,
>
> This warning can be reproduced with gcc-5.2:
>
> =============== commit a6dc60ff1 ===============
> /home/wfg/linux
> HEAD is now at a6dc60ff... [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
> /home/wfg/linux/obj-compiletest
>
> make ARCH=x86_64 drivers/media/dvb-frontends/cxd2841er.o
>
> grep -a -F drivers/media/dvb-frontends/cxd2841er.c /tmp/build-err-a6dc60ff1209df29ee4668024e93d31f31421932-wfg --color
> ../drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_sleep_tc':
> ../drivers/media/dvb-frontends/cxd2841er.c:2393:1: warning: the frame size of 2992 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>  }
>  ^
> ../drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_set_frontend_tc':
> ../drivers/media/dvb-frontends/cxd2841er.c:2274:1: warning: the frame size of 4336 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>  }
>  ^
>
> =============== PREV commit e025273b86fb4a6440192b809e05332777c3faa5 ===============
> /home/wfg/linux
> Previous HEAD position was a6dc60ff... [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
> HEAD is now at e025273... [media] lnbh25: LNBH25 SEC controller driver
> /home/wfg/linux/obj-compiletest
>
> make ARCH=x86_64 drivers/media/dvb-frontends/cxd2841er.o
>
> !!! BUILD ERROR !!!
> grep -a -F drivers/media/dvb-frontends/cxd2841er.c /tmp/build-err-e025273b86fb4a6440192b809e05332777c3faa5-wfg --color
>
> =============== linus/master linus/master ===============
> /home/wfg/linux
> Previous HEAD position was e025273... [media] lnbh25: LNBH25 SEC controller driver
> HEAD is now at 8e64a73... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
> /home/wfg/linux/obj-compiletest
>
> make ARCH=x86_64 drivers/media/dvb-frontends/cxd2841er.o
>
> grep -a -F drivers/media/dvb-frontends/cxd2841er.c /tmp/build-err-8e64a7331702b7888ccf84b2b9ff46ab8e167c7f-wfg --color
> ../drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_sleep_tc':
> ../drivers/media/dvb-frontends/cxd2841er.c:2401:1: warning: the frame size of 2984 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>  }
>  ^
> ../drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_set_frontend_tc':
> ../drivers/media/dvb-frontends/cxd2841er.c:2282:1: warning: the frame size of 4336 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>  }
>  ^
>
> Thanks,
> Fengguang
>
> On Fri, Sep 25, 2015 at 12:21:57PM +0300, Abylay Ospan wrote:
>> Hello,
>>
>> I cannot reproduce this warning. I'm compiling with your config and
>> following commands:
>>
>>   git checkout a6dc60ff1209df29ee4668024e93d31f31421932
>>   make ARCH=x86_64
>>
>> my gcc version is 4.9.2 (Ubuntu 4.9.2-10ubuntu13)
>>
>> warning doesn't appear even if I set:
>> CONFIG_FRAME_WARN=128
>>
>> Please point me if problem still exist.
>>
>> thanks !
>>
>>
>>
>> 2015-09-17 9:05 GMT+03:00 kbuild test robot <fengguang.wu@intel.com>:
>> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> > head:   72714841b705a5b9bccf37ee85a62352bee3a3ef
>> > commit: a6dc60ff1209df29ee4668024e93d31f31421932 [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C demodulator driver
>> > date:   5 weeks ago
>> > config: x86_64-randconfig-b0-09171322 (attached as .config)
>> > reproduce:
>> >   git checkout a6dc60ff1209df29ee4668024e93d31f31421932
>> >   # save the attached .config to linux build tree
>> >   make ARCH=x86_64
>> >
>> > All warnings (new ones prefixed by >>):
>> >
>> >    drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_sleep_tc':
>> >>> drivers/media/dvb-frontends/cxd2841er.c:2393:1: warning: the frame size of 2992 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>> >     }
>> >     ^
>> >    drivers/media/dvb-frontends/cxd2841er.c: In function 'cxd2841er_set_frontend_tc':
>> >    drivers/media/dvb-frontends/cxd2841er.c:2274:1: warning: the frame size of 4336 bytes is larger than 2048 bytes [-Wframe-larger-than=]
>> >     }
>> >     ^
>> >
>> > vim +2393 drivers/media/dvb-frontends/cxd2841er.c
>> >
>> >   2377                  case SYS_DVBC_ANNEX_A:
>> >   2378                          cxd2841er_active_c_to_sleep_tc(priv);
>> >   2379                          break;
>> >   2380                  default:
>> >   2381                          dev_warn(&priv->i2c->dev,
>> >   2382                                  "%s(): unknown delivery system %d\n",
>> >   2383                                  __func__, priv->system);
>> >   2384                  }
>> >   2385          }
>> >   2386          if (priv->state != STATE_SLEEP_TC) {
>> >   2387                  dev_err(&priv->i2c->dev, "%s(): invalid state %d\n",
>> >   2388                          __func__, priv->state);
>> >   2389                  return -EINVAL;
>> >   2390          }
>> >   2391          cxd2841er_sleep_tc_to_shutdown(priv);
>> >   2392          return 0;
>> >> 2393  }
>> >   2394
>> >   2395  static int cxd2841er_send_burst(struct dvb_frontend *fe,
>> >   2396                                  enum fe_sec_mini_cmd burst)
>> >   2397  {
>> >   2398          u8 data;
>> >   2399          struct cxd2841er_priv *priv  = fe->demodulator_priv;
>> >   2400
>> >   2401          dev_dbg(&priv->i2c->dev, "%s(): burst mode %s\n", __func__,
>> >
>> > ---
>> > 0-DAY kernel test infrastructure                Open Source Technology Center
>> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>>
>>
>>
>> --
>> Abylay Ospan,
>> NetUP Inc.
>> http://www.netup.tv
>> _______________________________________________
>> kbuild-all mailing list
>> kbuild-all@lists.01.org
>> https://lists.01.org/mailman/listinfo/kbuild-all



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
