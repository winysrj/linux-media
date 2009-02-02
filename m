Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:38317 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZBCBWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:22:43 -0500
Date: Mon, 2 Feb 2009 17:58:20 -0600
From: David Engel <david@istwok.net>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090202235820.GA9781@opus.istwok.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49737088.7060800@rogers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 18, 2009 at 01:10:16PM -0500, CityK wrote:
> But as I have demonstrated above, and as Mauro explained, the previous
> "hack/workaround" no longer works in the case of with the Hans source
> code.  The "if" case fails!  Consequently, the "else" case should be
> don't merge.  Why?  Because we have now gone from:
> * circa pre-2.6.25, Mauro's changes that  broke the boards analog TV
> support, but which could somewhat be corrected by Mike's "hack/workaround"
> * to present, where merging Hans' code eliminates the usability of
> Mike's "hack/workaround" ... in essence, analog TV function has now been
> completely killed with these boards.
> 
> Now, if it is a case that a resolution to the problem is imminently
> forthcoming, then I don't think that the merge would be much of a
> problem.  However, given the breadth of the conversation so far (and I
> really do appreciate the depth of Trent's and Jean's
> discussion/consideration on the matter), it is entirely unclear to me
> that such a resolution will be found in short order  (although, I don't
> discount the possibility of it either).

As far as I can tell, this thread petered out without a resolution.
CityK later posted on avsforum, however, that analog on his card was
after more changes by Hans.  I'm confused.  Is analog on the KWorld
115 supposed to be working again or not?  I saw that some changes by
Hans made it into the main Hg repository, but as of yesterday, analog
still didn't work for me.

David
-- 
David Engel
david@istwok.net
