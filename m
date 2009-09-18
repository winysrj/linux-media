Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:50774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbZIREqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 00:46:47 -0400
Received: by fg-out-1718.google.com with SMTP id 22so388695fge.1
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2009 21:46:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 00:40:34 -0400
Message-ID: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
Subject: Media Controller initial support for ALSA devices
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

If you can find a few minutes, please take a look at the following
tree, where I added initial support for including the ALSA devices in
the MC enumeration.  I also did a bit of cleanup on your example tool,
properly showing the fields associated with the given node type and
subtype (before it was always showing fields for the V4L subtype).

http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/

I've implemented it for em28xx as a prototype, and will probably see
how the code looks when calling it from au0828 and cx88 as well (to
judge the quality of the abstraction).

Comments welcome, of course...

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
