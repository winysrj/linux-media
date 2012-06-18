Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:22647 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2FRVRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 17:17:35 -0400
Date: Tue, 19 Jun 2012 00:17:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>,
	Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	stoth@kernellabs.com
Subject: Re: [PATCH 0/12] struct i2c_algo_bit_data cleanup on several drivers
Message-ID: <20120618211718.GJ13539@mwanda>
References: <CALF0-+XS6gjiLDSGwumBp1xfXYvzii9f_Lw4qhyxVzwMzfh9Rg@mail.gmail.com>
 <20120618205629.GI13539@mwanda>
 <CALF0-+WX+cbF1s4vUBE0Fa6AMA3QcBwp7Bd1i=0rofZp7F_VAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALF0-+WX+cbF1s4vUBE0Fa6AMA3QcBwp7Bd1i=0rofZp7F_VAA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 18, 2012 at 06:00:52PM -0300, Ezequiel Garcia wrote:
> On Mon, Jun 18, 2012 at 5:56 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Mon, Jun 18, 2012 at 04:23:14PM -0300, Ezequiel Garcia wrote:
> >> Hi Mauro,
> >>
> >> This patchset cleans the i2c part of some drivers.
> >> This issue was recently reported by Dan Carpenter [1],
> >> and revealed wrong (and harmless) usage of struct i2c_algo_bit.
> >>
> >
> > How is this harmless?  We are setting the function pointers to
> > something completely bogus.  It seems like a bad thing.
> >
> 
> You're right, but that wrongly assigned struct  algo_bit_data is never
> *ever* used,
> since it is not registered.
> 
> So, I meant it was harmless in that way, perhaps it wasn't the right term.

No no.  I didn't realize these files didn't call i2c_add_bus().
Harmless is the right term.

regards,
dan carpenter

