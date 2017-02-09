Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751851AbdBIXKG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Feb 2017 18:10:06 -0500
MIME-Version: 1.0
In-Reply-To: <20170208223451.GB18807@amd>
References: <20161023200355.GA5391@amd> <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd> <20161222100104.GA30917@amd> <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd> <20170203123508.GA10286@amd> <20170208213609.lnemfbzitee5iur2@rob-hp-laptop>
 <20170208223451.GB18807@amd>
From: Rob Herring <robh@kernel.org>
Date: Thu, 9 Feb 2017 16:58:29 -0600
Message-ID: <CAL_JsqK2RHLoLc_ikHzP2B5_Lof2g9NG+zvamGe4o1ko1ggGQA@mail.gmail.com>
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

On Wed, Feb 8, 2017 at 4:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > +
>> > +This is a binding for a gpio controlled switch for camera interfaces. Such a
>> > +device is used on some embedded devices to connect two cameras to the same
>> > +interface of a image signal processor.
>> > +
>> > +Required properties
>> > +===================
>> > +
>> > +compatible : must contain "video-bus-switch"
>>
>> video-bus-gpio-mux
>
> Sakari already asked for rename here. I believe I waited reasonable
> time, but got no input from you, so I did rename it. Now you decide on
> different name.
>
> Can we either get timely reactions or less bikeshedding?

You mean less than 5 days because I don't see any other version of
this? But in short, no, you can't.

Rob
