Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42297 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758756Ab1IINlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 09:41:10 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 9 Sep 2011 19:10:49 +0530
Subject: RE: [PATCH v2 0/8] RFC for Media Controller capture driver for DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025743F3CE@dbde02.ent.ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
 <20110831213032.GT12368@valkosipuli.localdomain>
In-Reply-To: <20110831213032.GT12368@valkosipuli.localdomain>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Sep 01, 2011 at 03:00:32, Sakari Ailus wrote:
> Hi Manju,
> 
> Do you have the media device grap that would be typical for this hardware produced by media-ctl? That can be converted to postscript using dotfile.
> 
> this would make it a little easier to understan this driver. Thanks.

Sure. But can you be a little more elaborate on how you need this information? If you can tell me in little more detail about this that will help me make the information in a way that everyone can understand.

Thanks and Regards,
-Manju


> 
> On Mon, Aug 29, 2011 at 08:37:11PM +0530, Manjunath Hadli wrote:
> > changes from last patch set:
> > 1. Made changes based on Sakari's feedback mainly:
> >         a. returned early to allow unindenting
> >         b. reformatting to shift the code to left where possible
> >         c. changed hex numbers to lower case
> >         d. corrected the defines according to module names.
> >         e. magic numbers removed.
> >         f. changed non-integer returning functions to void
> >         g. removed unwanted paranthses.
> >         h. fixed error codes.
> >         i. fixed some RESET_BIt code to what it was intended for.
> > 2. reorganized the header files to move the kernel-only headers along 
> > with the c files and interface headers in the include folder.
> > 
...


