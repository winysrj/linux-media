Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:37386 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIVVr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 17:47:59 -0400
Date: Tue, 22 Sep 2009 14:47:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: docbooks fatal build error (v4l & dvb)
Message-Id: <20090922144749.3b968984.randy.dunlap@oracle.com>
In-Reply-To: <20090922143601.f5953a04.randy.dunlap@oracle.com>
References: <20090922124248.59e57b55.randy.dunlap@oracle.com>
	<20090922182827.3d844748@pedra.chehab.org>
	<20090922143601.f5953a04.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 22 Sep 2009 14:36:01 -0700 Randy Dunlap wrote:

> On Tue, 22 Sep 2009 18:28:27 -0300 Mauro Carvalho Chehab wrote:
> 
> > Hi Randy,
> > 
> > Em Tue, 22 Sep 2009 12:42:48 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> escreveu:
> > 
> > > 2.6.31-git11:  this prevents other docbooks from being built.
> > > 
> > > mkdir -p /linux-2.6.31-git11/Documentation/DocBook/media/
> > > cp /linux-2.6.31-git11/Documentation/DocBook/dvb/*.png /linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif /linux-2.6.31-git11/Documentation/DocBook/media/
> > > cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/dvb/*.png': No such file or directory
> > > cp: cannot stat `/linux-2.6.31-git11/Documentation/DocBook/v4l/*.gif': No such file or directory
> > > make[1]: *** [media] Error 1
> > 
> > 
> > Hmm... here, it is working fine. I've did it on a newer tree, cloned from Linus
> > one. This is the last patch on it:
> 
> OK, it's probably just because I used a git snapshot (-git11).
> Sorry for the noise.

Confirmed, linus.git works fine.

---
~Randy
