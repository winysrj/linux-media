Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:50424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752840AbZCMCxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 22:53:31 -0400
Date: Thu, 12 Mar 2009 19:50:51 -0700
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [stable] Fwd: [PATCH] 2.6.27.y: fix NULL ptr deref in cx23885
	video_open
Message-ID: <20090313025051.GA5385@kroah.com>
References: <200902241700.56099.jarod@redhat.com> <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840903121324q7b08c8d1ma6d0d3ec4f5eb278@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 04:24:38PM -0400, Michael Krufky wrote:
> Can we have this merged into -stable?  Jarod Wilson sent this last
> month, but he left off the cc to stable@kernel.org

What is the git commit id of the patch in Linus's tree that matches up
with this?

thanks,

greg k-h
