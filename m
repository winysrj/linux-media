Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54560 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab1ILL73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 07:59:29 -0400
Date: Mon, 12 Sep 2011 14:59:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v2 0/8] RFC for Media Controller capture driver for
 DM365
Message-ID: <20110912115925.GC1716@valkosipuli.localdomain>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
 <20110831213032.GT12368@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593025743F3CE@dbde02.ent.ti.com>
 <20110909161940.GJ1724@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593025743F4CE@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593025743F4CE@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 10, 2011 at 12:11:37PM +0530, Hadli, Manjunath wrote:
> Hi Sakari,
> On Fri, Sep 09, 2011 at 21:49:40, Sakari Ailus wrote:
> > On Fri, Sep 09, 2011 at 07:10:49PM +0530, Hadli, Manjunath wrote:
> > > Hi Sakari,
> > > 
> > > On Thu, Sep 01, 2011 at 03:00:32, Sakari Ailus wrote:
> > > > Hi Manju,
> > > > 
> > > > Do you have the media device grap that would be typical for this hardware produced by media-ctl? That can be converted to postscript using dotfile.
> > > > 
> > > > this would make it a little easier to understan this driver. Thanks.
> > > 
> > > Sure. But can you be a little more elaborate on how you need this 
> > > information? If you can tell me in little more detail about this that 
> > > will help me make the information in a way that everyone can understand.
> > 
> > Preferrably in PostScript format so it's easy to visualise the layout of the hardware that the driver supports, as the OMAP 3 ISP example was.
> Sure.
>  I was more looking for an example of the same so it could help me put the
> data together in the way it has been done before. Can you send across if
> you have one?

Ah. I think I misunderstood you first. :-)

On the device, run

	$ media-ctl --print-dot > graph.dot

This will produce a graph of the media device in the dot format. This is
then processed by program called dot:

	$ dot -o graph.ps -T ps < graph.dot

dot is available at least in Debian in a package called graphviz.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
