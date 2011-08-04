Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61680 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab1HDKbr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 06:31:47 -0400
Received: by pzk37 with SMTP id 37so1823039pzk.1
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2011 03:31:46 -0700 (PDT)
Date: Thu, 4 Aug 2011 13:29:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: vp702x
Message-ID: <20110804102942.GB7659@shale.localdomain>
References: <20110802173942.6f951c95@schatten.dmk.lab>
 <alpine.LRH.2.00.1108030937250.5518@pub4.ifh.de>
 <20110804122129.45a8b37f@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804122129.45a8b37f@schatten.dmk.lab>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 04, 2011 at 12:21:29PM +0200, Florian Mickler wrote:
> Mauro, what to do?

Apply the fix which Tino tested, perhaps?  :P  (obviously).

The bug is present in 3.0 so it should be tagged for stable as well.

regards,
dan carpenter
