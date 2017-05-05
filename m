Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36600 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754409AbdEEIuB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 May 2017 04:50:01 -0400
Date: Fri, 5 May 2017 11:49:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: Re: [RFC 3/3] dt: bindings: Add a binding for referencing EEPROM
 from camera sensors
Message-ID: <20170505084954.GG7456@valkosipuli.retiisi.org.uk>
References: <1493720749-31509-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493720749-31509-4-git-send-email-sakari.ailus@linux.intel.com>
 <20170504143803.f5pndnvm73jjfe7i@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170504143803.f5pndnvm73jjfe7i@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 04, 2017 at 04:38:04PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Tue, May 02, 2017 at 01:25:49PM +0300, Sakari Ailus wrote:
> > Many camera sensor devices contain EEPROM chips that describe the
> > properties of a given unit --- the data is specific to a given unit can
> > thus is not stored e.g. in user space or the driver.
> > 
> > Some sensors embed the EEPROM chip and it can be accessed through the
> > sensor's I²C interface. This property is to be used for devices where the
> > EEPROM chip is accessed through a different I²C address than the sensor.
> > 
> > The intent is to later provide this information to the user space.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > index e52aefc..9bd2005 100644
> > --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> > +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> > @@ -80,6 +80,9 @@ Optional properties
> >  - lens-focus: A phandle to the node of the lens. Only valid for device
> >    nodes that are related to an image sensor.
> >  
> > +- eeprom: A phandle to the node of the related EEPROM. Only valid for
> > +  device nodes that are related to an image sensor.
> 
> Here it's even more obvious, that the second sentence is redundant.
> The requirement is already in the first sentence :) Instead it
> should be mentioned, that this is to be used by devices not having
> their own embedded eeprom. How about:
> 
> eeprom: A phandle to the node of the EEPROM describing the camera
> sensor (i.e. device specific calibration data), in case it differs
> from the sensor node.

Ack. I addressed the rest of the feedback, too, and posted RFC v2.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
