Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:65140 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZKLDfu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 22:35:50 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1N8QRo-00056e-SY
	for linux-media@vger.kernel.org; Wed, 11 Nov 2009 22:34:12 -0500
Date: Wed, 11 Nov 2009 22:34:12 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Re: Procmail won't route this list (linux-media) correctly.  Help!
Message-ID: <20091112033412.GA19562@shibaya.lonestar.org>
References: <20091112031647.GA17951@shibaya.lonestar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112031647.GA17951@shibaya.lonestar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 11, 2009 at 10:16:47PM -0500, I wrote:
> Hi,
> 
> This is the only mailing list that I receive that procmail doesn't
> handle properly.  All the others get sent to their own mailboxes.
> What is so strange about the headers of this list?

Arrgh!!!  One change after I sent this email fixed it.  Please ignore
the request for help.

It turns out that I had too much stuff in the procmail recipe.

This works:
> :0:
> * ^TO(linux-dvb@linuxtv.org|linux-media@vger.kernel.org)
> $LINUXDVBFOLDER

Sorry for the distraction.

A.

