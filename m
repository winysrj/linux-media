Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:53216 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab1HDKmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 06:42:54 -0400
Date: Thu, 4 Aug 2011 12:42:47 +0200
From: Florian Mickler <florian@mickler.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: vp702x
Message-ID: <20110804124247.79d8a06f@schatten.dmk.lab>
In-Reply-To: <20110804102942.GB7659@shale.localdomain>
References: <20110802173942.6f951c95@schatten.dmk.lab>
	<alpine.LRH.2.00.1108030937250.5518@pub4.ifh.de>
	<20110804122129.45a8b37f@schatten.dmk.lab>
	<20110804102942.GB7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 4 Aug 2011 13:29:42 +0300
Dan Carpenter <error27@gmail.com> wrote:

> On Thu, Aug 04, 2011 at 12:21:29PM +0200, Florian Mickler wrote:
> > Mauro, what to do?
> 
> Apply the fix which Tino tested, perhaps?  :P  (obviously).
> 
> The bug is present in 3.0 so it should be tagged for stable as well.
> 
> regards,
> dan carpenter

Two different drivers ;) I fear the fix Tino tested does not apply to
vp702x.. (it's for vp7045)

Regards,
Flo
