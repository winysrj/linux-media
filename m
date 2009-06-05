Return-path: <linux-media-owner@vger.kernel.org>
Received: from dora.fastpath.it ([66.150.225.37]:53001 "EHLO dora.fastpath.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbZFERbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 13:31:06 -0400
Date: Fri, 5 Jun 2009 19:09:33 +0200
From: David Santinoli <marauder@tiscali.it>
To: "Sandell, Anders" <anders.sandell@logica.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: /dev/dvb/adapter0/dvr0 gives no output
Message-ID: <20090605170933.GA27551@aidi.santinoli.com>
References: <22162B491802D04F87B02036F8E317992B6A9F19BE@SE-EX008.groupinfra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22162B491802D04F87B02036F8E317992B6A9F19BE@SE-EX008.groupinfra.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 05, 2009 at 06:06:42PM +0200, Sandell, Anders wrote:
> Everything looks just fine but when trying "cat /dev/dvb/adapter0/dvr0 > file.mpg" nothing happens, the file never get any contents.
> 
> Szap-s2 also seems to be working locking on to BBC World:

Don't know much about szap-s2, but if it works like szap, you might have
to add '-r' in the command line to enable the dvr0 device.

HTH,
 David
