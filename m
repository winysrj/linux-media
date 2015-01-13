Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:61778 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbAMEoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 23:44:24 -0500
Received: by mail-qg0-f53.google.com with SMTP id l89so655201qgf.12
        for <linux-media@vger.kernel.org>; Mon, 12 Jan 2015 20:44:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <515f84cc1e6e33f647610f1bda154127944e6b52.1421115389.git.shuahkh@osg.samsung.com>
References: <cover.1421115389.git.shuahkh@osg.samsung.com>
	<515f84cc1e6e33f647610f1bda154127944e6b52.1421115389.git.shuahkh@osg.samsung.com>
Date: Mon, 12 Jan 2015 23:44:23 -0500
Message-ID: <CAGoCfixdyOJoyUQfMWzM2KHjMGJE5pRS8C0+rR1nDCir7jTpwQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] media: au0828 remove video and vbi buffer timeout work-around
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tim Mester <ttmesterr@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Mon, Jan 12, 2015 at 9:56 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
> au0828 does video and vbi buffer timeout handling to prevent
> applications such as tvtime from hanging by ensuring that the
> video frames continue to be delivered even when the ITU-656
> input isn't receiving any data. This work-around is complex
> as it introduces set and clear timer code paths in start/stop
> streaming, and close interfaces. However, tvtime will hang
> without the following tvtime change:

I'm confused.  When we last debated whether this patch would be
accepted, the last message from Mauro said the following:

> That means that we'll need to keep holding such timeout code for
> years, until all distros update to a new tvtime, of course assuming
> that this is the only one application with such issue.

In other words, the timeout code has to stay in there since otherwise
it will cause ABI breakage.  It's great that Hans has submitted a
patch to improve tvtime, and over the next couple of years that patch
might actually start to appear in distributions.  That unfortunately
doesn't change the fact that everybody who updates their kernel (or
has it updated for them as part of their distribution) will go from
"works fine" to "completely broken".

The driver was working before the VB2 conversion, so if there is now
instability then it's likely that some bug was introduced during the
conversion to VB2.  Simply ripping out the timeout code seems like the
wrong approach to addressing a regression likely caused by your own
VB2 conversion patch.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
