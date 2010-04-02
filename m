Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40185 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab0DBKUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 06:20:15 -0400
Date: Fri, 2 Apr 2010 12:20:11 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding
 LIRC and decoder plugins
Message-ID: <20100402102011.GA6947@hardeman.nu>
References: <20100401145632.5631756f@pedra>
 <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 01, 2010 at 09:44:12PM -0400, Jon Smirl wrote:
> On Thu, Apr 1, 2010 at 1:56 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > This series of 15 patches improves support for IR, as discussed at the
> > "What are the goals for the architecture of an in-kernel IR system?"
> > thread.
> >
> > It basically adds a raw decoder layer at ir-core, allowing decoders to plug
> > into IR core, and preparing for the addition of a lirc_dev driver that will
> > allow raw IR codes to be sent to userspace.
> >
> > There's no lirc patch in this series. I have also a few other patches from
> > David Härdeman that I'm about to test/review probably later today, but
> > as I prefer to first merge what I have at V4L/DVB tree, before applying
> > them.
> 
> Has anyone ported the MSMCE driver onto these patches yet? That would
> be a good check to make sure that rc-core has the necessary API.

I still plan to make lots of changes to the rc-core API (I just have to 
convince Mauro first, but I'll get there). What I have done is to port 
your port of the msmce driver to the suggested rc-core subsystem I sent 
you in private a week or so ago, and it works fine (I've bought the 
hardware and tested it with 20 or so different protocols).

The subsystem I suggested is basically what I'm using as inspiration 
while working with Mauro in improving rc-core so msmce should work well 
with the end product...but there's still some ground to cover.

Porting the msmce driver to rc-core will be high on my list of 
priorities once I've done some more changes to the API.

> Cooler if it works both through LIRC and with an internal protocol
> decoder. The MSMCE driver in my old patches was very simplified, it
> removed about half of the code from the LIRC version.

Yes, and it was a great help to me at least...thanks :)

-- 
David Härdeman
