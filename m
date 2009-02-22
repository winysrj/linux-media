Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp123.rog.mail.re2.yahoo.com ([206.190.53.28]:24304 "HELO
	smtp123.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752321AbZBVUn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 15:43:57 -0500
Message-ID: <49A1B90B.8080502@rogers.com>
Date: Sun, 22 Feb 2009 15:43:55 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Jonathan Isom <jeisom@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Kworld atsc 110 nxt2004 init
References: <1767e6740902181819i9982865u1dec75b5f337b8a4@mail.gmail.com>
In-Reply-To: <1767e6740902181819i9982865u1dec75b5f337b8a4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonathan Isom wrote:
> Hi
> I was looking over my logs and I'm wondering is
> "nxt200x: Timeout waiting for nxt2004 to init"
> common 

No its not common

> or is this womething I need to worry about.  I got one shortly before a
> lockup(No backtrace).  Nothing was doing other than dvbstreamer sitting idle.
> I'll provide further logs if it should be needed.  I would think that
> It would need to
> only be initialize at module load.  Am I wrong in this thinking?
>
> in kernel  drivers 2.6.28.4
>
> Later
>
> Jonathan

Quick! Get out of you house now, she's about to blow !!!

Just kidding.  I don't think its anything to worry about.  The timeout
is by design (see the nxt200x.ko module).  I'm not sure why you've run
up against this; it looks to have occurred several hours after
initialization.  Perhaps a quirk in the microcode of the demod caused it.

