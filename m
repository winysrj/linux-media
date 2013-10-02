Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6061 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab3JBS07 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 14:26:59 -0400
Date: Wed, 2 Oct 2013 11:26:59 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Xenia Ragiadakou <burzalodowa@gmail.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
Message-ID: <20131002182659.GF15395@xanatos>
References: <524B1BF4.6000305@gmail.com>
 <20131001204554.GB15395@xanatos>
 <524B3B94.8060806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B3B94.8060806@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 02, 2013 at 12:16:04AM +0300, Xenia Ragiadakou wrote:
> On 10/01/2013 11:45 PM, Sarah Sharp wrote:
> >Sure.  I would actually suggest you first finish up the patch to issue a
> >configure endpoint if userspace wants to clear a halt, but the endpoint
> >isn't actually halted.  Did your most current patch work?  I can't
> >remember what the status was.
> >
> >Sarah Sharp
> 
> Thanks for the clarification, I understand better now.
> As far as concerns the reset endpoint fix, I am not sure if it works
> I have to send an RFC so that it can be further tested but I have a
> lot of pending RFCs for xhci on the mailing list so i was waiting
> for those to be reviewed before sending new ones. Or it is not
> necessary to wait and just send the RFC based on current usb-next
> tree?

Go ahead and send that one as well.

Sarah Sharp
