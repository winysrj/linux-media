Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f212.google.com ([209.85.218.212]:40680 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0CQPnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 11:43:31 -0400
Received: by bwz4 with SMTP id 4so1190791bwz.39
        for <linux-media@vger.kernel.org>; Wed, 17 Mar 2010 08:43:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100317145900.GA7875@localhost.localdomain>
References: <20100317145900.GA7875@localhost.localdomain>
Date: Wed, 17 Mar 2010 11:43:29 -0400
Message-ID: <829197381003170843u73743ccand32e7d0d2e6d3ca6@mail.gmail.com>
Subject: Re: Problem with em28xx card, PAL and teletext
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Eugeniy Meshcheryakov <eugen@debian.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 17, 2010 at 10:59 AM, Eugeniy Meshcheryakov
<eugen@debian.org> wrote:
> Hello,
>
> I have a Pinnacle Hybrid Pro Stick (in kernel source "Pinnacle Hybrid
> Pro (2)", driver em28xx). Several kernel releases ago it started to have
> problem displaying analog tv correctly. The picture is shifted and
> there is green line on the bottom (see http://people.debian.org/~eugen/tv.png).
> Also part of the picture is shifted from the right edge to the left
> (several columns). TV norm is PAL-BG. I noticed that teletext is also
> not correct. I can see some full words, but text itself is not readable.
> Picture is correct if i load em28xx with disable_vbi=1.
>
> Please CC me in replies.
>
> Regards,
> Eugeniy Meshcheryakov

The green line is because in order to add the VBI support I had to
crop a few lines off of the active video area at the top.  I've
actually made some additional improvements in this area on a
development tree which I am preparing to submit upstream.  Most
applications such as tvtime crop the area in question (around 1.5% on
all edges) to behave comparably to a television, which results in
users not seeing the top and bottom couple of lines.

The teletext should be working (it was tested against a live source).
Which application are you using?  It's been my experience that the
application support for VBI could be described as "crappy at best", so
it wouldn't surprise me to find that there is an application level
issue.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
