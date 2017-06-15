Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway33.websitewelcome.com ([192.185.146.80]:30289 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752059AbdFOUtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 16:49:05 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 291A21683A
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 15:23:56 -0500 (CDT)
Date: Thu, 15 Jun 2017 15:23:55 -0500
Message-ID: <20170615152355.Horde.J4w3Vdm6wjB3m5sAd3fP5WR@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Erik Andren <erik.andren@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [media-m5602-po1030] question about return value check
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1227044 I ran into the following piece  
of code at drivers/media/usb/gspca/m5602/m5602_po1030.c:280:

280int po1030_start(struct sd *sd)
281{
282        struct cam *cam = &sd->gspca_dev.cam;
283        int i, err = 0;
284        int width = cam->cam_mode[sd->gspca_dev.curr_mode].width;
285        int height = cam->cam_mode[sd->gspca_dev.curr_mode].height;
286        int ver_offs = cam->cam_mode[sd->gspca_dev.curr_mode].priv;
287        u8 data;
288
289        switch (width) {
290        case 320:
291                data = PO1030_SUBSAMPLING;
292                err = m5602_write_sensor(sd, PO1030_CONTROL3, &data, 1);
293                if (err < 0)
294                        return err;
295
296                data = ((width + 3) >> 8) & 0xff;
297                err = m5602_write_sensor(sd, PO1030_WINDOWWIDTH_H,  
&data, 1);
298                if (err < 0)
299                        return err;
300
301                data = (width + 3) & 0xff;
302                err = m5602_write_sensor(sd, PO1030_WINDOWWIDTH_L,  
&data, 1);
303                if (err < 0)
304                        return err;
305
306                data = ((height + 1) >> 8) & 0xff;
307                err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_H,  
&data, 1);
308                if (err < 0)
309                        return err;
310
311                data = (height + 1) & 0xff;
312                err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_L,  
&data, 1);
313
314                height += 6;
315                width -= 1;
316                break;
317
318        case 640:
319                data = 0;
320                err = m5602_write_sensor(sd, PO1030_CONTROL3, &data, 1);
321                if (err < 0)
322                        return err;
323
324                data = ((width + 7) >> 8) & 0xff;
325                err = m5602_write_sensor(sd, PO1030_WINDOWWIDTH_H,  
&data, 1);
326                if (err < 0)
327                        return err;
328
329                data = (width + 7) & 0xff;
330                err = m5602_write_sensor(sd, PO1030_WINDOWWIDTH_L,  
&data, 1);
331                if (err < 0)
332                        return err;
333
334                data = ((height + 3) >> 8) & 0xff;
335                err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_H,  
&data, 1);
336                if (err < 0)
337                        return err;
338
339                data = (height + 3) & 0xff;
340                err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_L,  
&data, 1);
341
342                height += 12;
343                width -= 2;
344                break;
345        }
346        err = m5602_write_bridge(sd, M5602_XB_SENSOR_TYPE, 0x0c);
347        if (err < 0)
348                return err;
349
350        err = m5602_write_bridge(sd, M5602_XB_LINE_OF_FRAME_H, 0x81);
351        if (err < 0)
352                return err;
353
354        err = m5602_write_bridge(sd, M5602_XB_PIX_OF_LINE_H, 0x82);
355        if (err < 0)
356                return err;
357
358        err = m5602_write_bridge(sd, M5602_XB_SIG_INI, 0x01);
359        if (err < 0)
360                return err;
361
362        err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA,
363                                 ((ver_offs >> 8) & 0xff));
364        if (err < 0)
365                return err;
366
367        err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA, (ver_offs  
& 0xff));
368        if (err < 0)
369                return err;
370
371        for (i = 0; i < 2 && !err; i++)
372                err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA, 0);
373        if (err < 0)
374                return err;
375
376        err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA, (height  
 >> 8) & 0xff);
377        if (err < 0)
378                return err;
379
380        err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA, (height & 0xff));
381        if (err < 0)
382                return err;
383
384        for (i = 0; i < 2 && !err; i++)
385                err = m5602_write_bridge(sd, M5602_XB_VSYNC_PARA, 0);
386
387        for (i = 0; i < 2 && !err; i++)
388                err = m5602_write_bridge(sd, M5602_XB_SIG_INI, 0);
389
390        for (i = 0; i < 2 && !err; i++)
391                err = m5602_write_bridge(sd, M5602_XB_HSYNC_PARA, 0);
392        if (err < 0)
393                return err;
394
395        err = m5602_write_bridge(sd, M5602_XB_HSYNC_PARA, (width >>  
8) & 0xff);
396        if (err < 0)
397                return err;
398
399        err = m5602_write_bridge(sd, M5602_XB_HSYNC_PARA, (width & 0xff));
400        if (err < 0)
401                return err;
402
403        err = m5602_write_bridge(sd, M5602_XB_SIG_INI, 0);
404        return err;
405}

The issue here is that the value contained in variable _err_ at lines  
312 and 340 is not being evaluated as it happens in other instances  
after calling m5602_write_sensor().

I'm suspicious this is not the original intention and maybe a patch  
like the following could be applied:

--- a/drivers/media/usb/gspca/m5602/m5602_po1030.c+++  
b/drivers/media/usb/gspca/m5602/m5602_po1030.c@@ -310,6 +310,8 @@ int  
po1030_start(struct sd *sd)

                 data = (height + 1) & 0xff;
                 err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_L, &data, 1);
+               if (err < 0)
+                       return err;

                 height += 6;
                 width -= 1;
@@ -338,6 +340,8 @@ int po1030_start(struct sd *sd)

                 data = (height + 3) & 0xff;
                 err = m5602_write_sensor(sd, PO1030_WINDOWHEIGHT_L, &data, 1);
+               if (err < 0)
+                       return err;

                 height += 12;
                 width -= 2;


What do you think?

It would be great to hear your opinions about it.

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva
