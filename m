Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34125 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0IIG4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 02:56:07 -0400
Received: by wwb34 with SMTP id 34so5014wwb.1
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 23:56:05 -0700 (PDT)
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>,
	eduardo.valentin@nokia.com,
	"ext Eino-Ville Talvala" <talvala@stanford.edu>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] Illuminators and status LED controls
References: <b7de5li57kosi2uhdxrgxyq9.1283891610189@email.android.com>
	<87fwxkcbat.fsf@macbook.be.48ers.dk> <20100909080702.1687d29a@tele>
	<201009090825.52050.hverkuil@xs4all.nl>
Date: Thu, 09 Sep 2010 08:55:54 +0200
In-Reply-To: <201009090825.52050.hverkuil@xs4all.nl> (Hans Verkuil's message
	of "Thu, 9 Sep 2010 08:25:51 +0200")
Message-ID: <87aanrcsn9.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

>>>>> "Hans" == Hans Verkuil <hverkuil@xs4all.nl> writes:

Hi,
 
 >> - the status LED should be controlled by the LED interface.

 Hans> I originally was in favor of controlling these through v4l as
 Hans> well, but people made some good arguments against that. The main
 Hans> one being: why would you want to show these as a control? What is
 Hans> the end user supposed to do with them? It makes little sense.

 Hans> Frankly, why would you want to expose LEDs at all? Shouldn't this
 Hans> be completely hidden by the driver? No generic application will
 Hans> ever do anything with status LEDs anyway. So it should be the
 Hans> driver that operates them and in that case the LEDs do not need
 Hans> to be exposed anywhere.

It's not that it *HAS* to be exposed - But if we can, then it's nice to do
so as it gives flexibility to the user instead of hardcoding policy in
the kernel.

-- 
Bye, Peter Korsgaard
