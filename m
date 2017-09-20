Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38139 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdITUx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:53:29 -0400
Date: Wed, 20 Sep 2017 15:53:27 -0500
From: Rob Herring <robh@kernel.org>
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label
 documentation, DT example
Message-ID: <20170920205327.qmgz65kn45aavomx@rob-hp-laptop>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
 <20170918102349.8935-5-sakari.ailus@linux.intel.com>
 <20170918105655.GA14591@amd>
 <20170918144923.dnhrxkirle3fvdfo@valkosipuli.retiisi.org.uk>
 <20170918205407.GA1849@amd>
 <809f7590-7641-e8bc-c009-4fed05d5827c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <809f7590-7641-e8bc-c009-4fed05d5827c@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 19, 2017 at 11:01:02PM +0200, Jacek Anaszewski wrote:
> Hi Pavel,
> 
> On 09/18/2017 10:54 PM, Pavel Machek wrote:
> > On Mon 2017-09-18 17:49:23, Sakari Ailus wrote:
> >> Hi Pavel,
> >>
> >> On Mon, Sep 18, 2017 at 12:56:55PM +0200, Pavel Machek wrote:
> >>> Hi!
> >>>
> >>>> Specify the exact label used if the label property is omitted in DT, as
> >>>> well as use label in the example that conforms to LED device naming.
> >>>>
> >>>> @@ -69,11 +73,11 @@ Example
> >>>>  			flash-max-microamp = <320000>;
> >>>>  			led-max-microamp = <60000>;
> >>>>  			ams,input-max-microamp = <1750000>;
> >>>> -			label = "as3645a:flash";
> >>>> +			label = "as3645a:white:flash";
> >>>>  		};
> >>>>  		indicator@1 {
> >>>>  			reg = <0x1>;
> >>>>  			led-max-microamp = <10000>;
> >>>> -			label = "as3645a:indicator";
> >>>> +			label = "as3645a:red:indicator";
> >>>>  		};
> >>>>  	};
> >>>
> >>> Ok, but userspace still has no chance to determine if this is flash
> >>> from main camera or flash for front camera; todays smartphones have
> >>> flashes on both cameras.
> >>>
> >>> So.. Can I suggset as3645a:white:main_camera_flash or main_flash or
> >>> ....?
> >>
> >> If there's just a single one in the device, could you use that?
> >>
> >> Even if we name this so for N9 (and N900), the application still would only
> >> work with the two devices.
> > 
> > Well, I'd plan to name it on other devices, too.
> > 
> >> My suggestion would be to look for a flash LED, and perhaps the maximum
> >> current as well. That should generally work better than assumptions on the
> >> label.
> > 
> > If you just look for flash LED, you don't know if it is front one or
> > back one. Its true that if you have just one flash it is usually on
> > the back camera, but you can't know if maybe driver is not available
> > for the main flash.
> > 
> > Lets get this right, please "main_camera_flash" is 12 bytes more than
> > "flash", and it saves application logic.. more than 12 bytes, I'm sure. 
> 
> What you are trying to introduce is yet another level of LED class
> device naming standard, one level below devicename:colour:function.
> It seems you want also to come up with the set of standarized LED
> function names. This would certainly have to be covered for consistency.

I really dislike how this naming convention is used for label. label is 
supposed to be the phyically identifiable name. Having the devicename 
defeats that. Perhaps color, too. We'd be better off with a color 
property. It seems we're overloading the naming with too many things. 
Now we're adding device association.

I do want to see standard names though. On 96boards for example, there 
are defined LEDs and locations. The function on some are defined (e.g. 
WiFi/BT) and somewhat undefined on others (user{1-4}). I'd like to see 
the same label across all boards.

Rob
