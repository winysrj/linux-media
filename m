Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:55517 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3LEQsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Dec 2013 11:48:02 -0500
Date: Thu, 5 Dec 2013 16:47:59 +0000
From: Sean Young <sean@mess.org>
To: Rajil Saraswat <rajil.s@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: IR devices refuses to generate events
Message-ID: <20131205164759.GA3653@pequod.mess.org>
References: <CAFoaQoAFnaO68VTOyoTpM58V6W5P+PTFQso=B99tt5dcu2O9Aw@mail.gmail.com>
 <20131205132422.GA2031@pequod.mess.org>
 <CAFoaQoAQO7ELDm7aeQB6RgwdxXA9GHqdqBOnY4VoV9Ms_fQEtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFoaQoAQO7ELDm7aeQB6RgwdxXA9GHqdqBOnY4VoV9Ms_fQEtg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 05, 2013 at 10:05:45PM +0530, Rajil Saraswat wrote:
> On 5 December 2013 18:54, Sean Young <sean@mess.org> wrote:
> 
> > I really don't know why that would happen. If I understand it correctly
> > this is an error that is returned by the usb host controller driver.
> >
> > Could you set CONFIG_USB_DEBUG and see if you get more information?
> >
> >
> > Sean
> 
> The usbmon log with CONFIG_USB_DEBUG set is attached.

You should have more output in dmesg. Do you?


Sean
