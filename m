Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55045 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752587Ab1GaWyw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jul 2011 18:54:52 -0400
Message-ID: <4E35DD38.7070609@gmx.de>
Date: Sun, 31 Jul 2011 22:54:48 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH/RFC] fbdev: Add FOURCC-based format configuration API
References: <4DDAE63A.3070203@gmx.de>	<201107111732.52156.laurent.pinchart@ideasonboard.com>	<Pine.LNX.4.64.1107280943470.20737@axis700.grange>	<201107281251.35018.laurent.pinchart@ideasonboard.com> <CAMuHMdX=c=p7oASCE+GgY9AgaCPWoXRQyjEGpn4BvA9xSY6GQg@mail.gmail.com>
In-Reply-To: <CAMuHMdX=c=p7oASCE+GgY9AgaCPWoXRQyjEGpn4BvA9xSY6GQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2011 08:32 PM, Geert Uytterhoeven wrote:
> On Thu, Jul 28, 2011 at 12:51, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com>  wrote:
>>> As for struct fb_var_screeninfo fields to support switching to a FOURCC
>>> mode, I also prefer an explicit dedicated flag to specify switching to it.
>>> Even though using FOURCC doesn't fit under the notion of a videomode, using
>>> one of .vmode bits is too tempting, so, I would actually take the plunge and
>>> use FB_VMODE_FOURCC.
>>
>> Another option would be to consider any grayscale>  1 value as a FOURCC. I've
>> briefly checked the in-tree drivers: they only assign grayscale with 0 or 1,
>> and check whether grayscale is 0 or different than 0. If a userspace
>> application only sets grayscale>  1 when talking to a driver that supports the
>> FOURCC-based API, we could get rid of the flag.
>>
>> What can't be easily found out is whether existing applications set grayscale
>> to a>  1 value. They would break when used with FOURCC-aware drivers if we
>> consider any grayscale>  1 value as a FOURCC. Is that a risk we can take ?
>
> I think we can. I'd expect applications to use either 1 or -1 (i.e.
> all ones), both are
> invalid FOURCC values.
>
> Still, I prefer the nonstd way.
> And limiting traditional nonstd values to the lowest 24 bits (there
> are no in-tree
> drivers using the highest 8 bits, right?).

Okay, it would be okay for me to
- write raw FOURCC values in nonstd, enable FOURCC mode if upper byte != 0
- not having an explicit flag to enable FOURCC
- in FOURCC mode drivers must set visual to FB_VISUAL_FOURCC
- making support of FOURCC visible to userspace by capabilites |= FB_CAP_FOURCC

The capabilities is not strictly necessary but I think it's very useful as
- it allows applications to make sure the extension is supported (for example to 
adjust the UI)
- it allows applications to distinguish whether a particular format is not 
supported or FOURCC at all
- it allows signaling further extensions of the API
- it does not hurt, one line per driver and still some bytes in fixinfo free


So using it would look like this:
- the driver must have capabilities |= FB_CAP_FOURCC
- the application may check capabilities to know whether FOURCC is supported
- the application may write a raw FOURCC value in nonstd to request changing to 
FOURCC mode with this format
- when the driver switches to a FOURCC mode it must have visual = 
FB_VISUAL_FOURCC and the current FOURCC format in nonstd
- the application should check visual and nonstd to make sure it gets what it wanted


So if there are no strong objections against this I think we should implement it.
I do not really care whether we use a union or not but I think if we decide to 
have one it should cover all fields that are undefined/unused in FOURCC mode.


Hope we can find anything that everyone considers acceptable,

Florian Tobias Schandinat
