Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33792 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753100AbcITAvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 20:51:43 -0400
Received: by mail-wm0-f65.google.com with SMTP id l132so681432wmf.1
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2016 17:51:42 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
        <axdoomer@gmail.com>
Date: Mon, 19 Sep 2016 20:51:41 -0400
Message-ID: <CAKTMqxtREAB--eBQrQZJ7zH5BDnD=VmOkhrGfQgoU5-euwVvRw@mail.gmail.com>
Subject: Null pointer dereference in ngene-core.c
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi people,

In the file "/linux/drivers/media/pci/ngene/ngene-core.c", there is a
null pointer dereference at line 1480.

Code in the function "static int init_channel(struct ngene_channel *chan)"
======================================
if (io & NGENE_IO_TSIN) {
    chan->fe = NULL;                      // Set to NULL
    if (ni->demod_attach[nr]) {         // First condition
       ret = ni->demod_attach[nr](chan);
            if (ret < 0)                           // Another condition
                goto err;                         // Goto that avoids
the problem
    }
    if (chan->fe && ni->tuner_attach[nr]) {     // Condition that
tests the null pointer
        ret = ni->tuner_attach[nr](chan);
        if (ret < 0)
            goto err;
    }
}
=====================================

"chan->fe" is set to NULL, then it tests for something (I have no idea
what it's doing, I know nothing about this driver), if the results of
the first two if conditions fail to reach the goto, then it will test
the condition with the null pointer, which will cause a crash. I don't
know if the kernel can recover from null pointers, I think not.

--Alexandre-Xavier
