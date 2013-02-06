Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60348 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab3BFO5l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 09:57:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1U36Rd-0001Ih-Hb
	for linux-media@vger.kernel.org; Wed, 06 Feb 2013 15:57:53 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 15:57:53 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 15:57:53 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Replacement for vloopback?
Date: Wed, 06 Feb 2013 15:57:12 +0100
Message-ID: <ketr05$hld$1@ger.gmane.org>
References: <ketngk$dit$1@ger.gmane.org> <ketq5c$8dc$1@ger.gmane.org> <CAGoCfiwevN2rtsL2Az1USfSkpUQEGij6ECVArB-Li+X8yNxJZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <CAGoCfiwevN2rtsL2Az1USfSkpUQEGij6ECVArB-Li+X8yNxJZQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well, I have a (what I think) pretty simple use case here, but without
any gstreamer involved:

I have a software video sip phone (based on pjsip). I would like to
automatically initiate a video call when there is a certain amount of
motion detected.

Both software packages access a v4l device. I have no idea how to change
that to a gstreamer pipe. Ma guess is that it will probably be very
difficult :-(

Michael

Am 06.02.2013 15:51, schrieb Devin Heitmueller:
> On Wed, Feb 6, 2013 at 9:42 AM, Neuer User <auslands-kv@gmx.de> wrote:
>> If it is not possible to have two applications access the same video
>> stream, that is pretty detrimentical to quite a lot of use cases, e.g.:
>>
>> a.) Use motion to detect motion and record video. At the same time view
>> the camera output on the screen.
>>
>> b.) Stream a webcam output over the net and at the same time view it on
>> the screen.
> 
> FWIW:  usually when people ask for this sort of functionality
> (performing multiple functions on the same stream), they will
> typically use frameworks like gstreamer, which allow for creation of
> pipelines to perform the sorts of use cases you have described.
> 
> Devin
> 


