Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36766 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934622AbcHJTYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 15:24:15 -0400
Received: by mail-wm0-f47.google.com with SMTP id q128so112571855wma.1
        for <linux-media@vger.kernel.org>; Wed, 10 Aug 2016 12:24:14 -0700 (PDT)
MIME-Version: 1.0
From: Dawood Alnajjar <dawood.alnajjar@idea-ip.com>
Date: Wed, 10 Aug 2016 16:23:53 -0300
Message-ID: <CAF_HBRNZXBTHof=96ncHfdQbe2O2EDTS-Z3vXwqeWDuTJvsrKA@mail.gmail.com>
Subject: More than one V4L-DVB driver on the same machine
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have a question related to V4L-DVB drivers. Following the
Building/Compiling the Latest V4L-DVB Source Code, there are 3 ways to
compile. I am curious about the last approach (More "Manually
Intensive" Approach). It allows me to choose the components that I
wish to build and install. Some of these components (i.e.
"CONFIG_MEDIA_ATTACH") are used in macros that define a function in
one shape if defined, and a function in another if not defined (i.e.
dvb_attach, dvb_detach) in the resulting module (i.e. dvb_core.ko)
that will be loaded by my DVB driver. What happens if I have two
drivers on the same machine, one that needs dvb_core.ko with
CONFIG_MEDIA_ATTACH defined and another that needs dvb_core.ko with
CONFIG_MEDIA_ATTACH undefined, how should this be handled?

Thanks!
Daud
