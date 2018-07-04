Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:44006 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbeGDO0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 10:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAMty3ZCLwqBs46z5TJ+rqtuWA+-ickBf94jrJpy+b-QA1pYGDw@mail.gmail.com>
References: <CAMty3ZAMjCKv1BtLnobRZUzp=9Xu1gY5+R3Zi-JuobAJZQrXxg@mail.gmail.com>
 <20180531190659.xdp4q2cjro33aihq@pengutronix.de> <CAMty3ZCeR3uEx8oy18-Ur7ma7pciKUf_myDk6_SpWvxc6DvygQ@mail.gmail.com>
 <CAOMZO5AOpOSAx=L4tOU1Na6hm8Tex3PHNxCYDB81C0+NPHzTZQ@mail.gmail.com>
 <20180703184117.GC5611@w540> <CAMty3ZCWztkM2oEaKQRVmMkA0C1V6b9Oj59DBX9XAWAybZbRAw@mail.gmail.com>
 <CAMty3ZCLwqBs46z5TJ+rqtuWA+-ickBf94jrJpy+b-QA1pYGDw@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 4 Jul 2018 11:26:43 -0300
Message-ID: <CAOMZO5BmEZ4dbtm3ZsT86ZoOMj-8oMKOZSmskUJf4n6LGkkFSg@mail.gmail.com>
Subject: Re: i.MX6 MIPI-CSI2 OV5640 Camera testing on Mainline Linux
To: Jagan Teki <jagan@amarulasolutions.com>
Cc: jacopo mondi <jacopo@jmondi.org>,
        Philipp Zabel <pza@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Discussion of the development of and with GStreamer
        <gstreamer-devel@lists.freedesktop.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jagan,

On Wed, Jul 4, 2018 at 3:57 AM, Jagan Teki <jagan@amarulasolutions.com> wrote:

> I have similar issue, it doesn't work.

What is the error? Is it still the LP11 timeout?

Does this error go away if you undo the changes from commit 476dec012f4c654 ?
