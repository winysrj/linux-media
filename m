Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60786 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1IJGl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Sep 2011 02:41:57 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Sat, 10 Sep 2011 12:11:37 +0530
Subject: RE: [PATCH v2 0/8] RFC for Media Controller capture driver for DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025743F4CE@dbde02.ent.ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
 <20110831213032.GT12368@valkosipuli.localdomain>
 <B85A65D85D7EB246BE421B3FB0FBB593025743F3CE@dbde02.ent.ti.com>
 <20110909161940.GJ1724@valkosipuli.localdomain>
In-Reply-To: <20110909161940.GJ1724@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Fri, Sep 09, 2011 at 21:49:40, Sakari Ailus wrote:
> On Fri, Sep 09, 2011 at 07:10:49PM +0530, Hadli, Manjunath wrote:
> > Hi Sakari,
> > 
> > On Thu, Sep 01, 2011 at 03:00:32, Sakari Ailus wrote:
> > > Hi Manju,
> > > 
> > > Do you have the media device grap that would be typical for this hardware produced by media-ctl? That can be converted to postscript using dotfile.
> > > 
> > > this would make it a little easier to understan this driver. Thanks.
> > 
> > Sure. But can you be a little more elaborate on how you need this 
> > information? If you can tell me in little more detail about this that 
> > will help me make the information in a way that everyone can understand.
> 
> Preferrably in PostScript format so it's easy to visualise the layout of the hardware that the driver supports, as the OMAP 3 ISP example was.
Sure.
 I was more looking for an example of the same so it could help me put the data together in the way it has been done before. Can you send across if you have one?

Many Thx,
-Manju

> 
> > Thanks and Regards,
> > -Manju
> > 
> > 
> > > 
> > > On Mon, Aug 29, 2011 at 08:37:11PM +0530, Manjunath Hadli wrote:
> > > > changes from last patch set:
> > > > 1. Made changes based on Sakari's feedback mainly:
> > > >         a. returned early to allow unindenting
> > > >         b. reformatting to shift the code to left where possible
> > > >         c. changed hex numbers to lower case
> > > >         d. corrected the defines according to module names.
> > > >         e. magic numbers removed.
> > > >         f. changed non-integer returning functions to void
> > > >         g. removed unwanted paranthses.
> > > >         h. fixed error codes.
> > > >         i. fixed some RESET_BIt code to what it was intended for.
> > > > 2. reorganized the header files to move the kernel-only headers 
> > > > along with the c files and interface headers in the include folder.
> > > > 
> > ...
> > 
> > 
> 
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
> 

