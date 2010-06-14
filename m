Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:23218 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0FNGjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 02:39:55 -0400
Date: Mon, 14 Jun 2010 09:39:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Christian Kujau <lists@nerdbynature.de>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Michael Ellerman <michael@ellerman.id.au>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Message-ID: <20100614063948.GA3999@x200>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
 <YPGdyfWGvNK.A.C8B.d9OFMB@chimera>
 <201006131722.44062.s.L-H@gmx.de>
 <alpine.DEB.2.01.1006131103590.3964@bogon.housecafe.de>
 <AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTily7ZDG16uE2vSsq8t3mssuATwtHnr8OajX8oga@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 13, 2010 at 01:57:40PM -0600, Grant Likely wrote:
> On brief review, they look like completely different issues.  I doubt
> the second patch will fix the flexcop-pci issue.

It will, see how name wht slashes propagated by request_irq()
