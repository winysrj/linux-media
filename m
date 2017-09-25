Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:50916 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935560AbdIYQpB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 12:45:01 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v5 2/2] media: rc: Add driver for tango HW IR decoder
References: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
        <e3d91250-e6bd-bb8c-5497-689c351ac55f@free.fr>
        <yw1xzi9ieuqe.fsf@mansr.com>
        <893874ee-a6e0-e4be-5b4f-a49e60197e92@free.fr>
Date: Mon, 25 Sep 2017 17:45:00 +0100
In-Reply-To: <893874ee-a6e0-e4be-5b4f-a49e60197e92@free.fr> (Marc Gonzalez's
        message of "Mon, 25 Sep 2017 18:07:14 +0200")
Message-ID: <yw1xr2uuenhv.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> * Delete two writes clearing interrupts in probe (cleared is reset value)

Noooooo.  You can't know what state the hardware is in when this code
runs.  Drivers should *always* fully initialise the hardware to a known
state.  It is especially important to clear any pending interrupts since
otherwise they'll fire the moment the irq is unmasked and can cause all
sorts of mayhem.

-- 
Måns Rullgård
