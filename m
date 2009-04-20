Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:36574 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZDTQvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 12:51:25 -0400
Received: by bwz7 with SMTP id 7so1313313bwz.37
        for <linux-media@vger.kernel.org>; Mon, 20 Apr 2009 09:51:23 -0700 (PDT)
Message-ID: <49ECA808.50309@googlemail.com>
Date: Mon, 20 Apr 2009 18:51:20 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
MIME-Version: 1.0
To: Kjeld Flarup <kjeld.flarup@liberalismen.dk>
CC: linux-media@vger.kernel.org
Subject: Re: dvbd
References: <49EA7EFA.4030701@liberalismen.dk> <49EAF472.9010702@googlemail.com> <49EBA5C6.5060808@liberalismen.dk>
In-Reply-To: <49EBA5C6.5060808@liberalismen.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kjeld,

> But one thing which I would like to do is to use dvbd together with VLC,
> because VLC can handle the DVB subtitles used in Denmark. But VLC does
> not seem to like connecting to the dvbd socket. If anyone have success
> with that, I sure would like to know.

you can access a particular stream with dvbcat and pipe it into a media
player (xine works fine). I usually do it differently, though: write the
stream to disk and let the player read the file. That way you also get
time shifting (which doesn't work when you use a pipe). And if you use a
low priority for live viewing, scheduled recordings will take precedence.

Writing a plug-in based on dvbcat would be another option. That might
also allow you to switch channels on the fly (if the other channel is
accessible, that is - one of the reasons why I use multiple receivers).

> Also at some time soon I would need to stream some DVB signals. But I do
> not like the way this is done by most tools, they seems to be using up
> CPU cycles even if nobody is listening.

If they use UDP multicast (the standard way of media streaming), they
never know who's listening.

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
