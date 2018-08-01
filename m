Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:64414 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732437AbeHAK6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Aug 2018 06:58:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.macqel.be (Postfix) with ESMTP id 06FFB130D33
        for <linux-media@vger.kernel.org>; Wed,  1 Aug 2018 11:13:43 +0200 (CEST)
Received: from smtp2.macqel.be ([127.0.0.1])
        by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9e9msJHoUvoP for <linux-media@vger.kernel.org>;
        Wed,  1 Aug 2018 11:13:41 +0200 (CEST)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
        by smtp2.macqel.be (Postfix) with ESMTP id 659E5130D0F
        for <linux-media@vger.kernel.org>; Wed,  1 Aug 2018 11:13:41 +0200 (CEST)
Date: Wed, 1 Aug 2018 11:13:41 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: linux-media@vger.kernel.org
Subject: BUG ? v4l2_spi_subdev_init does not produce unique names
Message-ID: <20180801091341.GA32341@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello v4l2 gurus,

Sorry for the people who already have read my previous mail.  I changed
the subject to make it more sexy :)

Documentation/media/kapi/v4l2-subdev.rst states :

"Afterwards you need to initialize :c:type:`sd <v4l2_subdev>`->name with a
unique name and set the module owner. This is done for you if you use the
i2c helper functions"

I try to write a v4l2 spi driver and use hence v4l2_spi_subdev_init, not
v4l2_i2c_subdev_init.

In v4l2_i2c_subdev_init, subdev name is initialised by

        snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
                client->dev.driver->name, i2c_adapter_id(client->adapter),
                client->addr);

In v4l2_spi_subdev_init, subdev name is initialised by

        strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));

This does not give similar results :(

with i2c, subdev name is set as "xxx %d-%04x", giving a unique name to the
subdev.

with spi, subdev name is set as "xxx", giving the same name to all similar
subdevs on the same host

Is that intentional or an oversight, and if so, how should that be fixed ?

Best regards

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
