Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:60283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaJAIs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Oct 2014 04:48:27 -0400
From: "Ryan, Mark D" <mark.d.ryan@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Matt Wells <phanoko@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mark Ryan <mark.d.ryan@linux.intel.com>
Subject: RE: Dell XPS 12 Camera issues
Date: Wed, 1 Oct 2014 08:46:45 +0000
Message-ID: <EBD828E1B55D6A41B9BA1EEC16778B3B563B8AEA@IRSMSX101.ger.corp.intel.com>
References: <CA+aiKi+F_qDZxcL3NCWz4WSXn033cPEWW3akuZ+qQdGyQ4GZPQ@mail.gmail.com>
 <1614008.QuBRSios4a@avalon>
In-Reply-To: <1614008.QuBRSios4a@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Apologies for my late reply.

[...]

> 
> > I searched here for some time before posting and haven't found the
> > answer as of yet. Perhaps my search'foo isn't really there and to tell
> > you the truth cameras and what not are a weak spot for me. Never
> > really cared about them until now.
> >
> > Man I just need some ideas. So far the first 9 pages of google are
> > purple (clicked) links.
> > I've 5 pages of strace that I'm going through tonight.
> >
> > Anyone else out there have this issue with the XPS line?
> >
> > Any direction is much appreciated. I'll feel like a real idiot if a
> > quick post and a link resolves it.
> 
> This mail thread might be related: http://www.spinics.net/lists/linux-
> media/msg73460.html
> 
> Mark, have you managed to finish carrying on your investigations ?
> 

The problems I was encountering were on the Dell XPS12 under Ubuntu.   Note that these problems were clearly evident in guvcview.  Some of the low resolution yuv modes worked in guvcview but most did not.  None of the JPEG modes worked.  So, if Matt is experiencing no problems with any of the resolutions in guvcivew, he's seeing a different issue.

I'm afraid that I never really resolved the issue.  It's been quite a while since I looked at this but my conclusion was that there was nothing wrong with uvcvideo.  When I compared the usb logs for Windows and Ubuntu for the same resolution, I could see that the requests sent by Windows and Ubuntu to setup the resolution and initiate streaming were almost identical (and I actually modified uvcvideo to make them identical).  However, the data return was not.   In Windows the data was correctly formatted.  In Ubuntu it was not.  Had uvcvideo received the data sent by the camera under Windows, the camera would have operated correctly.  My conclusion was that the issue was therefore either lower down in the Linux USB stack or there was some camera configuration magic going on in Windows which was necessary for the camera to operate correctly.   But at that point I switched laptop and stopped investigating.

Sorry I can't be of more help,

Best regards,

Mark
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

