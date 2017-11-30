Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:43382 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdK3KZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 05:25:23 -0500
Received: by mail-it0-f67.google.com with SMTP id u62so7733153ita.2
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 02:25:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171130095825.ubdg6swiupe7rv6d@mwanda>
References: <20171130095825.ubdg6swiupe7rv6d@mwanda>
From: Menion <menion@gmail.com>
Date: Thu, 30 Nov 2017 11:25:02 +0100
Message-ID: <CAJVZm6ebZt13Zf45+zCbVZuM1bVT+bWTDe-6c5GvgpM8UXVwMA@mail.gmail.com>
Subject: Re: [bug report] media: dvb_frontend: cleanup ioctl handling logic
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
Is anyone working on adding compact_ioctl?
So far it is impossible to use linux-media from 32bit userland on 64bit kernels
Bye

2017-11-30 10:58 GMT+01:00 Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Mauro Carvalho Chehab,
>
> The patch d73dcf0cdb95: "media: dvb_frontend: cleanup ioctl handling
> logic" from Sep 18, 2017, leads to the following static checker
> warning:
>
>         drivers/media/dvb-core/dvb_frontend.c:2469 dvb_frontend_handle_ioctl()
>         error: uninitialized symbol 'err'.
>
> drivers/media/dvb-core/dvb_frontend.c
>   2427          case FE_READ_UNCORRECTED_BLOCKS:
>   2428                  if (fe->ops.read_ucblocks) {
>   2429                          if (fepriv->thread)
>   2430                                  err = fe->ops.read_ucblocks(fe, parg);
>   2431                          else
>   2432                                  err = -EAGAIN;
>   2433                  }
>
> "err" isn't initialized if ->ops.read_ucblocks is NULL.
>
>   2434                  break;
>   2435
>   2436          /* DEPRECATED DVBv3 ioctls */
>   2437
>   2438          case FE_SET_FRONTEND:
>   2439                  err = dvbv3_set_delivery_system(fe);
>   2440                  if (err)
>   2441                          break;
>   2442
>   2443                  err = dtv_property_cache_sync(fe, c, parg);
>   2444                  if (err)
>   2445                          break;
>   2446                  err = dtv_set_frontend(fe);
>   2447                  break;
>   2448          case FE_GET_EVENT:
>   2449                  err = dvb_frontend_get_event (fe, parg, file->f_flags);
>   2450                  break;
>   2451
>   2452          case FE_GET_FRONTEND: {
>   2453                  struct dtv_frontend_properties getp = fe->dtv_property_cache;
>   2454
>   2455                  /*
>   2456                   * Let's use our own copy of property cache, in order to
>   2457                   * avoid mangling with DTV zigzag logic, as drivers might
>   2458                   * return crap, if they don't check if the data is available
>   2459                   * before updating the properties cache.
>   2460                   */
>   2461                  err = dtv_get_frontend(fe, &getp, parg);
>   2462                  break;
>   2463          }
>   2464
>   2465          default:
>   2466                  return -ENOTSUPP;
>   2467          } /* switch */
>   2468
>   2469          return err;
>                 ^^^^^^^^^^
>   2470  }
>
> regards,
> dan carpenter
