Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55942
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752945AbcHXOwq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 10:52:46 -0400
Date: Wed, 24 Aug 2016 11:52:41 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Chris Mayo <aklhfex@gmail.com>
Subject: Re: [PATCH 2/2] v4l-utils: fixed dvbv5 vdr format
Message-ID: <20160824115241.7e2c90ca@vento.lan>
In-Reply-To: <20160824114927.3c6ab0d6@vento.lan>
References: <1470822739-29519-1-git-send-email-markus.heiser@darmarit.de>
        <1470822739-29519-3-git-send-email-markus.heiser@darmarit.de>
        <20160824114927.3c6ab0d6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Aug 2016 11:49:27 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Hi Markus,
> 
> Em Wed, 10 Aug 2016 11:52:19 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
> > From: Markus Heiser <markus.heiser@darmarIT.de>
> > 
> > From: Heiser, Markus <markus.heiser@darmarIT.de>
> > 
> > The vdr format was broken, I got '(null)' entries
> > 
> > HD:11494:S1HC23I0M5N1O35:S:(null):22000:5101:5102,5103,5106,5108:0:0:10301:0:0:0:
> > 0-:1----:2--------------:3:4-----:
> > 
> > refering to the VDR Wikis ...
> > 
> > * LinuxTV: http://www.linuxtv.org/vdrwiki/index.php/Syntax_of_channels.conf
> > * german comunity Wiki: http://www.vdr-wiki.de/wiki/index.php/Channels.conf#Parameter_ab_VDR-1.7.4
> > 
> > There is no field at position 4 / in between "Source" and "SRate" which
> > might have a value. I suppose the '(null):' is the result of pointing
> > to *nothing*.
> > 
> > An other mistake is the ending colon (":") at the line. It is not
> > explicit specified but adding an collon to the end of an channel entry
> > will prevent players (like mpv or mplayer) from parsing the line (they
> > will ignore these lines).
> > 
> > At least: generating a channel list with
> > 
> >   dvbv5-scan --output-format=vdr ...
> > 
> > will result in the same defective channel entry, containing "(null):"
> > and the leading collon ":".  
> 
> Sorry for taking too long to handle that. I usually stop handling
> patches one week before the merge window, returning to merge only
> after -rc1. This time, it took a little more time, due to the Sphinx
> changes, as I was needing some patches to be merged upstream, in order
> to change my handling scripts to work with the new way.
> 
> Anyway, with regards to this patch, not sure if you saw, but
> Chris Mayo sent us a different fix for it:
> 
> 	https://patchwork.linuxtv.org/patch/35803/
> 
> With is meant to support VDR format as used on version 2.2. Not sure
> if this format is backward-compatible with versions 1.x, but usually
> VDR just adds new parameters to the lines.
> 
> So, I'm inclined to merge Chris patch instead of yours.
> 
> So, could you please test if his patch does what's needed?

PS.: If the formats for v 1.x are not compatible with the ones for
v2.x, then the best would be to change the code to add a new format
for vdr v2.x, while keep supporting vdr v1.x.



Thanks,
Mauro
