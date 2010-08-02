Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0HBWfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 18:35:21 -0400
Date: Mon, 2 Aug 2010 15:35:10 -0700
From: Greg KH <greg@kroah.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 1/2] staging/lirc: port lirc_streamzap to ir-core
Message-ID: <20100802223510.GB2478@kroah.com>
References: <20100802212922.GA17746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802212922.GA17746@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 02, 2010 at 05:29:22PM -0400, Jarod Wilson wrote:
>  drivers/media/IR/keymaps/Makefile           |    1 +

Uppercase "IR"?  Any reason why you all picked that?

Just curious.

greg k-h
