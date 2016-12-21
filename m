Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33898 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbcLUOLh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 09:11:37 -0500
Received: by mail-oi0-f47.google.com with SMTP id 3so28476049oih.1
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2016 06:11:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161221084136.0438edc3@vento.lan>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20161212075124.4e1ba840@vento.lan> <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
 <2038446.MEtJKT2hJE@avalon> <20161221084136.0438edc3@vento.lan>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 21 Dec 2016 09:11:36 -0500
Message-ID: <CAGoCfiy-v-e-GTekk6PiuB8awoavxDqNodBr-HSXrLVV8EDd-w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> With that, I completed the tests on HVR-950. My tests covered:
> - S-Video, Composite, TV
> - 480i and 480p
> - Closed Captions (with HVR-350 - it seems that MediaMVP doesn't
>   produce NTSC CC).

FYI:  the MediaMVP HD can be configured to output NTSC CC over VBI.
If you want that functionality, I can dig out the script.  In fact
I've got an alternate GUI which just plays a clip on boot and lets you
select all the different resolutions/framerates available for
composte/component/HDMI (for both PAL and NTSC) just by hitting
buttons on the remote.  If you're interested, let me know and I'll dig
it up.  It's a great tool to have, especially when doing work with
HDMI where there are many more possible combinations to choose from.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
