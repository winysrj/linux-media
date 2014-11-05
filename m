Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37759 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaKEKOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 05:14:07 -0500
Received: by mail-ig0-f182.google.com with SMTP id hn18so1077180igb.9
        for <linux-media@vger.kernel.org>; Wed, 05 Nov 2014 02:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54596226.8040403@iki.fi>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <20141102225704.GM3136@valkosipuli.retiisi.org.uk> <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
 <20141104115839.GN3136@valkosipuli.retiisi.org.uk> <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
 <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com>
 <20141104153650.GO3136@valkosipuli.retiisi.org.uk> <54596226.8040403@iki.fi>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 5 Nov 2014 10:13:45 +0000
Message-ID: <CAPueXH5kQG7zm3W-ghcVoq-rrqyE3rcYnfmGO+bPR=S91L3qpw@mail.gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2014-11-04 23:32 GMT+00:00 Sakari Ailus <sakari.ailus@iki.fi>:
> Sakari Ailus wrote:
>> yavta does, for example, print both the monotonic timestamp from the buffer
>> and the time when the buffer has been dequeued:
>>
>> <URL:http://git.ideasonboard.org/yavta.git>
>>
>>       $ yavta -c /dev/video0
>>
>> should do it. The first timestamp is the buffer timestamp, and the latter is
>> the one is taken when the buffer is dequeued (by yavta).

I've done exaclty this with guvcview, and uvcvideo timestamps are
completly unreliable, in some devices they may have just a bit of
jitter, but in others, values go back and forth in time, making them
totally unusable.
Honestly I wouldn't trust device firmware to provide correct
timestamps, or at least I would have the driver perform a couple of
tests to make sure these are at least reasonable: within an expected
interval (maybe comparing it to a reference monotonic clock) or at the
very least making sure the current frame timestamp is not lower than
the previous one.

Regards,
Paulo

>
> Removing the uvcvideo module and loading it again with trace=4096 before
> capturing, and then kernel log would provide more useful information.
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
