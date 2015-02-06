Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34155 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbbBFSXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Feb 2015 13:23:18 -0500
Date: Fri, 6 Feb 2015 13:23:15 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DocBook: grammatical correction on DVB Overview
Message-ID: <20150206132315.724460b0@lwn.net>
In-Reply-To: <20150206181752.GA25234@biggie>
References: <20150206181752.GA25234@biggie>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Feb 2015 18:17:52 +0000
Luis de Bethencourt <luis@debethencourt.com> wrote:

> -video streams. Besides usually several of such audio and video streams
> -it also contains data streams with information about the programs
> +video streams. As well as several of such audio and video streams, it
> +usually also contains data streams with information about the programs

Not sure if I see this as an improvement or not; you've changed the
meaning of the sentence a bit.  It also lacks changelog and signoff...

Thanks,

jon
