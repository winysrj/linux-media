Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f171.google.com ([209.85.210.171]:51535 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZIOWs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 18:48:56 -0400
Received: by yxe1 with SMTP id 1so5907849yxe.21
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 15:48:59 -0700 (PDT)
Date: Tue, 15 Sep 2009 15:48:37 -0700
From: Brandon Philips <brandon@ifup.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: video device (stream) sharing
Message-ID: <20090915224837.GC29973@jenkins.home.ifup.org>
References: <4A977BB6.5040101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A977BB6.5040101@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08:39 Fri 28 Aug 2009, Hans de Goede wrote:
> The basic idea is to have some sort of userspace proxy process which allows
> sharing for example a webcam between 2 devices. For me there are 2 major
> criteria which need to be matched to be able to do this:
> 
> 1) No (as in 0) functionality regressions for the single use case, iow when
>    only one app opens the device everything should work as before
>
> 2) No significant performance regressions for the single use case. Sure this
>    may be a bit slower, but not much!

Agreed and it should be possible to do with shm and a fast daemon.

> So the whole stream owner concept does not work. 

Agreed. This will need to be a per user session daemon like PulseAudio
is by default.

> -limit the amount of reported supported formats (enum fmt) to
>  formats which we can create by conversion from native formats

Agreed.

> -report the full list of supported resolutions to all applications
> -capture at the highest resolution requested by any of the
>  applications

All supported resolutions that don't cause a drop in frame capture
rate that the other applications are getting. I am not sure how this
heuristic will end up working and at this point I am a long way from
tackling this problem.

I am guessing that applications can provide hints on what they need
from the hardware.

But, alot of my interest is in enabling interesting things to be done
in that other operating systems can do:

 - Face tracking and panning
 - Software autofocus
 - "Take photo of the laptop theif" software running in background
 - Backup your camera output while Pidgin/Skype/etc is running

These sorts of applications will be fine with the same data format
that the current running application is using. 

> -downsample for applications which want a lower resolution

Yes.

I have been reading quite a bit of the PulseAudio code while I have
been working on my prototype. My hope is to ensure that we get the
implementation of this daemon and library right enough so as to avoid
layers upon layers of APIs

 http://rudd-o.com/en/linux-and-free-software/how-pulseaudio-works/images/pulseaudio-diagram.png?isImage=1

:D

Thanks for the input.

Cheers,

	Brandon
