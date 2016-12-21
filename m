Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:60002
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934207AbcLUOfp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 09:35:45 -0500
Date: Wed, 21 Dec 2016 12:35:38 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 0/6] Fix tvp5150 regression with em28xx
Message-ID: <20161221123538.52b61900@vento.lan>
In-Reply-To: <CAGoCfiy-v-e-GTekk6PiuB8awoavxDqNodBr-HSXrLVV8EDd-w@mail.gmail.com>
References: <1481284039-7960-1-git-send-email-laurent.pinchart@ideasonboard.com>
        <20161212075124.4e1ba840@vento.lan>
        <618f2d04-e17e-54a1-5540-b897155d7318@osg.samsung.com>
        <2038446.MEtJKT2hJE@avalon>
        <20161221084136.0438edc3@vento.lan>
        <CAGoCfiy-v-e-GTekk6PiuB8awoavxDqNodBr-HSXrLVV8EDd-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Dec 2016 09:11:36 -0500
Hi Devin,

Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hi Mauro,
> 
> > With that, I completed the tests on HVR-950. My tests covered:
> > - S-Video, Composite, TV
> > - 480i and 480p
> > - Closed Captions (with HVR-350 - it seems that MediaMVP doesn't
> >   produce NTSC CC).  
> 
> FYI:  the MediaMVP HD can be configured to output NTSC CC over VBI.
> If you want that functionality, I can dig out the script.  In fact
> I've got an alternate GUI which just plays a clip on boot and lets you
> select all the different resolutions/framerates available for
> composte/component/HDMI (for both PAL and NTSC) just by hitting
> buttons on the remote.  If you're interested, let me know and I'll dig
> it up.  It's a great tool to have, especially when doing work with
> HDMI where there are many more possible combinations to choose from.

Yeah, both things are interesting! My plan is to use MediaMVP as a
test device for analog TV, as it provides a way better output than
HVR-350 and it is easier to use.


Thanks,
Mauro
