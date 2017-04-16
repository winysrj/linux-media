Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33828 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753131AbdDPJMR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 05:12:17 -0400
Date: Sun, 16 Apr 2017 12:12:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170414232332.63850d7b@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Apr 14, 2017 at 11:23:32PM -0300, Mauro Carvalho Chehab wrote:
> Hi Sakari,
> 
> Em Tue, 14 Feb 2017 14:20:22 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
> > Add a V4L2 control class for voice coil lens driver devices. These are
> > simple devices that are used to move a camera lens from its resting
> > position.
> 
> From some past threads with this patch, you mentioned that:
> 
> "The FOCUS_ABSOLUTE control really is not a best control ID to
>  control a voice coil driver's current."
> 
> However, I'm not seeing any explanation there at the thread, at
> the patch description or at the documentation explaining why, and,
> more important, when someone should use the focus control or the
> camera voice coil control.

It should be available in the thread. Nevertheless, V4L2_CID_FOCUS_ABSOLUTE
is documented as follows (emphasis mine):

	This control sets the *focal point* of the camera to the specified
	position. The unit is undefined. Positive values set the focus
	closer to the camera, negative values towards infinity.

What you control in voice coil devices is current (in Ampères) and the
current only has a relatively loose relation to the focal point.
Additionally, increasing the current brings the focus closer, not farther.

I anticipate adding controls for ringing compensation in the future.
Virtually all other devices except this one do ringing compensation and
there's some control to be done for that.

How about adding such an explanation added to the commit message?

> 
> Worse than that, patch 2/2 gives the false sensation that both
> controls are equal.
> 
> Ok, I understand that they need to be identical on the existing
> driver, in order to keep backward compatibility, but I'm afraid
> that, without a clear distinction between them at the documentation,
> people may just clone the existing code on other drivers.

Indeed. The only reason that I'm not just replacing FOCUS_ABSOLUTE with the
new contorol is backwards compatibility. But as Pavel pointed out, he's
likely the sole user of this device that can only be found (as far as we
commonly are aware) in the Nokia N900.

I'm happy to just switch the control, and Pavel mentioned he's happy with
that. It would avoid copying the code in new drivers --- which I would most
certainly point out anyway.

> 
> So, please add more details to patch 1/2.

Let me know if you're happy with the above.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
