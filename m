Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63561 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2EHRzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 13:55:01 -0400
Received: by pbbrp8 with SMTP id rp8so8324050pbb.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 10:55:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA91BBF.5060405@iki.fi>
References: <4FA91BBF.5060405@iki.fi>
Date: Tue, 8 May 2012 19:55:01 +0200
Message-ID: <CA+O4pCJPgdcQxKRGEMbQZ2e0yL1evoOhcMMmX8YH7OFnKLJXqw@mail.gmail.com>
Subject: Re: [RFCv1] DVB-USB improvements
From: Markus Rechberger <mrechberger@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 8, 2012 at 3:12 PM, Antti Palosaari <crope@iki.fi> wrote:
> Factors behind the changes are mostly coming from the fact current struct
> dvb_usb_device_properties contains so many static configuration options. You
> cannot change single dvb_usb_device_properties easily (safely) at runtime
> since it is usually driver global struct and thus shared between all the DVB
> USB driver instances. That fits just fine for the traditional devices where
> all configuration is same for the devices having single USB ID. Nowadays we
> have more and more devices that are based of chipset vendor reference
> designs - even using just single USB ID chipset vendor have given for that
> chipset. These reference designs still varies much about used chips and
> configurations. Configuring different base chips, USB-bridge, demod, tuner,
> and also peripheral properties like dual tuners, remotes and CI is needed to
> do runtime because of single USB ID is used for that all.
>
> My personal innovator behind all these is problems I met when developing
> AF9015 and AF9035 drivers. Also RTL2831U and RTL2832U are kinda similar and
> have given some more motivation.
>
> Here is small list what I am planning to do. It is surely so much work that
> everything is not possible, but lets try to select most important and
> easiest as a higher priority.
>
>
> resume / suspend support
> -------------------
> * very important feature
> * crashes currently when DVB USB tries to download firmware when resuming
> from suspend
>
> read_config1
> -------------------
> * new callback to do initial tweaks
> * very first callback
> * is that really needed?
>
> read_mac_address => read_config2
> -------------------
> * rename it read_config2 or read_config if read_config1 is not implemented
> at all
> * rename old callback and extend it usage as a more general
> * only 8 devices use currently
> * when returned mac != 0 => print mac address as earlier, otherwise work as
> a general callback
>
> new callback init()
> -------------------
> * called after tuner attach to initialize rest of device
> * good place to do some general settings
>  - configure endpoints
>  - configure remote controller
>  - configure + attach CI
>
> change DVB-USB to dynamic debug
> -------------------
> * use Kernel new dynamic debugs instead of own proprietary system
>
> download_firmware
> -------------------
> * struct usb_device => struct dvb_usb_device
> * we need access for the DVB USB driver state in every callback
>
> identify_state
> -------------------
> * struct usb_device => struct dvb_usb_device
> * we need access for the DVB USB driver state in every callback
>
> attach all given adapter frontends as once
> -------------------
> * for the MFE devices attach all frontends as once
> * deregister all frontends if error returned
> * small effect only for MFE
>
> attach all given adapter tuners as once
> -------------------
> * deregister all frontends if error returned
> * small effect only for MFE
>
> make remote dynamically configurable
> -------------------
> * default keytable mapped same level with USB-ID & device name etc.
> * there is generally 3 things that could be mapped to USB ID
>  - USB IDs (cold + warm)
>  - device name
>  - remote controller keytable
>  - all the others could be resolved & configured dynamically
> * it is not only keytable but whole remote should be changed dynamically
> configurable
>
> make stream dynamically configurable
> -------------------
> * we need change stream parameters in certain situations
>  - there is multiple endpoints but shared MFE
>  - need to set params according to stream bandwidth (USB1.1, DVB-T, DVB-C2
> in same device)
>  - leave old static configrations as those are but add callbacks to get new
> values at runtime
>
> dynamically growing device list in dvb_usb_device_properties
> -------------------
> * currently number of devices are limited statically
> * there is devices having ~50 or more IDs which means multiple
> dvb_usb_device_properties are needed
>
> dynamic USB ID support
> -------------------
> * currently not supported by DVB USB
>
> analog support for the DVB USB
> -------------------
> * currently not supported by DVB USB
> * I have no experience
> * em28xx can be converted?
>

You might also work on a dvb library, just like libv4l has right now,
that might satisfy the streaming requests which have been made on this
mailinglist :-)

BR,
Markus

>
>
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
