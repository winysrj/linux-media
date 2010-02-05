Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:33651 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab0BEOaW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 09:30:22 -0500
Message-ID: <4B6C2BDD.80002@adit.fi>
Date: Fri, 05 Feb 2010 16:31:57 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
	Antti Palosaari <crope@iki.fi>, mchehab@infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz> <4B5CDB53.6030009@iki.fi> <4B5D6098.7010700@gmail.com> <4B5DDDFB.5020907@iki.fi> <alpine.LRH.2.00.1001261406010.15694@twin.jikos.cz> <4B6AA211.1060707@gmail.com> <4B6ACA4B.2030906@adit.fi> <4B6AD3DB.8090801@redhat.com> <4B6AE241.6090900@adit.fi> <4B6B0039.7010206@redhat.com>
In-Reply-To: <4B6B0039.7010206@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Mauro Carvalho Chehab wrote:
> Pekka Sarnila wrote:

>>So dvb is both as a place and a name misleading.
> 
> It happens that almost all tv products (analog or digital) come with some 
> IR support. But you can find also some products that are just IR.
> 
> That's why we're moving it to be outside the V4L and the DVB directory.
> For now, it is at /drivers/media/IR (since it helps us to move the code, while
> there are still some dependencies at ir-common). But the better is to move it
> later to /drivers/IR or /drivers/input/IR.

I was referring to the dvb-usb-remote. I think it's right place should 
not be under dvb but under usb/remotes. If you have an usb remote device 
that has nothing to do with audio-video, it would be strange to have its 
driver under dvb. Dvb is a protocol name and should be used us such in 
linux kernel as well. Otherwise it is misleading.

>>Well I was talking about HID remotes that don't give ir codes but key
>>codes. What to do with them?
>  
> What happens if you use it to receive keycodes from a different IR using
> the same protocol?

Nothing. It responds only to those codes that are at the moment loaded 
into its internal table.

> Maybe it can still be valid to keep allowing keycode translation.

Yes, provided that it can translate also keyboard keycodes to some other 
keycodes.

> Well, as HID, you may loose the capability of using a different IR than the
> one shipped with the af9015. It may make sense to just disable HID and use
> USB Vendor Class.

Yes, that is the question. Both ways have good arguments for.

>>The thing is that remote controller trough HID layer does not provide IR
>>keycode but standard keyboard key code. And HID layer does not know that
>>it is a remote controller but sees it as an ordinary usb keyboard. The
>>question is that how can it tell the upper layer that it really is a
>>remote controller so that the event would end up to generic ir-core.
> 
> For HID remote controllers, the only way I see is to have an USB ID list of devices
> that are known to be remote controllers and register them via ir_input_register,
> instead of input_register_device.

Well, the current kernel architecture for input devices is so, that a 
higher layer generic driver registers a handler with the input layer 
telling by the way of capabilities what kind deices it is willing to 
handle. Lower layer devices drivers register with the input layer 
telling it what kind of capabilities they have. Based on that the input 
layer finds a match and relays events accordingly. Although arguments 
against this mechanism can be found, one of its good sides is that it 
completely separates generic device layer from device driver layer. E.g. 
the coder of mouse layer does not need to know anything about various 
mouse device drivers and vv. This is very good for the highly 
distributed way linux is being developed.

IMHO ir remote controller receivers should be no exception to that. So 
rather than use separate ir_input_register, a generic remote controller 
layer (not only IR code based) should register a handler with the input 
layer with suitable capabilities, and all remote controller device 
drivers should register with the input layer telling by capabilities 
that they are remote controllers. They would send events in standard way 
to the input layer. Input layer would do the rest as normally.

Also in naming, due consideration should be given to the fact that IR 
can be used for other type of communication as well.

> Cheers,
> Mauro
