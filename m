Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AD3C61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 08:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86A7C2084C
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 08:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GjB9SEIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfASIw5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 03:52:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38567 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfASIw5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 03:52:57 -0500
Received: by mail-pf1-f195.google.com with SMTP id q1so7780211pfi.5;
        Sat, 19 Jan 2019 00:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BIeYaElCnc1mA9dMrR5CHyggpTLGgSjEPN1G3URQqmE=;
        b=GjB9SEIPh/FB2tjco/GkFdGfnmty5CR/2HQ8bh0pxApMSHgB+TMLvfSZn1MWNM6EzS
         LQd6/t9b6hOOn5UtCDsUQNMIr+Enq6wgbfbvMte5Ytnjfc6QD0hG2ujMd1G5ASpDlitA
         LWyFSq7W5brvC44t3rBMHHfrYGp8tJ26kPavaSzuUrlIk/8pJO1qB8r+xKux1RZmDhDI
         iOhNWXT7VAP50Jv9qACHZEsSBO+FE+QF6DdDIc+TRFdutK4fM8E8t44lr/RuLerSQ7Q8
         94CHbYJqQhGU3yW8nVYrSeZcLmQeDxPqtnhU7xzkPzf9c57t0TlqksV8eeLAUBPh68Cs
         rY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BIeYaElCnc1mA9dMrR5CHyggpTLGgSjEPN1G3URQqmE=;
        b=JAiSJVKcgaDT6snu+bBMOqOcZrsqjvSLmNZHe2p2+y1GYRWfKPY8P84MNdvx+0gI9j
         y6J+2SRmXIo05qgNW/YONa2wqimncpFunbzl6zV39QpTBBT9qx3+2pLONqHAnIm42neR
         Hy4JeMlbhy8tIyEWwtam7DPSZlRlkOnDOZcUSK07ye5gj4lnCP49ZaCQX12HX2xRIpsN
         ewuhWLZG+18tGHjQbTn7NRmbCqWgJ3i78Qqa3S64sDA4oIgeFZIPwBjcDa/BxfuJOUZw
         gdWvF5SBfig/ItVMveqA2TnKmqCN9QOI3vJImA7SjDnGGUY+Hh7I/L2WNKEH8JIBfF73
         TsRA==
X-Gm-Message-State: AJcUukcHPeBLojMfybEseVzIDmfMse7bVGWoKiZyEIvtiBKxmPPNixa0
        7AELiD2A1sbDS7h8nfVk6TQ=
X-Google-Smtp-Source: ALg8bN59fLg1bcWILzB3cYLue1THv/UmXFWtGcZQxIC2XQL86vrm1ntfxiWPhTuDwPxFbR8IgSdnhA==
X-Received: by 2002:a63:e915:: with SMTP id i21mr20542671pgh.409.1547887975337;
        Sat, 19 Jan 2019 00:52:55 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id l85sm9942355pfg.161.2019.01.19.00.52.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 19 Jan 2019 00:52:54 -0800 (PST)
Date:   Sat, 19 Jan 2019 00:52:52 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     VDR User <user.vdr@gmail.com>
Cc:     hadess@hadess.net, linux-input@vger.kernel.org,
        Sean Young <sean@mess.org>, mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote
 buttons
Message-ID: <20190119085252.GA187380@dtor-ws>
References: <20181103145532.9323-1-user.vdr@gmail.com>
 <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
 <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Derek,

On Tue, Nov 13, 2018 at 08:20:22AM -0800, VDR User wrote:
> > On Sat, 2018-11-03 at 07:55 -0700, Derek Kelly wrote:
> > > The following patch adds event codes for common buttons found on
> > > various
> > > provider and universal remote controls. They represent functions not
> > > covered by existing event codes. Once added, rc_keymaps can be
> > > updated
> > > accordingly where applicable.
> >
> > Would be great to have more than "those are used", such as knowing how
> > they are labeled, both with text and/or icons, and an explanation as to
> > why a particular existing key isn't usable.
> 
> Hi Bastien,
> 
> Text & icons may vary from remote to remote but the purpose/function
> of those buttons is basically the same. As explained, the defines in
> this patch represent functions not already addressed by other defines.
> See below for more detail. The one thing I will add that I probably
> should've mentioned is that these defines focus on media/htpc/stb. If
> you're not aware, Linux has become a common choice for these types of
> systems thanks to the popularity of software like Plex, Kodi, Mythtv,
> VDR, etc. Lastly, all these represent *common* functions in this area.
> Please keep this in mind as you read further.
> 
> > > +/* Remote control buttons found across provider & universal remotes */
> > > +#define KEY_LIVE_TV                  0x2e8   /* Jump to live tv viewing */
> >
> > KEY_TV?
> 
> KEY_TV selects TV as a *input source* the same as KEY_VCR, KEY_SAT,
> KEY_CD, etc. whereas KEY_LIVE_TV jumps directly to live tv as opposed
> to local/networked media playback, dvr playback, etc.

I do not quite grasp the distinction. KEY_TV to select and play
broadcast TV, KEY_TV2 to switch TV input to cable.

> 
> > > +#define KEY_OPTIONS                  0x2e9   /* Jump to options */
> >
> > KEY_OPTION?
> 
> Software vs. media playback options.

This seems application control key. Do you really need both KEY_OPTION
and KEY_OPTIONS? What is the difference?

> 
> > > +#define KEY_INTERACTIVE                      0x2ea   /* Jump to interactive system/menu/item */

How is this different from KEY_MENU?

> > > +#define KEY_MIC_INPUT                        0x2eb   /* Trigger MIC input/listen mode */
> >
> > KEY_MICMUTE?
> 
> This button doesn't mute the mic, in fact it does the opposite. The
> mic is off until you press this button, thus triggering MIC
> input/listen mode and allowing the user to speak his commands. It
> automatically shuts off after X seconds of silence.

KEY_VOICECOMMAND then.

> 
> > > +#define KEY_SCREEN_INPUT             0x2ec   /* Open on-screen input system */
> >
> > KEY_SWITCHVIDEOMODE?
> 
> KEY_SWITCHVIDEOMODE is used for "Cycle between available video outputs
> (Monitor/LCD/TV-out/etc) ". This is poorly labeled in my opinion and
> should've been called KEY_SWITCHVIDEOOUTPUT or something similar.
> "Video mode" typically refers to something entirely different - how
> video is presented on the display, not what physical display you're
> using.

It normally controls not only what devices are used for output, but
switches between mirror/extend display modes.

> KEY_SCREEN_INPUT is used to bring up things like an on-screen
> keyboard or other on-onscreen user input method.

We already have KEY_ONSCREEN_KEYBOARD.

> 
> > > +#define KEY_SYSTEM_MENU                      0x2ed   /* Open systems menu/display */
> >
> > KEY_MENU?
> 
> Systems menus as pertains to DVB. KEY_MENU is generic and having only
> one `menu` option is problematic when you have different types of
> menus which aren't accessible from each other.

We have KEY_MENU/KEY_CONTEXT_MENU/KEY_ROOT_MENU/KEY_MEDIA_TOP_MENU.
Are you sure we need another one?

> 
> > > +#define KEY_SERVICES                 0x2ee   /* Access services */
> > > +#define KEY_DISPLAY_FORMAT           0x2ef   /* Cycle display formats */
> >
> > KEY_CONTEXT_MENU?
> 
> KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle through
> how video is displayed on-screen to the user; full, zoomed,
> letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for something
> like bringing up a playback menu where you'd set things like
> upscaling, deinterlacing, audio mixdown/mixup, etc.

KEY_ASPECT_RATIO (formerly KEY_SCREEN).

> 
> > > +#define KEY_PIP                              0x2f0   /* Toggle Picture-in-Picture on/off */
> > > +#define KEY_PIP_SWAP                 0x2f1   /* Swap contents between main view and PIP window */
> > > +#define KEY_PIP_POSITION             0x2f2   /* Cycle PIP window position */
> > > +
> > >  /* We avoid low common keys in module aliases so they don't get huge. */
> > >  #define KEY_MIN_INTERESTING  KEY_MUTE
> > >  #define KEY_MAX                      0x2ff
> >
> 
> Hopefully that makes things more clear. This patch helps users map
> common (media/htpc/stb) remote control buttons directly to their real
> functions as opposed to mapping them to some random unrelated & unused
> event, which can be both confusing and problematic on systems where
> both remote controls and say bluetooth keyboards are used.

It would be great if you provided references to HID Usage Tables for the
new keycodes you are adding, which should help further clarify the
meaning of keycode. For example, even with the comment, it is not clear
what "Access services" means.

Thanks.

-- 
Dmitry
