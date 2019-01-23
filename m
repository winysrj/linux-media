Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F50C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 07:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7658420870
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 07:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QH8YDz8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfAWHvH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:51:07 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36179 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfAWHvH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 02:51:07 -0500
Received: by mail-lj1-f194.google.com with SMTP id g11-v6so1054861ljk.3;
        Tue, 22 Jan 2019 23:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jxhl8/on84+pWUfKAgh44K3S0SdqzAT9p1KL2F5WKAg=;
        b=QH8YDz8T58iIXqwjg3jVjCkISrasXJaK3q7yZFPfn/atXKL3MZTbJWprSlZobX3Whm
         5I7YaTiEjE0P+/ocDRtDN+YHcYQmUS0sG2zNKz370EWQ0elwEqdrrhoUS48/0J4eFZdw
         6KmubvukbXhzKUjUFicfk6MwAsMZWkR9IHi+naudEpK+wccS8ubOJ5ahOMNxK3vFm4MG
         /QWpCg878dhpkE3l8W96uuyF62jilVW5tdRuGNCl6cK4Wy/VPwA6IAg5IyU0dHeNeHt/
         xAWzcHRCEEE5UgE4qE3Zz0Dol+S16or2DaKaAlG+1z0Hu+DqRVyrvHeoEheY5W0Eluki
         Bz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jxhl8/on84+pWUfKAgh44K3S0SdqzAT9p1KL2F5WKAg=;
        b=SEBQSBrtLfgKA+mXDY8pIb1zwIwsvYVkWBDnAL0prMO55qOIcsz5V9m8CmlQJIM7/d
         s4PMDNFq0GV8UJttJcG52uHRngXRnuqoDdsnBHYn0QiaWx59a0iXnbkoHfUiGwoHA0RS
         Ic0ULPlSnJ+cjhvbFaXWYoUa8Te3DNEuEafzXJG2B3u+U5DX3wwZPyESwy5oWbYovD4+
         poMveX5R/V1nM61szynaRrAitPTwaO7Fmr7QCh4YNL4mCFimVqR9qSuRWlBjxh8PMBIo
         lPBCxGJHxs7vuMysqZI76+2cCQ4q3k1JZ70J0mzBrTUWMnglzas+/fwrbUjvjESVNwXU
         nbvA==
X-Gm-Message-State: AJcUukeQ8Gibrxt6+XyOTWST8qA5Nz9kF5xfj7OASKhumPqFugV67kIZ
        U6ShIS0GsACXexS8OcPM7AkbDffBgZTjzpcab9o=
X-Google-Smtp-Source: ALg8bN5b/qhdEFjyW8pcQnPdQOt99ncoL1AwzTyajmiSxxInHajneoFCGTZk21Z2rv3mOugmDvkCFdoaFFwmH3qM+5Q=
X-Received: by 2002:a2e:9655:: with SMTP id z21-v6mr1079372ljh.136.1548229864156;
 Tue, 22 Jan 2019 23:51:04 -0800 (PST)
MIME-Version: 1.0
References: <20181103145532.9323-1-user.vdr@gmail.com> <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
 <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com> <20190119085252.GA187380@dtor-ws>
In-Reply-To: <20190119085252.GA187380@dtor-ws>
From:   VDR User <user.vdr@gmail.com>
Date:   Tue, 22 Jan 2019 23:50:50 -0800
Message-ID: <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote buttons
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Bastien Nocera <hadess@hadess.net>, linux-input@vger.kernel.org,
        Sean Young <sean@mess.org>, mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Dmitry, thanks for replying. Notes follow..

> > > > +/* Remote control buttons found across provider & universal remotes */
> > > > +#define KEY_LIVE_TV                  0x2e8   /* Jump to live tv viewing */
> > >
> > > KEY_TV?
> >
> > KEY_TV selects TV as a *input source* the same as KEY_VCR, KEY_SAT,
> > KEY_CD, etc. whereas KEY_LIVE_TV jumps directly to live tv as opposed
> > to local/networked media playback, dvr playback, etc.
>
> I do not quite grasp the distinction. KEY_TV to select and play
> broadcast TV, KEY_TV2 to switch TV input to cable.

Another example is when you have a remote that controls multiple
devices, KEY_TV would select the TV itself and become the target for
the remote until a different source is selected. This happens without
any change to the playback source. KEY_LIVE_TV would jumps directly to
live tv playback and doesn't touch devices at all.

> > > > +#define KEY_OPTIONS                  0x2e9   /* Jump to options */
> > >
> > > KEY_OPTION?
> >
> > Software vs. media playback options.
>
> This seems application control key. Do you really need both KEY_OPTION
> and KEY_OPTIONS? What is the difference?

Another example for this is device vs. application options.

> > > > +#define KEY_INTERACTIVE                      0x2ea   /* Jump to interactive system/menu/item */
>
> How is this different from KEY_MENU?

The first thing to mention is that traditional broadcast tv and the
internet have been converging so now you have tv with two-way
communication. Interactive tv can be anything from a traditional
broadcast that you can submit ratings for, real time comments, etc.
KEY_INTERACTIVE is specific to when you're interacting or engaging the
content. Rather than having the users inconveniently navigate through
a menu system, providers often have a dedicated button that jumps
directly to the interactive features.

> > > > +#define KEY_MIC_INPUT                        0x2eb   /* Trigger MIC input/listen mode */
> > >
> > > KEY_MICMUTE?
> >
> > This button doesn't mute the mic, in fact it does the opposite. The
> > mic is off until you press this button, thus triggering MIC
> > input/listen mode and allowing the user to speak his commands. It
> > automatically shuts off after X seconds of silence.
>
> KEY_VOICECOMMAND then.

Somehow I missed KEY_VOICECOMMAND when looking over the list for
suitable existing defines. With KEY_VOICECOMMAND, KEY_MIC_INPUT is not
needed.

> > KEY_SWITCHVIDEOMODE is used for "Cycle between available video outputs
> > (Monitor/LCD/TV-out/etc) ". This is poorly labeled in my opinion and
> > should've been called KEY_SWITCHVIDEOOUTPUT or something similar.
> > "Video mode" typically refers to something entirely different - how
> > video is presented on the display, not what physical display you're
> > using.
>
> It normally controls not only what devices are used for output, but
> switches between mirror/extend display modes.

That actually muddies the waters further then. It makes sense to
couple toggling single/multiple output devices with output device
selection, but neither of those things have to do with the video
display modes. These are two distinct things; the physical device(s)
that act simply as a means to display video, and display modes that
refer to how the video frames are drawn - what they actually look
like.

> > KEY_SCREEN_INPUT is used to bring up things like an on-screen
> > keyboard or other on-onscreen user input method.
>
> We already have KEY_ONSCREEN_KEYBOARD.
>
> >
> > > > +#define KEY_SYSTEM_MENU                      0x2ed   /* Open systems menu/display */
> > >
> > > KEY_MENU?
> >
> > Systems menus as pertains to DVB. KEY_MENU is generic and having only
> > one `menu` option is problematic when you have different types of
> > menus which aren't accessible from each other.
>
> We have KEY_MENU/KEY_CONTEXT_MENU/KEY_ROOT_MENU/KEY_MEDIA_TOP_MENU.
> Are you sure we need another one?

There are multiple MENU keys I assume for clarity purposes and to give
some kind of relation between the key definition and the action/event
that occurs when you use it. I would say it's more a matter of
convenience rather that need, similar to KEY_ROOT_MENU &
KEY_MEDIA_TOP_MENU; It's not a necessity that these two exist, but
they do out of convenience. You could still make things work if one of
them vanished.

> > > > +#define KEY_SERVICES                 0x2ee   /* Access services */
> > > > +#define KEY_DISPLAY_FORMAT           0x2ef   /* Cycle display formats */
> > >
> > > KEY_CONTEXT_MENU?
> >
> > KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle through
> > how video is displayed on-screen to the user; full, zoomed,
> > letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for something
> > like bringing up a playback menu where you'd set things like
> > upscaling, deinterlacing, audio mixdown/mixup, etc.
>
> KEY_ASPECT_RATIO (formerly KEY_SCREEN).

Physical displays have a single set aspect ratio (W/H). Images have
their own aspect ratios. When the AR of the video to be display and
the display itself are mismatched, you have to do something
(letterbox, pillarbox, windowbox) to the video to maintain the correct
video aspect ratio. You can't change the displays AR, and you aren't
changing the videos AR so using KEY_ASPECT_RATIO makes no sense. AR
isn't being touched/altered/manipulated, but how the video is being
displayed is. Stretching and filling to match the display AR alters
the video AR so there is makes sense, but then zooming may not. So,
since "aspect ratio" kind of makes sense in a couple cases, and makes
no sense in the rest, the more suitable KEY_DISPLAY_FORMAT is my
suggestion.

> > > > +#define KEY_PIP                              0x2f0   /* Toggle Picture-in-Picture on/off */
> > > > +#define KEY_PIP_SWAP                 0x2f1   /* Swap contents between main view and PIP window */
> > > > +#define KEY_PIP_POSITION             0x2f2   /* Cycle PIP window position */
> > > > +
> > > >  /* We avoid low common keys in module aliases so they don't get huge. */
> > > >  #define KEY_MIN_INTERESTING  KEY_MUTE
> > > >  #define KEY_MAX                      0x2ff
> > >
> >
> > Hopefully that makes things more clear. This patch helps users map
> > common (media/htpc/stb) remote control buttons directly to their real
> > functions as opposed to mapping them to some random unrelated & unused
> > event, which can be both confusing and problematic on systems where
> > both remote controls and say bluetooth keyboards are used.
>
> It would be great if you provided references to HID Usage Tables for the
> new keycodes you are adding, which should help further clarify the
> meaning of keycode. For example, even with the comment, it is not clear
> what "Access services" means.

My apologies for not including HID Usage Table references. I didn't
know to include it and not really familiar with the tables. This stuff
applies to common but specific setups/usage and it's important to
remember not everyone may be familiar with it. I'll look into it in
the morning and hopefully it will provide easier clarity in future
posts. Thanks again for your reply & feedback!

Best regards,
Derek
