Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41490 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbcGSW6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 18:58:09 -0400
Date: Tue, 19 Jul 2016 16:58:06 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719165806.2ef581dc@lwn.net>
In-Reply-To: <F6675307-05E6-4101-92E9-69BC0232A939@darmarit.de>
References: <20160717100154.64823d99@recife.lan>
	<20160717203719.6471fe03@lwn.net>
	<20160718085420.314119a8@recife.lan>
	<F6675307-05E6-4101-92E9-69BC0232A939@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Jul 2016 12:00:24 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> I recommend to consider to switch to the python version of the parser.
> I know, that there is a natural shyness about a reimplementation in python
> and thats why I offer to support it for a long time period .. it would
> be a joy for me ;-)
> 
> If you interested in, I could send a RFC patch for this, if not please
> give the reasons why not.

We've had this discussion already...  The problem is not with "python",
it's with "reimplementation".  We have enough moving parts in this
transition already; tossing in a wholesale replacement of a tool that,
for all of its many faults, embodies a couple decades worth of experience
just doesn't seem like the right thing to do at this time.

I will be happy to entertain the idea of a new kernel-doc in the future;
trust me, I have no emotional attachment to the current one.  But please
let's solidify what we have now first.  There's enough stuff to deal with
as it is.

Thanks,

jon
