Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52143 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BFOv1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 09:51:27 -0500
Received: by mail-qc0-f179.google.com with SMTP id b40so552992qcq.10
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 06:51:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ketq5c$8dc$1@ger.gmane.org>
References: <ketngk$dit$1@ger.gmane.org>
	<ketq5c$8dc$1@ger.gmane.org>
Date: Wed, 6 Feb 2013 09:51:26 -0500
Message-ID: <CAGoCfiwevN2rtsL2Az1USfSkpUQEGij6ECVArB-Li+X8yNxJZQ@mail.gmail.com>
Subject: Re: Replacement for vloopback?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 9:42 AM, Neuer User <auslands-kv@gmx.de> wrote:
> If it is not possible to have two applications access the same video
> stream, that is pretty detrimentical to quite a lot of use cases, e.g.:
>
> a.) Use motion to detect motion and record video. At the same time view
> the camera output on the screen.
>
> b.) Stream a webcam output over the net and at the same time view it on
> the screen.

FWIW:  usually when people ask for this sort of functionality
(performing multiple functions on the same stream), they will
typically use frameworks like gstreamer, which allow for creation of
pipelines to perform the sorts of use cases you have described.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
