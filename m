Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35686 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391078AbeHPNeo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:34:44 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so3896589wmc.0
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2018 03:37:05 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] media: soc_camera: ov9640: move ov9640 out of
 soc_camera
To: jacopo mondi <jacopo@jmondi.org>
Cc: marek.vasut@gmail.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <dc99bd37408f42a342b1b878d01c16f8c25b758b.1534339750.git.petrcvekcz@gmail.com>
 <de297d12-e5eb-9e68-978c-3417cdfc0c05@gmail.com>
 <20180816102323.GC19047@w540>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <6deee862-7da1-077d-a88c-dbc6f5d52ea3@gmail.com>
Date: Thu, 16 Aug 2018 12:38:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180816102323.GC19047@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: cs
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dne 16.8.2018 v 12:23 jacopo mondi napsal(a):
> Hi Petr,
> 
> On Wed, Aug 15, 2018 at 03:35:39PM +0200, Petr Cvek wrote:
>> BTW from the v1 discussion:
>>
>> Dne 10.8.2018 v 09:32 jacopo mondi napsal(a):
>>> When I've been recently doing the same for ov772x and other sensor
>>> driver I've been suggested to first copy the driver into
>>> drivers/media/i2c/ and leave the original soc_camera one there, so
>>> they can be bulk removed or moved to staging. I'll let Hans confirm
>>> this, as he's about to take care of this process.
>>
>> I would rather used git mv for preserve the git history, but if a simple
>> copy is fine then I'm fine too ;-).
> 
> Well, 'git mv' removes the soc_camera version of this driver, and my
> understanding was that when those driver will be obsoleted they will
> be bulk removed or moved to staging by Hans.
> 

Nevermind I've probably used the wrong command :-/

Petr
