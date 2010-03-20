Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34304 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0CTQOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 12:14:14 -0400
Received: by bwz1 with SMTP id 1so778294bwz.21
        for <linux-media@vger.kernel.org>; Sat, 20 Mar 2010 09:14:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201003201514.57420.hverkuil@xs4all.nl>
References: <201003201021.05426.hverkuil@xs4all.nl>
	 <201003201337.03741.hverkuil@xs4all.nl>
	 <1269093104.2909.13.camel@brian.bconsult.de>
	 <201003201514.57420.hverkuil@xs4all.nl>
Date: Sat, 20 Mar 2010 12:14:12 -0400
Message-ID: <829197381003200914u170d5f3ra6f6463338f41b45@mail.gmail.com>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert
	apps.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Chicken Shack <chicken.shack@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 20, 2010 at 10:14 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Of course, the best solution is to convert the V4L1 apps to using V4L2.

On that topic, if I wanted to ensure that an application was not using
any V4L1 functionality, is there any easy way to do that?  For
example, can I just remove the #include "videodev.h" and fix whatever
breaks?

Right now a problem is that there could easily be situations where an
app uses V4L1 functionality without my knowledge, and it would be good
if there were an easy way to audit the app and make sure it is doing
V4L2 entirely (in fact, I had this issue in a few places with tvtime).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
