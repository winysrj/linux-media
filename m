Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35636 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdGXJmB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 05:42:01 -0400
Received: by mail-lf0-f51.google.com with SMTP id t128so11985517lff.2
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 02:42:00 -0700 (PDT)
Date: Mon, 24 Jul 2017 11:41:58 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Naman Jain <nsahula.photo.sharing@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: adv7281m and rcar-vin problem
Message-ID: <20170724094158.GA22320@bigcity.dyn.berto.se>
References: <CAPD8ABUMQgL88WdTHLsVuGRqJR46TJuJ4jHzPm7bgdBJp9k_sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPD8ABUMQgL88WdTHLsVuGRqJR46TJuJ4jHzPm7bgdBJp9k_sw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Naman,

On 2017-07-24 14:30:52 +0530, Naman Jain wrote:
> i am using renesas soc with video decoder adv7281m
> i have done thr device tree configuration by following dt bindings
> i am getting timeout of reading the phy clock lane, after i start streaming
> and nothing is displayed on the screen
> kindly help me in configuration

To be able to try and help you I would need a lot more information. For 
starters:

- Which kernel version are you using?

- How dose the device tree nodes for VIN and ADV7281m look like?

-- 
Regards,
Niklas Söderlund
