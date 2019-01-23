Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC895C282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A69E421019
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfAWKSW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:18:22 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:35921 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfAWKSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:18:22 -0500
Received: from classic (mon69-7-83-155-44-161.fbx.proxad.net [83.155.44.161])
        (Authenticated sender: hadess@hadess.net)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 96B6C240015;
        Wed, 23 Jan 2019 10:18:18 +0000 (UTC)
Message-ID: <9e3eccabfafe830f7d30249a18e9d076e1868e4c.camel@hadess.net>
Subject: Re: [PATCH v2] Input: Add missing event codes for common IR remote
 buttons
From:   Bastien Nocera <hadess@hadess.net>
To:     VDR User <user.vdr@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, Sean Young <sean@mess.org>,
        mchehab+samsung@kernel.org,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Date:   Wed, 23 Jan 2019 11:18:17 +0100
In-Reply-To: <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
References: <20181103145532.9323-1-user.vdr@gmail.com>
         <766230a305f54a37e9d881779a0d81ec439f8bd8.camel@hadess.net>
         <CAA7C2qhCmaJJ1F8D6zz0-9Sp+OspPE2h=KYRYO7seMUrs2q=sA@mail.gmail.com>
         <20190119085252.GA187380@dtor-ws>
         <CAA7C2qiKOTKSWgmK_9ZyPC-JaBp+vW0nhoJMPJzHCmV_wsg8_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 (3.30.4-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-01-22 at 23:50 -0800, VDR User wrote:
> > > KEY_SCREEN_INPUT is used to bring up things like an on-screen
> > > keyboard or other on-onscreen user input method.
> > 
> > We already have KEY_ONSCREEN_KEYBOARD.
> > 
> > > > > +#define KEY_SYSTEM_MENU                      0x2ed   /* Open
> > > > > systems menu/display */
> > > > 
> > > > KEY_MENU?
> > > 
> > > Systems menus as pertains to DVB. KEY_MENU is generic and having
> > > only
> > > one `menu` option is problematic when you have different types of
> > > menus which aren't accessible from each other.
> > 
> > We have KEY_MENU/KEY_CONTEXT_MENU/KEY_ROOT_MENU/KEY_MEDIA_TOP_MENU.
> > Are you sure we need another one?
> 
> There are multiple MENU keys I assume for clarity purposes and to
> give
> some kind of relation between the key definition and the action/event
> that occurs when you use it. I would say it's more a matter of
> convenience rather that need, similar to KEY_ROOT_MENU &
> KEY_MEDIA_TOP_MENU; It's not a necessity that these two exist, but
> they do out of convenience. You could still make things work if one
> of
> them vanished.

Those 2 keys were added because they were present on DVD player remotes
nearly 20 years ago ("Root menu" vs. "Top Menu"), and do different
things.

Dmitry, the difference between:
#define KEY_MENU                139     /* Menu (show menu) */
and:
#define KEY_CONTEXT_MENU        0x1b6   /* GenDesc - system context
menu */
isn't super clear to me. The first one is used for contextual menu on
keyboards (the menu key added since Windows 95), does KEY_CONTEXT_MENU
do the same thing?

> > > > > +#define KEY_SERVICES                 0x2ee   /* Access
> > > > > services */
> > > > > +#define KEY_DISPLAY_FORMAT           0x2ef   /* Cycle
> > > > > display formats */
> > > > 
> > > > KEY_CONTEXT_MENU?
> > > 
> > > KEY_DISPLAY_FORMAT doesn't open any menus and is used to cycle
> > > through
> > > how video is displayed on-screen to the user; full, zoomed,
> > > letterboxed, stretched, etc. KEY_CONTEXT_MENU would be for
> > > something
> > > like bringing up a playback menu where you'd set things like
> > > upscaling, deinterlacing, audio mixdown/mixup, etc.
> > 
> > KEY_ASPECT_RATIO (formerly KEY_SCREEN).
> 
> Physical displays have a single set aspect ratio (W/H). Images have
> their own aspect ratios. When the AR of the video to be display and
> the display itself are mismatched, you have to do something
> (letterbox, pillarbox, windowbox) to the video to maintain the
> correct
> video aspect ratio. You can't change the displays AR, and you aren't
> changing the videos AR so using KEY_ASPECT_RATIO makes no sense. AR
> isn't being touched/altered/manipulated, but how the video is being
> displayed is. Stretching and filling to match the display AR alters
> the video AR so there is makes sense, but then zooming may not. So,
> since "aspect ratio" kind of makes sense in a couple cases, and makes
> no sense in the rest, the more suitable KEY_DISPLAY_FORMAT is my
> suggestion.

The "Aspect Ratio" or "Ratio" key on loads of remotes have been doing
this exact thing since the days of the first 16:9/cinema displays. I
really don't think you need a new key here.

