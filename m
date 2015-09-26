Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34177 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbbIZQQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2015 12:16:09 -0400
Received: by iofb144 with SMTP id b144so138962881iof.1
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2015 09:16:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMxVRxD7+uf-Lb8V2Eck1qM0boA3WGvQAPvHYL2Q4hU0erQ=gw@mail.gmail.com>
References: <CAM_ZknWDkGPSAQmH0cKo1DyDMepF=pOUBBJ+kvRDz5dS6Bq-+Q@mail.gmail.com>
	<CAMxVRxD7+uf-Lb8V2Eck1qM0boA3WGvQAPvHYL2Q4hU0erQ=gw@mail.gmail.com>
Date: Sat, 26 Sep 2015 19:16:08 +0300
Message-ID: <CAM_ZknVRnunch-8qECNT04x++3chhOS_8QWwrXPDk0wxF39ULQ@mail.gmail.com>
Subject: Re: [x264-devel] Help to debug h264 headers (or video) generation in
 kernel driver
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Mailing list for x264 developers <x264-devel@videolan.org>
Cc: "kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	FFmpeg development discussions and patches
	<ffmpeg-devel@ffmpeg.org>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 26, 2015 at 10:44 AM, Max Lapshin <max.lapshin@gmail.com> wrote:
> Do you get some packets from this device or it is a bytestream?

Oh hi a linux.org.ru buddy :)
I get headerless binary data portions of known length, one portion for
each encoded video frame. NAL headers generation is done on driver
level in reference software, and I have no choice but to follow same
approach.
You can check most of the info about this project from my earlier
request for help: https://lkml.org/lkml/2015/6/2/761

-- 
Bluecherry developer.
