Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36144 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbeIUBtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 21:49:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/4] [media] ad5820: Add support for enable pin
Date: Thu, 20 Sep 2018 23:04:46 +0300
Message-ID: <6867138.NTEK45P8Ux@avalon>
In-Reply-To: <1887575.If169ivQRG@avalon>
References: <20180920161912.17063-2-ricardo.ribalda@gmail.com> <CAPybu_2mNE7Jmfm2n60Z9Hk_iO+-zLgtu4xn72pJUSXBitVg=g@mail.gmail.com> <1887575.If169ivQRG@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, 20 September 2018 23:04:21 EEST Laurent Pinchart wrote:
> Hi Ricardo,
> 
> On Thursday, 20 September 2018 22:12:44 EEST Ricardo Ribalda Delgado wrote:
> > On Thu, Sep 20, 2018 at 9:08 PM Pavel Machek <pavel@ucw.cz> wrote:
> > > On Thu 2018-09-20 21:06:16, Ricardo Ribalda Delgado wrote:
> > >> On Thu, Sep 20, 2018 at 8:54 PM Pavel Machek <pavel@ucw.cz> wrote:
> > >>> On Thu 2018-09-20 20:45:52, Ricardo Ribalda Delgado wrote:
> > >>>> This patch adds support for a programmable enable pin. It can be
> > >>>> used in situations where the ANA-vcc is not configurable (dummy-
> > >>>> regulator), or just to have a more fine control of the power saving.
> > >>>> 
> > >>>> The use of the enable pin is optional.
> > >>>> 
> > >>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> > >>> 
> > >>> Do we really want to do that?
> > >>> 
> > >>> Would it make more sense to add gpio-regulator and connect ad5820 to
> > >>> it in such case?
> > >> 
> > >> My board (based on db820c)  has both:
> > >> 
> > >> ad5820: dac@0c {
> > >> 
> > >>    compatible = "adi,ad5820";
> > >>    reg = <0x0c>;
> > >>    
> > >>    VANA-supply = <&pm8994_l23>;
> > >>    enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
> > >> 
> > >> };
> > > 
> > > Well, I'm sure you could have gpio-based regulator powered from
> > > pm8994_l23, and outputting to ad5820.
> > > 
> > > Does ad5820 chip have a gpio input for enable?
> > 
> > xshutdown pin:
> > http://www.analog.com/media/en/technical-documentation/data-sheets/AD5821.
> > pd f
> > 
> > (AD5820,AD5821, and AD5823 are compatibles, or at least that is waht
> > the module manufacturer says :)
> 
> Is that the pin that msmgpio 26 is connected to on your board ?
> 
> I'd argue that the GPIO should be called xshutdown in that case, as DT
> usually uses the pin name, but there's precedent of using well-known names
> for pins with the same functionality. In any case you should update the DT
> bindings to document the new property, and clearly explain that it
> describes the GPIO connected to the xshutdown pin. Please CC the
> devicetree@vger.kernel.org mailing list on the bindings change (they
> usually like bindings changes to be split to a separate patch).

And now I've noticed patch 3/4 :-/ Please scratch this.

-- 
Regards,

Laurent Pinchart
