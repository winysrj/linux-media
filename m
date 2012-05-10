Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44561 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2EJOZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 10:25:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org, Atsuo Kuwahara <kuwahara@ti.com>,
	sakari.ailus@iki.fi
Subject: Re: Advice on extending libv4l for media controller support
Date: Thu, 10 May 2012 16:26:01 +0200
Message-ID: <1531842.14LCmpGIx7@avalon>
In-Reply-To: <4FABCEBA.7080609@redhat.com>
References: <CAC-OdnBNiT35tc_50QAXvVp8+b5tWLMWqc5i1q3qWYTp5c360g@mail.gmail.com> <CAC-OdnCmXiz1wKST-YAambJFToeqNJhEaMVKYwz_FHV0N+sbyw@mail.gmail.com> <4FABCEBA.7080609@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 10 May 2012 16:20:42 Hans de Goede wrote:
> Hi,
> 
> I somehow missed the original mail. This is in essence the same problem
> as with the omap3 and Laurent and Sakari and I did a design for that
> in Brussels in the last quarter of 2011, Laurent and Sakari would work
> on fleshing that out, so it is probably best to talk to them about this.

Let's get Sakari into the loop then. I think he's the most knowledgeable about 
this, even though no implementation has been released (Nokia killing MeeGo 
obviously didn't help).

> On 05/10/2012 03:54 PM, Sergio Aguirre wrote:
> > +Atsuo
> > 
> > On Wed, May 9, 2012 at 7:08 PM, Sergio Aguirre wrote:
> >> Hi Hans,
> >> 
> >> I'm interested in using libv4l along with my omap4 camera project to
> >> adapt it more easily to Android CameraHAL, and other applications, to
> >> reduce complexity of them mostly...
> >> 
> >> So, but the difference is that, this is a media controller device I'm
> >> trying to add support for, in which I want to create some sort of plugin
> >> with specific media controller configurations, to avoid userspace to
> >> worry about component names and specific usecases (use sensor resizer, or
> >> SoC ISP resizer, etc.).
> >> 
> >> So, I just wanted to know your advice on some things before I start
> >> hacking your library:
> >> 
> >> 1. Should it be the right thing to add a new subfolder under "lib/",
> >> named like "libomap4iss-mediactl" or something like that ?
> >> 2. Do you know if anyone is working on something similar for any other
> >> Media Controller device ?
> >> 
> >> Thanks in advance for your inputs.
> >> 
> >> Regards,
> >> Sergio

-- 
Regards,

Laurent Pinchart

