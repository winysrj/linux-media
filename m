Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37142 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdLSNTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 08:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <20171219130537.2viv4wjcp4i3mdkj@valkosipuli.retiisi.org.uk>
References: <20171211013146.2497-1-wenyou.yang@microchip.com>
 <20171211013146.2497-3-wenyou.yang@microchip.com> <20171219092246.3usg5mdyi27ivqlq@valkosipuli.retiisi.org.uk>
 <CAOMZO5BHSJv01SwZ2YNtGZTjMtOuOktET43qriK2fQ+jhE2TDA@mail.gmail.com> <20171219130537.2viv4wjcp4i3mdkj@valkosipuli.retiisi.org.uk>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 19 Dec 2017 11:19:06 -0200
Message-ID: <CAOMZO5C5NJMffBEv2cdqKqUnTMQEYkqzN1JnJMS21PWtKuabnA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] media: i2c: Add the ov7740 image sensor driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Philippe Ombredanne <pombredanne@nexb.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Songjun Wu <songjun.wu@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, Dec 19, 2017 at 11:05 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

> I guess it depends on who do you ask and when. Looking at what has been
> recently merged to media tree master, the latter is preferred.

Just did 'git grep SPDX drivers/media'

and it consistently shows // SPDX style for C files.
