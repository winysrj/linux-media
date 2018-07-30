Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35046 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeG3LFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 07:05:48 -0400
Date: Mon, 30 Jul 2018 06:31:30 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?UTF-8?B?TWF0aWpldmnEhw==?= <filip.matijevic.pz@gmail.com>,
        mchehab@s-opensource.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: new libv4l2 (was Re: [PATCH, libv4l]: Make libv4l2 usable on
 devices with complex pipeline)
Message-ID: <20180730063122.73a20c55@coco.lan>
In-Reply-To: <20180728211110.GB1152@amd>
References: <20180708213258.GA18217@amd>
        <20180719205344.GA12098@amd>
        <20180723153649.73337c0f@coco.lan>
        <20180728211110.GB1152@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Jul 2018 23:11:10 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > > Add support for opening multiple devices in v4l2_open(), and for
> > > > mapping controls between devices.
> > > > 
> > > > This is necessary for complex devices, such as Nokia N900.
> > > > 
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>    
> > > 
> > > Ping?
> > > 
> > > There's a lot of work to do on libv4l2... timely patch handling would
> > > be nice.  
> > 
> > As we're be start working at the new library in order to support
> > complex cameras, and I don't want to prevent you keeping doing your
> > work, IMHO the best way to keep doing it would be to create two
> > libv4l2 forks:  
> 
> BTW.. new library. Was there decision what langauge to use? I know C
> is obvious choice, but while working on libv4l2, I wished it would be
> Rust...
> 
> Rewriting same routine over and over, with slightly different types
> was not too much fun, and it looked like textbook example for
> generics...

Whatever language it uses, the library should provide a standard C API
interface and avoid using libraries that may not be available on
the systems supported by the v4l-utils package, as other packages
and a libv4l-compatible interface should be linked using it.

It should also be something that the existing v4l-utils developers are
familiar with. Right now, we have only C and C++ code inside v4l-utils.

So, I'd say that the language should be either C (the obvious choice)
or C++.

It should also be licensed using the same terms as v4l-utils libraries,
e. g. LGPL 2.1+.

Thanks,
Mauro
