Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35474 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0A3QBn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 11:01:43 -0500
Date: Sat, 30 Jan 2010 07:59:33 -0800
From: Greg KH <greg@kroah.com>
To: Martin Fuzzey <mfuzzey@gmail.com>
Cc: Jef Treece <treecej@comcast.net>, linux-media@vger.kernel.org
Subject: Re: fix regression in pwc_set_shutter_speed???
Message-ID: <20100130155933.GA24970@kroah.com>
References: <20100129011734.GA10096@kroah.com> <1351307599.538561264809789383.JavaMail.root@sz0171a.emeryville.ca.mail.comcast.net> <20100130052312.GA22196@kroah.com> <4B645397.4030404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B645397.4030404@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 30, 2010 at 04:43:19PM +0100, Martin Fuzzey wrote:
> Greg KH wrote:
> > Video developers, any comments?
> >
> > Jef, were you able to narrow it down to the actual patch that caused the
> > problem.
> >
> >   
> Indeed it was my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0
> 
> I somehow missed the email from Laurent back in August about this.
> 
> Am checking the rest of that commit now and will send a fix patch soon.
> 
> Sorry about that.

No problem, can you also send it to stable@kernel.org when it is in
Linus's tree?

thanks,

greg k-h
