Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:56913 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaK2Ck5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 21:40:57 -0500
Received: by mail-qa0-f51.google.com with SMTP id k15so5033691qaq.38
        for <linux-media@vger.kernel.org>; Fri, 28 Nov 2014 18:40:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5478D31E.5000402@cogweb.net>
References: <5478D31E.5000402@cogweb.net>
Date: Fri, 28 Nov 2014 21:40:56 -0500
Message-ID: <CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
Subject: Re: ISDB caption support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

ISDB-T subtitles are done in a similar manner to DVB-T subtitles -
there is a PID in the stream which contains the subtitle data, which
needs to be decoded by the application (just as you would handle DVB-T
subtitles or ATSC closed captions).  It's entirely an application
level function, having nothing to do with the driver layer.

In short, this has nothing to do with DVBv5, as that is all about how
the tuner is controlled, not what gets done with the resulting MPEG
stream.  You would need to talk to whoever is responsible for the
application you are working with (whether that be VLC, mplayer,
ccextractor, etc).

Cheers,

Devin

On Fri, Nov 28, 2014 at 2:55 PM, David Liontooth <lionteeth@cogweb.net> wrote:
>
> What is the status of ISDB-Tb / ISDB-T International / ISDB Japanese closed
> captioning support?
>
> If anyone is working on this, please get in touch -- we're particularly
> interested in getting Brazilian SBTVD working.
>
> I see Mauro has been working on DVBv5 support, but does this include
> captioning?
>
> Cheers,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
