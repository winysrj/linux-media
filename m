Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45197 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbeKOBbA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:31:00 -0500
Received: by mail-ed1-f66.google.com with SMTP id d39so10721749edb.12
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 07:27:18 -0800 (PST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com. [209.85.128.44])
        by smtp.gmail.com with ESMTPSA id j22-v6sm6924398edh.47.2018.11.14.07.27.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 07:27:17 -0800 (PST)
Received: by mail-wm1-f44.google.com with SMTP id u13-v6so15164866wmc.4
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 07:27:17 -0800 (PST)
MIME-Version: 1.0
References: <20181114145934.26855-1-maxime.ripard@bootlin.com> <20181114145934.26855-3-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-3-maxime.ripard@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 14 Nov 2018 23:27:08 +0800
Message-ID: <CAGb2v648GKwEb5kD+Tzw0o2tPK5HAcccP98_QoYKY9u7SJtdLw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] media: sun6i: Add A31 compatible
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?Q?Myl=C3=A8ne_Josserand?= <mylene.josserand@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2018 at 10:59 PM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> The first device that used that IP was the A31. Add it to our list of
> compatibles.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Chen-Yu Tsai <wens@csie.org>
