Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39684 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751323AbdELKuL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 06:50:11 -0400
Date: Fri, 12 May 2017 13:49:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, pavel@ucw.cz
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170512104930.GJ3227@valkosipuli.retiisi.org.uk>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170419105118.72b8e284@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Apr 19, 2017 at 10:51:18AM -0300, Mauro Carvalho Chehab wrote:
> Em Sun, 16 Apr 2017 12:12:10 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, Apr 14, 2017 at 11:23:32PM -0300, Mauro Carvalho Chehab wrote:
> > > Hi Sakari,
> > > 
> > > Em Tue, 14 Feb 2017 14:20:22 +0200
> > > Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> > >   
> > > > Add a V4L2 control class for voice coil lens driver devices. These are
> > > > simple devices that are used to move a camera lens from its resting
> > > > position.  
> > > 
> > > From some past threads with this patch, you mentioned that:
> > > 
> > > "The FOCUS_ABSOLUTE control really is not a best control ID to
> > >  control a voice coil driver's current."
> > > 
> > > However, I'm not seeing any explanation there at the thread, at
> > > the patch description or at the documentation explaining why, and,
> > > more important, when someone should use the focus control or the
> > > camera voice coil control.  
> > 
> > It should be available in the thread.
> 
> The email thread is not registered at git logs nor at the API spec.
> 
> > Nevertheless, V4L2_CID_FOCUS_ABSOLUTE
> > is documented as follows (emphasis mine):
> > 
> > 	This control sets the *focal point* of the camera to the specified
> > 	position. The unit is undefined. Positive values set the focus
> > 	closer to the camera, negative values towards infinity.
> > 
> > What you control in voice coil devices is current (in Ampères) and the
> > current only has a relatively loose relation to the focal point.
> 
> The real problem I'm seeing here is that this control is already
> used by voice coil motor (VCM). Several UVC-based Logitech cameras
> come with VCM, like their QuickCam Pro-series webcams:
> 
> 	https://secure.logitech.com/en-hk/articles/3231
> 
> The voice coil can be seen on this picture:
> 	https://photo.stackexchange.com/questions/48678/can-i-modify-a-logitech-c615-webcam-for-infinity-focus

There may be voice coil lens implementations that are indirectly controlled
through this control. Those are hardware solutions that have been taken in
UVC webcams, for instance. The UVC standard itself uses millimeters.

Lens systems based on voice coils generally cannot focus at a given exact
distance for they have no concept of focussing at a particular distance.
Instead, an auto focus algorithm analyses the image data (or statistics of
image data) to control the lens --- in other words, to set current, not
distance.

As the auto focus algorithms require both image data (or statistics) and
access to lens voice coil as well as for algorithmic complexity, they are
typically implemented in user space.

In other words, the VOICE_COIL_CURRENT control is thus used by user space to
implement what the user expects from FOCUS_AUTO control. It could be
implemented in libv4l2 or a different user space component.
VOICE_COIL_CURRENT control is not a control which is expected to be used by
an end user application --- unlike FOCUS_AUTO.

This camera module datasheet shows the dependency between current and lens
position. See "Performance Diagram" on page 16:

<URL:http://www.trulyamerica.com/wp-content/uploads/CM7945-B1200BA-E_V1.1.pdf>

As you can see, lens position may start changing by applying a current
between 14 and 34 mA, but exactly how much is specific to a given camera
module unit. This means that there is no direct mapping between the current
and the focus distance.

Ringing compensation is another matter. Voice coils do ring unless it is
compensated, something that the user of a control focussing at a particular
distance expects. See the diagram on page 13:

<URL:http://www.datasheetspdf.com/datasheet/download.php?id=840322>

Do note that even this is not uniform with systems with the dw9714 lens
controller: the properties depend on the lens spring spring constant and the
weight of the moving lens package, for instance.

For these reasons I do think that this warrants having a specific control
for such devices.

Additionally, there will be controls related to ringing compensation. The
user (for an auto focus algorithm) still might want to disable the hardware
ringing compensation so a menu control would be needed for the purpose.
That's something that can well be addressed later on, just FYI.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
