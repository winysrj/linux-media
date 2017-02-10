Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40660 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751141AbdBJWRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 17:17:49 -0500
Date: Sat, 11 Feb 2017 00:17:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170210221742.GI13854@valkosipuli.retiisi.org.uk>
References: <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd>
 <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
 <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
 <20170210195435.GA1615@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170210195435.GA1615@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Fri, Feb 10, 2017 at 08:54:35PM +0100, Pavel Machek wrote:
> 
> > >>> > diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.txt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > >>> > new file mode 100644
> > >>> > index 0000000..1b9f8e0
> > >>> > --- /dev/null
> > >>> > +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
> > >>> > @@ -0,0 +1,63 @@
> > >>> > +Video Bus Switch Binding
> > >>> > +========================
> > >>>
> > >>> I'd call it a mux rather than switch.
> > >>
> > >> It is a switch, not a multiplexor (
> > >> https://en.wikipedia.org/wiki/Multiplexing ). Only one camera can
> > >> operate at a time.
> > >
> > > It's no different than an i2c mux. It's one at a time.
> 
> Take a look at the wikipedia. If you do "one at a time" at 100Hz, you
> can claim it is time-domain multiplex. But we are plain switching the
> cameras. It takes second (or so) to setup the pipeline.
> 
> This is not multiplex.

The functionality is still the same, isn't it? Does it change what it is if
the frequency might be 100 Hz or 0,01 Hz?

I was a bit annoyed for having to have two drivers for switching the source
(one for GPIO, another for syscon / register), where both of the drivers
would be essentially the same with the minor exception of having a slightly
different means to toggle the mux setting.

The MUX framework adds an API for controlling the MUX. Thus we'll need only
a single driver that uses the MUX framework API for V4L2. As an added bonus,
V4L2 would be in line with the rest of the MUX usage in the kernel.

The set appears to already contain a GPIO MUX. What's needed would be to use
the MUX API instead of direct GPIOs usage.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
