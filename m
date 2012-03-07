Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37171 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2CGPnW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 10:43:22 -0500
Received: by iagz16 with SMTP id z16so8780541iag.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 07:43:22 -0800 (PST)
Date: Wed, 7 Mar 2012 07:43:11 -0800
From: gregkh <gregkh@linuxfoundation.org>
To: Ezequiel =?iso-8859-1?Q?Garc=EDa?= <elezegarcia@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: A second easycap driver implementation
Message-ID: <20120307154311.GB14836@kroah.com>
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
 <4F572611.50607@redhat.com>
 <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2012 at 11:32:23AM -0300, Ezequiel García wrote:
> Hi,
> 
> >
> > Have you considered instead slowly moving the existing easycap driver
> > over to all the new infrastructure we have now. For starters replace
> > its buffer management with videobuf2, then in another patch replace
> > some other bits, etc. ?  See what I've done to the pwc driver :)
> 
> Yes. And that was what I was doing until now.
> Yet, after some work it seemed much easier
> to simply start over from scratch.
> 
> Besides, it's being a great learning experience :)
> 
> So, since the driver is not yet working I guess there
> is no point in submitting anything.
> 
> Instead, anyone the wants to help I can send what I have now
> or we can start working through github.
> If someone owns this device, it would be a *huge* help
> with testing.
> 
> However, as soon as this is capturing video I would like
> to put it on staging, so everyone can help.
> Is this possible?

Yes it is, just send the patches to the correct people (note I don't
control the drivers/staging/media subdirectory.)

good luck,

greg k-h
