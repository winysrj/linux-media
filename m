Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbZGCJDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2009 05:03:11 -0400
Message-ID: <4A4DC9D9.9010907@redhat.com>
Date: Fri, 03 Jul 2009 11:05:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Joel Jordan <zcacjxj@hotmail.com>, video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMPIA Silvercrest 2710
References: <BAY103-W483504B84F25BC84275FAAC190@phx.gbl> <20090703032100.64c3f70d@pedra.chehab.org>
In-Reply-To: <20090703032100.64c3f70d@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


On 07/03/2009 08:21 AM, Mauro Carvalho Chehab wrote:
> Hi Joel,
>
> Em Fri, 7 Nov 2008 10:10:45 +0000
> Joel Jordan<zcacjxj@hotmail.com>  escreveu:
>
>
>>    Has there been any work done on the eMPIA Silvercrest EM2710 (device for webcams)?
>
> I borrowed a Silvercrest 1.3 Mpix camera, based on em2710 and mt9v011 with a
> friend, at the end of a conference that happened last week. After spending some
> spare time on it at the airplane while returning back home, I discovered how to
> enable stream on it.
>

My that webcam has done some interesting travelling (me -> Dough -> you), I'm glad
it finally ended at someone who has managed to get it to produce a picture under Linux.

> Basically, there were just a very few registers that was needing a different
> initialization, plus a driver to the sensor inside.
>
> Could you please test the latest development code and see if this works for you also?
>
> It is at:
> 	http://linuxtv.org/hg/v4l-dvb
>
> The driver is the em28xx. As the camera uses the generic vendor usb id
> (eb1a:2820), you'll need to force the driver to load the proper card
> parameters, by using card=71 at module probing. This can be done by calling:
>
> 	modprobe em28xx card=71
>
> Or by adding an options line on your /etc/modprobe.conf (or the equivalent file on your machine):
> 	options em28xx card=71
>
> You need to do one of the above procedures _before_ plug the camera, or
> otherwise it will take the generic entry that won't work.
>


Hmm, having to specify the card=71 parameter, sucks, that makes this a very non plug
and play / not just working experience for end users. Question would it be possible to
modify the em28xx driver to, when it sees the generic usb-id, setup the i2c controller
approriately and then check:
1) If there is anything at the i2c address of the mt9v011 sensor
2) Read a couple of identification registers (often sensors have special non changing
    registers for this)
3) If both the 1 and 2 test succeed set card to 71 itself ?

This is how we handle the problem of having one generic usb-id for a certain bridge, with
various different sensors used in different cams, I know the em28xx is a lot more complicated
as it does a lot more, but this may still work ?

Regards,

Hans
