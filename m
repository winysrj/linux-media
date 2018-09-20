Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41296 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbeIUAva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:51:30 -0400
MIME-Version: 1.0
References: <20180920161912.17063-2-ricardo.ribalda@gmail.com>
 <20180920184552.4919-1-ricardo.ribalda@gmail.com> <20180920185405.GA26589@amd>
In-Reply-To: <20180920185405.GA26589@amd>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Sep 2018 21:06:16 +0200
Message-ID: <CAPybu_2hjrq=r+kpAHKxX59gOXfbqGf9CUPh9CNqv7WGqJsrQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] [media] ad5820: Add support for enable pin
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel

On Thu, Sep 20, 2018 at 8:54 PM Pavel Machek <pavel@ucw.cz> wrote:
>
> On Thu 2018-09-20 20:45:52, Ricardo Ribalda Delgado wrote:
> > This patch adds support for a programmable enable pin. It can be used in
> > situations where the ANA-vcc is not configurable (dummy-regulator), or
> > just to have a more fine control of the power saving.
> >
> > The use of the enable pin is optional.
> >
> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> Do we really want to do that?
>
> Would it make more sense to add gpio-regulator and connect ad5820 to
> it in such case?
>

My board (based on db820c)  has both:

ad5820: dac@0c {
   compatible = "adi,ad5820";
   reg = <0x0c>;

   VANA-supply = <&pm8994_l23>;
   enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
};



>                                                                 Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Ricardo Ribalda
