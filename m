Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36905 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588AbbBFS3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2015 13:29:31 -0500
Date: Fri, 6 Feb 2015 18:27:34 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DocBook: grammatical correction on DVB Overview
Message-ID: <20150206182734.GA25312@biggie>
References: <20150206181752.GA25234@biggie>
 <20150206132315.724460b0@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150206132315.724460b0@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 06, 2015 at 01:23:15PM -0500, Jonathan Corbet wrote:
> On Fri, 6 Feb 2015 18:17:52 +0000
> Luis de Bethencourt <luis@debethencourt.com> wrote:
> 
> > -video streams. Besides usually several of such audio and video streams
> > -it also contains data streams with information about the programs
> > +video streams. As well as several of such audio and video streams, it
> > +usually also contains data streams with information about the programs
> 
> Not sure if I see this as an improvement or not; you've changed the
> meaning of the sentence a bit.  It also lacks changelog and signoff...
> 
> Thanks,
> 
> jon

Hi Jon,

The original sentence is hard to read, I had to go a few times before I think
I understood what it meant. Which might be different from your interpretation.

How about?:
"Besides several of such audio and video stream, it usually also contains data
streams with information about the programs [...]"

If this isn't worth it and it is just nitpicking, feel free to drop.

Thanks for taking the time to look into this,
Luis
