Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:41205 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964853AbeALSOm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 13:14:42 -0500
Received: by mail-qk0-f171.google.com with SMTP id l29so144607qkj.8
        for <linux-media@vger.kernel.org>; Fri, 12 Jan 2018 10:14:41 -0800 (PST)
Message-ID: <1515780879.3084.30.camel@ndufresne.ca>
Subject: Re: iMX6q/coda encoder failures with ffmpeg/gstreamer m2m encoders
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 12 Jan 2018 13:14:39 -0500
In-Reply-To: <d2fc4aac-209c-c4c5-d487-e6e06013d1b5@baylibre.com>
References: <8bfe88cc-28ec-fa07-5da3-614745ac125f@baylibre.com>
         <1513682278.7538.6.camel@pengutronix.de>
         <d2fc4aac-209c-c4c5-d487-e6e06013d1b5@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 19 décembre 2017 à 13:38 +0100, Neil Armstrong a écrit :
> > 
> > The coda driver does not allow S_FMT anymore, as soon as the
> > buffers are
> > allocated with REQBUFS:
> > 
> > https://bugzilla.gnome.org/show_bug.cgi?id=791338
> > 
> > regards
> > Philipp
> > 
> 
> Thanks Philipp,
> 
> It solves the gstreamer encoding.

Just to let you know that a fix, though slightly different, was merged
into master branch. Let us know if you have any further issues.

regards,
Nicolas
