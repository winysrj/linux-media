Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:48826 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZIREpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 00:45:45 -0400
Received: by qw-out-2122.google.com with SMTP id 5so258503qwd.37
        for <linux-media@vger.kernel.org>; Thu, 17 Sep 2009 21:45:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 00:38:29 -0400
Message-ID: <412bdbff0909172138v26239ba3qa28c60f2b9e07a2d@mail.gmail.com>
Subject: Media Controller initial support for ALSA devices
From: Devin Heitmueller <devin.heitmueller@gmail.com>
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
subtype.

http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/

I've implemented it for em28xx as a prototype, and will probably see
how the code looks when calling it from au0828 and cx88 as well (to
judge the quality of the abstraction).

Comments welcome, of course...

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
