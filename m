Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34711 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZFQOjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 10:39:44 -0400
Message-ID: <4A390093.5090003@redhat.com>
Date: Wed, 17 Jun 2009 16:41:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>	<20090617065621.23515ab7@pedra.chehab.org>	<4A38CCAF.5060202@redhat.com> <20090617112802.152a6d64@pedra.chehab.org>
In-Reply-To: <20090617112802.152a6d64@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 06/17/2009 04:28 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 17 Jun 2009 12:59:59 +0200
> Hans de Goede<hdegoede@redhat.com>  escreveu:
>

<snip>

>>
>> As for usbvideo that supports (amongst others) the st6422 (from the out of tree
>> qc-usb-messenger driver), but only one usb-id ??. I'm currently finishing up adding
>> st6422 support to gspca (with all known usb-id's), I have 2 different cams to test this with.
>
> I have here one Logitech quickcam. There are several variants, and the in-tree
> and out-tree drivers support different models. I can test it here and give you
> a feedback. However, I don't have the original driver for it.
>

Ok, what is its usb id (they tend to be unique for Logitech cams) ?

>> zc0301
>> only supports one usb-id which has not yet been tested with gspca, used to claim a lot more
>> usb-id's but didn't actually work with those as it only supported the bridge, not the sensor
>> ->  remove it now ?
>
> I have one zc0301 cam that works with this driver. The last time I checked, it
> didn't work with gspca. I'll double check.
>

Ok, let me know how it goes. If it does not work, guess what I want you to bring along
to plumbers ? (you are coming to plumbers, or .. ? )

>> sn9c102
>> Supports a large number of cams also supported by gspca's sonixb / sonixj driver, we're using
>> #ifdef .... macros to detect if both are being build at the same time to include usb-id's only
>> in one of the 2.
>
> Btw, it would be interesting to work with the out-of-tree microdia driver,
> since there are some models that are supported only by the alternative driver.

Ack, only one small problem, which is another reason why Luca's drivers should slowly be phased
out, Luca has gone closed source with his sn9cxxx driver.

There is an out of tree driver for the new sn9c2xx models you talk about though, with active
developers, I've pushing them to get it into the mainline, I'll give it another try soonish.

Regards,

Hans
