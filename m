Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZK2TLn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 14:11:43 -0500
Date: Sun, 29 Nov 2009 11:09:30 -0800
From: Greg KH <greg@kroah.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [IR-RFC PATCH v4 2/6] Core IR module
Message-ID: <20091129190930.GA6171@kroah.com>
References: <20091127013217.7671.32355.stgit@terra> <20091127013423.7671.36546.stgit@terra> <20091129171437.GA4993@kroah.com> <9e4733910911290937v7795da49q613c172b2cc9d13c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910911290937v7795da49q613c172b2cc9d13c@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 29, 2009 at 12:37:36PM -0500, Jon Smirl wrote:
> On Sun, Nov 29, 2009 at 12:14 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Nov 26, 2009 at 08:34:23PM -0500, Jon Smirl wrote:
> >> Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.
> >>
> >> Received IR messages generate event in the input queue.
> >> IR messages are sent using an input IOCTL.
> >
> > As you are creating new sysfs files here, please document them in
> > Documentation/ABI/
> 
> This code is not going to get merged as is. It's just a starting point
> to get a discussion started about designing an IR subsystem. I expect
> the final design will look a lot different.

Then show the design by adding the documentation for new sysfs files, to
make it easier to understand by everyone please.

thanks,

greg k-h
