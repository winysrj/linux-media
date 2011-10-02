Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49600 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1JBHge (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 03:36:34 -0400
Date: Sun, 2 Oct 2011 10:36:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.2] S5K6AAFX sensor driver and a videobuf2
 update
Message-ID: <20111002073629.GK6180@valkosipuli.localdomain>
References: <4E85EA07.7060606@samsung.com>
 <20110930211608.GI6180@valkosipuli.localdomain>
 <4E86E0E5.5090803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E86E0E5.5090803@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 01, 2011 at 11:44:05AM +0200, Sylwester Nawrocki wrote:
> Hi Sakari,

Hi Sylwester,

> On 09/30/2011 11:16 PM, Sakari Ailus wrote:
> > Hi Sylwester,
> > 
> > On Fri, Sep 30, 2011 at 06:10:47PM +0200, Sylwester Nawrocki wrote:
> >> Hi Mauro,
> >>
> >> please pull from
> >>    git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
> >>
> >> for S5K6AAFX sensor subdev driver, a videbuf2 enhancement for non-MMU systems
> >> and minor s5p-mfc amendment changing the firmware name to something more
> >> generic as the driver supports multiple SoC versions.
> >>
> >>
> >> The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:
> >>
> >>    [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27
> >> 09:14:58 -0300)
> >>
> >> are available in the git repository at:
> >>    git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
> >>
> >> Sachin Kamat (1):
> >>        MFC: Change MFC firmware binary name
> >>
> >> Scott Jiang (1):
> >>        vb2: add vb2_get_unmapped_area in vb2 core
> >>
> >> Sylwester Nawrocki (2):
> >>        v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
> >>        v4l: Add v4l2 subdev driver for S5K6AAFX sensor
> > 
> > I'd like to ask you what's your intention regarding the preset functionality
> > in this driver? My understanding it it isn't provided to user space
> > currently, nor we have such drivers currently (that I know of).
> 
> The user configuration register sets present in the device are separated by 
> the driver from user space. So there is no such thing like user-space preset
> functionality coming with this driver. I think it's pretty clear from the code.
> Also please see my response to the previous e-mail (v2 thread).
> If there is anything that should be fixed in this driver I'd like Mauro to
> decide about this.

Agreed; the preset functionality isn't shown to the user space. The sensor
implements it and in my understanding some sensor features (not implemented
in the driver) like flash strobe timing requires it.

We should discuss at some point how to best support sensors like this, but I
don't think it has to be now.

I see no reason why this patch (v4l: Add v4l2 subdev driver for S5K6AAFX
sensor) shouldn't go in right now.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
