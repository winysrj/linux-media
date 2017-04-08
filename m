Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752415AbdDHUEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 16:04:44 -0400
Date: Sat, 8 Apr 2017 22:04:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 00/21] Convert USB documentation to ReST format
Message-ID: <20170408200433.GA28427@kroah.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
 <20170408112328.7cc07f53@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170408112328.7cc07f53@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 08, 2017 at 11:23:28AM -0600, Jonathan Corbet wrote:
> On Wed,  5 Apr 2017 10:22:54 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > Currently, there are several USB core documents that are at either
> > written in plain text or in DocBook format. Convert them to ReST
> > and add to the driver-api book.
> 
> Greg, do you see any reason not to apply these for 4.12?  A few of them
> touch comments outside of Documentation/; I'm happy to carry those or
> leave them to you, as you prefer.

I'll queue them up in the next few days, thanks!

greg k-h
