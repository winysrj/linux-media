Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34475 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbeKNCTZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 21:19:25 -0500
MIME-Version: 1.0
References: <20181103145532.9323-1-user.vdr@gmail.com> <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
In-Reply-To: <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
From: VDR User <user.vdr@gmail.com>
Date: Tue, 13 Nov 2018 08:20:22 -0800
Message-ID: <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote buttons
To: hadess@hadess.net
Cc: linux-input@vger.kernel.org, Sean Young <sean@mess.org>,
        mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Sat, 2018-11-03 at 07:55 -0700, Derek Kelly wrote:
> > The following patch adds event codes for common buttons found on
> > various
> > provider and universal remote controls. They represent functions not
> > covered by existing event codes. Once added, rc_keymaps can be
> > updated
> > accordingly where applicable.
>
> Would be great to have more than "those are used", such as knowing how
> they are labeled, both with text and/or icons, and an explanation as to
> why a particular existing key isn't usable.

Hi Bastien,

Text & icons may vary from remote to remote but the purpose/function
of those buttons is basically the same. As explained, the defines in
this patch represent functions not already addressed by other defines.
See below for more detail. The one thing I will add that I probably
should've mentioned is that these defines focus on media/htpc/stb. If
you're not aware, Linux has become a common choice for these types of
systems thanks to the popularity of software like Plex, Kodi, Mythtv,
VDR, etc. Lastly, all these represent *common* functions in this area.
Please keep this in mind as you read further.

> > +/* Remote control buttons found across provider & universal remotes */
> > +#define KEY_LIVE_TV                  0x2e8   /* Jump to live tv viewing */
>
> KEY_TV?

KEY_TV selects TV as a *input source* the same as KEY_VCR, KEY_SAT,
KEY_CD, etc. whereas KEY_LIVE_TV jumps directly to live tv as opposed
to local/networked media playback, dvr playback, etc.

> > +#define KEY_OPTIONS                  0x2e9   /* Jump to options */
>
> KEY_OPTION?

Software vs. media playback options.

> > +#define KEY_INTERACTIVE                      0x2ea   /* Jump to interactive system/menu/item */
> > +#define KEY_MIC_INPUT                        0x2eb   /* Trigger MIC input/listen mode */
>
> KEY_MICMUTE?

This button doesn't mute the mic, in fact it does the opposite. The
mic is off until you press this button, thus triggering MIC
input/listen mode and allowing the user to speak his commands. It
automatically shuts off after X seconds of silence.

> > +#define KEY_SCREEN_INPUT             0x2ec   /* Open on-screen input system */
>
> KEY_SWITCHVIDEOMODE?

KEY_SWITCHVIDEOMODE is used for "Cycle between available video outputs
(Monitor/LCD/TV-out/etc) ". This is poorly labeled in my opinion and
should've been called KEY_SWITCHVIDEOOUTPUT or something similar.
"Video mode" typically refers to something entirely different - how
video is presented on the display, not what physical display you're
using. KEY_SCREEN_INPUT is used to bring up things like an on-screen
keyboard or other on-onscreen user input method.

> > +#define KEY_SYSTEM_MENU                      0x2ed   /* Open systems menu/display */
>
> KEY_MENU?

Systems menus as pertains to DVB. KEY_MENU is generic and having only
one `menu` option is problematic when you have different types of
menus which aren't accessible from each other.

> > +#define KEY_SERVICES                 0x2ee   /* Access services */
> > +#define KEY_DISPLAY_FORMAT           0x2ef   /* Cycle display formats */
>
> KEY_CONTEXT_MENU?

KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle through
how video is displayed on-screen to the user; full, zoomed,
letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for something
like bringing up a playback menu where you'd set things like
upscaling, deinterlacing, audio mixdown/mixup, etc.

> > +#define KEY_PIP                              0x2f0   /* Toggle Picture-in-Picture on/off */
> > +#define KEY_PIP_SWAP                 0x2f1   /* Swap contents between main view and PIP window */
> > +#define KEY_PIP_POSITION             0x2f2   /* Cycle PIP window position */
> > +
> >  /* We avoid low common keys in module aliases so they don't get huge. */
> >  #define KEY_MIN_INTERESTING  KEY_MUTE
> >  #define KEY_MAX                      0x2ff
>

Hopefully that makes things more clear. This patch helps users map
common (media/htpc/stb) remote control buttons directly to their real
functions as opposed to mapping them to some random unrelated & unused
event, which can be both confusing and problematic on systems where
both remote controls and say bluetooth keyboards are used.

Best regards,
Derek
