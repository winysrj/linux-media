Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:46940 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab2AKWgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 17:36:21 -0500
Date: Thu, 12 Jan 2012 00:36:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
 control
Message-ID: <20120111223616.GT9323@valkosipuli.localdomain>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <4F007DED.4070201@gmail.com>
 <20120104203933.GJ9323@valkosipuli.localdomain>
 <201201042157.17040.laurent.pinchart@ideasonboard.com>
 <4F04C394.5050302@iki.fi>
 <4F04CD55.2000500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04CD55.2000500@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 04, 2012 at 11:06:13PM +0100, Sylwester Nawrocki wrote:
> Hi Sakari,
> 
> On 01/04/2012 10:24 PM, Sakari Ailus wrote:
> >>>>> I don't quite understand the purpose of the do_white_balance; the
> >>>>> automatic white balance algorithm is operational until it's disabled,
> >>>>> and after disabling it the white balance shouldn't change. What is the
> >>>>> extra functionality that the do_white_balance control implements?
> >>>>
> >>>> Maybe DO_WHITE_BALANCE was inspired by some hardware's behaviour, I don't
> >>>> know. I have nothing against this control. It allows you to perform
> >>>> one-shot white balance in a given moment in time. Simple and clear.
> >>>
> >>> Well, yes, if you have an automatic white balance algorithm which supports
> >>> "one-shot" mode. Typically it's rather a feedback loop. I guess this means
> >>> "just run one iteration".
> >>>
> >>> Something like this should possibly be used to get the white balance
> >>> correct by pointing the camera to an object of known colour (white
> >>> typically, I think). But this isn't it, at least based on the description
> >>> in the spec.
> >>
> >> Then either the spec is incorrect, or I'm mistaken. My understanding of the
> >> DO_WHITE_BALANCE control is exactly what you described.
> > 
> > This is what the spec says:
> > 
> > "This is an action control. When set (the value is ignored), the device will do
> > a white balance and then hold the current setting. Contrast this with the
> > boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the
> > white balance."
> > 
> > I wonder if that should be then changed --- or is it just me who got a different
> > idea from the above description?
> 
> Only you ? :-) Same as Laurent, I understood this control can be used to do white
> balance after pointing camera to a white object. Not sure if the description
> needs to be changed.

Definitely it needs to be changed. Who will submit the patch? :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
