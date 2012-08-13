Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60784 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2HMVbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 17:31:42 -0400
Received: by ggdk6 with SMTP id k6so3756509ggd.19
        for <linux-media@vger.kernel.org>; Mon, 13 Aug 2012 14:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8ed2a79057a0cc80ba058cebd97fd69d@mail.eetvelt.be>
References: <201208131427.56961.hverkuil@xs4all.nl>
	<8ed2a79057a0cc80ba058cebd97fd69d@mail.eetvelt.be>
Date: Mon, 13 Aug 2012 17:31:41 -0400
Message-ID: <CAGoCfiwJOt8LQYyGu0G=iJ-fAMyB82Y2jyZc4TS72QHOE9ZmnQ@mail.gmail.com>
Subject: Re: RFC: V4L2 API ambiguities
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Walter Van Eetvelt <walter@van.eetvelt.be>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 13, 2012 at 4:27 PM, Walter Van Eetvelt
<walter@van.eetvelt.be> wrote:
> For me there is a an issue in the V4L specs for the support of DVB-S/C/T
> devices where the CI device is decoupled from the Tuners.
> At the moment there is no standard solution on which device drivers
> implementers and Application programmers can fall back.

DVB isn't part of the V4L spec.  There are *tons* of problems with
DVB, none of which are being discussed in this meeting (out of scope).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
