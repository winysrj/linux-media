Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab2EKKNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 06:13:54 -0400
Message-ID: <4FACE659.7080705@redhat.com>
Date: Fri, 11 May 2012 12:13:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Atsuo Kuwahara <kuwahara@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: Advice on extending libv4l for media controller support
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com>  <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com> <1336662597.15542.15.camel@iivanov-desktop>
In-Reply-To: <1336662597.15542.15.camel@iivanov-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/10/2012 05:09 PM, Ivan T. Ivanov wrote:
>
> Hi Sergio,
>
> On Thu, 2012-05-10 at 08:54 -0500, Sergio Aguirre wrote:
>> +Atsuo
>>
>> On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre
>> <sergio.a.aguirre@gmail.com>  wrote:
>>> Hi Hans,
>>>
>>> I'm interested in using libv4l along with my omap4 camera project to
>>> adapt it more easily
>>> to Android CameraHAL, and other applications, to reduce complexity of
>>> them mostly...
>>>
>>> So, but the difference is that, this is a media controller device I'm
>>> trying to add support for,
>>> in which I want to create some sort of plugin with specific media
>>> controller configurations,
>>> to avoid userspace to worry about component names and specific
>>> usecases (use sensor resizer, or SoC ISP resizer, etc.).
>>>
>>> So, I just wanted to know your advice on some things before I start
>>> hacking your library:
>>>
>
> Probably following links can help you. They have been tested
> with the OMAP3 ISP.
>
> Regards,
> iivanov
>
> [1] http://www.spinics.net/lists/linux-media/msg31901.html
> [2]
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/32704

Ah, cool. But that is a bit old stuff. IIRC (pretty sure I do), then we
came to the conclusion that the following would be the best solution:

1) The existing mediactl lib would be extended with a libmediactlvideo lib, which
would be able to control media-ctrl video chains, ie it can:
-give a list of possibly supported formats / sizes / framerates
-setup the chain to deliver a requested format
Since the optimal setup will be hardware specific the idea was to give this
libs per soc plugins, and a generic plugin for simple socs / as fallback.

2) A cmdline utility to set up a chain using libmediactlvideo, so that things
can be tested using raw devices, ie without libv4l2 coming into play, just
like apps like v4l2-ctl allow low level control mostly for testing purposes

3) There would then be a libv4l2 plugin much like the above linked omap3 plugin,
but then generic for any mediactl using video devices, which would use
libmediactlvideo to do the work of setting up the chain (and which will fail to
init when the to be opened device is not part of a mediactl controlled chain).

And AFAIK some work was done in this direction. Sakari? Laurent?

Eitherway it is about time someone started working on this, and I would
greatly prefer the above plan to be implemented. Once we have this in place,
then we can do a new v4l-utils release which officially supports the plugin
API (which currently only lives in master, not in any releases).

Regards,

Hans
