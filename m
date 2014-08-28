Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64871 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbaH1DrP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 23:47:15 -0400
Message-ID: <53FEA63E.9020208@gmx.net>
Date: Thu, 28 Aug 2014 05:47:10 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: Kaya Saman <SamanKaya@netscape.net>, linux-media@vger.kernel.org
Subject: Re: Advice on DVB-S/S2 card and CAM support
References: <53D58EDF.1090102@netscape.net>
In-Reply-To: <53D58EDF.1090102@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2014 01:44 AM, Kaya Saman wrote:
> Hi,
>
> I'm wondering what the best solution for getting satellite working on
> Linux is?
>
>
> Currently I have a satellite box with CAM module branded by the
> Satellite TV provider we are with.
>
>
> As I am now migrating everything including TV through my HTPC
> environment I would also like to link the satellite box up to the HTPC
> too to take advantage of the PVR and streaming capabilities.
>
>
> I run XBMC as my frontend so I was looking into TV Headend to take care
> of PVR side of things.
>
>
> My greatest issue though is what is the best solution for getting the
> satellite system into the HTPC?
>
>
> After some research my first idea was to use a satellite tuner card;
> models are available for Hauppauge and other vendors so really it was
> about which was going to offer best compatibility with Linux? (distro is
> Arch Linux with 3.15 kernel)
>
> The model of card I was looking was from DVB-Sky:
>
> http://www.dvbsky.net/Products_S950C.html
>
> something like that, which has CAM module slot and is DVB-S/S2
> compatible and claims to have drivers supported by the Linuxtv project.
>
>
> Or alternately going for something like this:
>
> http://www.dvbsky.net/Products_T9580.html
>
> as it has a combined DVB-T tuner, then using a USB card reader for the
> CAM "smart card".
>
>
> Has anyone used the cards above, what are the opinions relating to them?
> Also would they work with motorized dishes?
>
>
> Since I'm not sure if "all" CAM's are supported as apparently our
> satellite tv provider wanted to lock out other receivers so they force
> people to use their own product;
>
> my second idea was to perhaps use a capture card with RCA inputs.
>
> Something like this:
>
> http://www.c21video.com/viewcast/osprey-210.html
>
> perhaps or a Hauppauge HD-PVR mk I edition:
>
> which according to the wiki is supported.
>
>
> Looking forward to hearing advice.
>
>
> Thanks.
>
>
> Kaya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Kaya,

RCA inputs is probably the last thing you want. Less quality, more of a 
pain to set up.

You may or may not be able to use that CAM - but even if it's supported, 
a CAM has downsides. It generally only supports one channel at a time - 
and surely not multiple channels from different frequencies (if you have 
more tuners). And it's more expensive, both the tuner (that needs a CI 
slot) and the CAM you need. Also, I'm not sure if tvheadend nowadays 
supports a CAM - it used not to, but support may have been added.

The main downside of a phoenix-mode cardreader is that it's harder to 
set up, but if you can find a guide for your provider it's generally 
doable. It's cheaper, more flexible and allows for faster channel switching.

As for a tuner, I personally suggest going for a USB-tuner. You never 
know if you want to connect you tuner to a notebook or NAS or anything 
in the future, with USB you're more flexible. If you do go for PCI-e, 
Tevii appears to have some supported products that are also available.

If you go for USB, support is somewhat problematic (problematic because 
many supported tuners are no longer available in stores), you'll have to 
see what's locally available. (perhaps also check second-hand) Be 
careful, some devices have various revisions. Always check 
http://linuxtv.org/wiki/index.php/Hardware_Device_Information

Very recently, Antti reviewed a patch from nibble.max to support the 
DVBsky S960. (and presumably it's direct clones from Mystique) This is a 
pretty cheap tuner that can still be found in shops. It would appear 
that as soon as this patch gets merged, this device will be supported if 
you compile v4l-dvb yourself, and in time support will make it into the 
kernel.

In any case, you want something with in-kernel support - something 
that's only supported by s2-liplianin or vendor drivers (like many 
dvbsky and TBS products) will only break in the long term. Only 
exception to this is Sundtek, but I personally have mixed feelings about 
closed source userspace drivers. I wouldn't recommend them personally.

Good luck,

P. van Gaans
