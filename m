Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18100 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdK3J6i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 04:58:38 -0500
Date: Thu, 30 Nov 2017 12:58:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] media: dvb_frontend: cleanup ioctl handling logic
Message-ID: <20171130095825.ubdg6swiupe7rv6d@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch d73dcf0cdb95: "media: dvb_frontend: cleanup ioctl handling
logic" from Sep 18, 2017, leads to the following static checker
warning:

	drivers/media/dvb-core/dvb_frontend.c:2469 dvb_frontend_handle_ioctl()
	error: uninitialized symbol 'err'.

drivers/media/dvb-core/dvb_frontend.c
  2427          case FE_READ_UNCORRECTED_BLOCKS:
  2428                  if (fe->ops.read_ucblocks) {
  2429                          if (fepriv->thread)
  2430                                  err = fe->ops.read_ucblocks(fe, parg);
  2431                          else
  2432                                  err = -EAGAIN;
  2433                  }

"err" isn't initialized if ->ops.read_ucblocks is NULL.

  2434                  break;
  2435  
  2436          /* DEPRECATED DVBv3 ioctls */
  2437  
  2438          case FE_SET_FRONTEND:
  2439                  err = dvbv3_set_delivery_system(fe);
  2440                  if (err)
  2441                          break;
  2442  
  2443                  err = dtv_property_cache_sync(fe, c, parg);
  2444                  if (err)
  2445                          break;
  2446                  err = dtv_set_frontend(fe);
  2447                  break;
  2448          case FE_GET_EVENT:
  2449                  err = dvb_frontend_get_event (fe, parg, file->f_flags);
  2450                  break;
  2451  
  2452          case FE_GET_FRONTEND: {
  2453                  struct dtv_frontend_properties getp = fe->dtv_property_cache;
  2454  
  2455                  /*
  2456                   * Let's use our own copy of property cache, in order to
  2457                   * avoid mangling with DTV zigzag logic, as drivers might
  2458                   * return crap, if they don't check if the data is available
  2459                   * before updating the properties cache.
  2460                   */
  2461                  err = dtv_get_frontend(fe, &getp, parg);
  2462                  break;
  2463          }
  2464  
  2465          default:
  2466                  return -ENOTSUPP;
  2467          } /* switch */
  2468  
  2469          return err;
                ^^^^^^^^^^
  2470  }

regards,
dan carpenter
