Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdBIXGR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 18:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
References: <20161023200355.GA5391@amd> <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd> <20161222100104.GA30917@amd> <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd> <20170203123508.GA10286@amd> <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223017.GA18807@amd> <CAL_JsqKSHvg+iB-SRd=YthauGP8mWeVF0j8X-fgLchwtOppH8A@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 9 Feb 2017 17:03:03 -0600
Message-ID: <CAL_JsqLfbAxBbXOyK0QOCc=wPe6=a+qyrAwtdbt3DtspK6oiaw@mail.gmail.com>
Subject: Re: [PATCH] devicetree: Add video bus switch
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 9, 2017 at 5:02 PM, Rob Herring <robh@kernel.org> wrote:
> On Wed, Feb 8, 2017 at 4:30 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> On Wed 2017-02-08 15:36:09, Rob Herring wrote:
>>> On Fri, Feb 03, 2017 at 01:35:08PM +0100, Pavel Machek wrote:
>>> >
>>> > N900 contains front and back camera, with a switch between the
>>> > two. This adds support for the switch component, and it is now
>>> > possible to select between front and back cameras during runtime.
>>> >
>>> > This adds documentation for the devicetree binding.
>>> >
>>> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
>>> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
>>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>> >
>>> >
>>> > diff --git a/Documentation/devicetree/bindings/media/video-bus-switch.txt b/Documentation/devicetree/bindings/media/video-bus-switch.txt
>>> > new file mode 100644
>>> > index 0000000..1b9f8e0
>>> > --- /dev/null
>>> > +++ b/Documentation/devicetree/bindings/media/video-bus-switch.txt
>>> > @@ -0,0 +1,63 @@
>>> > +Video Bus Switch Binding
>>> > +========================
>>>
>>> I'd call it a mux rather than switch.
>>
>> It is a switch, not a multiplexor (
>> https://en.wikipedia.org/wiki/Multiplexing ). Only one camera can
>> operate at a time.
>
> It's no different than an i2c mux. It's one at a time.
>
>>
>>> BTW, there's a new mux-controller binding under review you might look
>>> at. It would only be needed here if the mux ctrl also controls other
>>> things.
>>
>> Do you have a pointer?
>
> Let me Google that for you:

https://lwn.net/Articles/713971/

>
>>
>>> > +Required Port nodes
>>> > +===================
>>> > +
>>> > +More documentation on these bindings is available in
>>> > +video-interfaces.txt in the same directory.
>>> > +
>>> > +reg                : The interface:
>>> > +             0 - port for image signal processor
>>> > +             1 - port for first camera sensor
>>> > +             2 - port for second camera sensor
>>>
>>> This could be used for display side as well. So describe these just as
>>> inputs and outputs.
>>
>> I'd prefer not to confuse people. I guess that would be 0 -- output
>> port, 1, 2 -- input ports... But this is media data, are you sure it
>> is good idea to change this?
>
> And I'd prefer something that can be reused by others.
>
>>
>>                                                                         Pavel
>> --
>> (english) http://www.livejournal.com/~pavelmachek
>> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
