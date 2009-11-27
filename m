Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58254 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZK0EdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 23:33:16 -0500
Date: Thu, 26 Nov 2009 20:33:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091127043318.GK6936@core.coreip.homeip.net>
References: <4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <20091123173726.GE17813@core.coreip.homeip.net> <4B0B6321.3050001@wilsonet.com> <20091126053109.GE23244@core.coreip.homeip.net> <A910E742-51B5-45E0-AD80-B9AE0728D9FB@wilsonet.com> <20091126232311.GD6936@core.coreip.homeip.net> <4B0F3963.8040701@wilsonet.com> <9e4733910911261908l122263c3x68854e8a00334eae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e4733910911261908l122263c3x68854e8a00334eae@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 10:08:29PM -0500, Jon Smirl wrote:
> On Thu, Nov 26, 2009 at 9:28 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
> >> No, at present we expect 1:1 button->event mapping leaving macro
> >> expansion (i.e. KEY_PROG1 ->  "do some multi-step sequence" to
> >> userspace).
> >
> > Hm. So ctrl-x, alt-tab, etc. would have to be faked in userspace somehow.
> > Bummer.
> 
> That is scripting. Scripting always needs to be done in user space.
> 
> In the code I posted there is one evdev device for each configured
> remote. Mapped single keycodes are presented on these devices for each
> IR burst. There is no device for the IR receiver.  A LIRC type process
> could watch these devices and then execute scripts based on the
> keycodes reported.
> 
> The configfs model is very flexible. You could make a "remote" that
> translates the UP/DOWN buttons of several different remotes into
> KEY_UP/DOWN.  That lets several different remotes control the same
> app.
> 
> Sure it is clunky to play with IR hex codes and keycodes in the
> configfs mapping dir. If you don't like it write a GUI app for
> manipulating the codes. GUI would then generate a script for udev to
> run which builds the configfs entries.
> 
> Maybe I should rename those directory entries to "app" instead of
> "remote". They contain the mappings from IR hex codes to keycodes that
> an app is interested in. Usually there is a 1:1 correspondence between
> remote and app but there doesn't have to be.
> 

Maybe we should revisit Jon's patchset as well. Regretfully I did not
have time to do that when it was submitted the last time.

-- 
Dmitry
