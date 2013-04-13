Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35102 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3DMQyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 12:54:11 -0400
Received: by mail-qc0-f178.google.com with SMTP id d10so1612196qca.23
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 09:54:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5169860B.80609@iki.fi>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
	<51695A7B.4010206@iki.fi>
	<20130413112517.40833d48@redhat.com>
	<51697A29.5030307@googlemail.com>
	<CAGoCfiwO+98ZkSt-mY6U3nnfge43xy+1WLEv=3wUf6SaDEgACQ@mail.gmail.com>
	<5169860B.80609@iki.fi>
Date: Sat, 13 Apr 2013 12:54:10 -0400
Message-ID: <CAGoCfixjnGapy3hdo-7AxQJ4osOHa5pp5XGZT7a_qb4vEu8v2g@mail.gmail.com>
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 13, 2013 at 12:21 PM, Antti Palosaari <crope@iki.fi> wrote:
> Existing userspace sysfs interface is clearly debug interface. You will need
> root privileges to mount it and IIRC it was not even compiled by default
> (needs Kconfig debug option?).

You would like to think that.  Tell Mauro then, since he wanted to
rely on sysfs to associate V4L2 video devices with ALSA devices
(rather than just adding a simple call to the V4L2 API).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
