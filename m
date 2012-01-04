Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37170 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2ADVHN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 16:07:13 -0500
Date: Wed, 4 Jan 2012 23:07:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 0/4] Add some new camera controls
Message-ID: <20120104210708.GK9323@valkosipuli.localdomain>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <201112281501.25091.laurent.pinchart@ideasonboard.com>
 <4EFD9E10.1050407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFD9E10.1050407@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Dec 30, 2011 at 12:18:40PM +0100, Sylwester Nawrocki wrote:
> On 12/28/2011 03:01 PM, Laurent Pinchart wrote:
> > On Wednesday 28 December 2011 07:23:44 HeungJun, Kim wrote:
> >> This RFC patch series include new 4 controls ID for digital camera.
> >> I about to suggest these controls by the necessity enabling the M-5MOLS
> >> sensor's function, and I hope to discuss this in here.
> > 
> > Thanks for the patches.
> > 
> > The new controls introduced by these patches are very high level. Should they 
> > be put in their own class ? I also think we should specify how those high-
> > level controls interact with low-level controls, otherwise applications will 
> > likely get very confused.
> 
> I agree we may need a separate control class for those high-level controls.
> They are mostly applicable to software ISP algorithms, run either on digital
> signal processor embedded in the sensor or on a processor being part of an SoC.
> 
> Thus we would three levels of controls for camera,
>  1) image source class (lowest possible level), dealing mostly with hardware
>     registers;

I intended the image source class for controls which only deal with the a/d
conversion itself. Other controls would be elsewhere.

There hasn't been a final decision on this yet, but an alternative which has
been also discussed is just to call this a "low level" control class.

>  2) "normal" camera controls (V4L2_CID_CAMERA_CLASS) [2];
>  3) high level camera controls (for camera software algorithms)

Almost all the automatic anything algorithms are impelemented in software.
But when software is involved, the possibilities are mostly limitless; it's
a matter of imagination what kind of interesting white balance algorithms 

> plus some camera controls are in the user controls class. I'm not sure why there
> are camera controls in the user control class, perhaps there was no camera
> class yet at the time V4L2_CID_EXPOSURE or V4L2_CID_BACKLIGHT_COMPENSATION were
> added. I might be missing something else.

The camera control class is relatively new, so that's likely what happened.

Speaking of the classes --- I could resend my patch which allows changing
controls in different classes in the same s_ext_ctrls call --- I looked at
it some time ago and no driver had any limitations on this; it's just the
documentation and the control framework which do.

> I'm afraid a little it might be hard to distinguish if some control should
> belong to 2) or 3), as sensors' logic complexity and advancement varies.

I can see two main use cases:

1. V4L2 / V4L2 subdev / MC as the low level API for camera control and

2. Regular V4L2 applications.

For most controls it's clear which of the two classes they belong to.

> Although I can see an advantage of logically separating controls which have
> influence on one or more other (lower level) controls. And separate control
> class would be helpful in that.
> 
> The candidates to such control class might be:
> 
> * V4L2_CID_METERING_MODE,
> * V4L2_CID_EXPOSURE_BIAS,
> * V4L2_CID_ISO,
> * V4L2_CID_WHITE_BALANCE_PRESET,
> * V4L2_CID_SCENEMODE,
> * V4L2_CID_WDR,
> * V4L2_CID_ANTISHAKE,

The list looks good to me.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
