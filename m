Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns207790.ip-94-23-215.eu ([94.23.215.26]:42246 "EHLO
	ns207790.ip-94-23-215.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaKDMuX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 07:50:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 04 Nov 2014 15:42:37 +0300
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	<linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
In-Reply-To: <20141104115839.GN3136@valkosipuli.retiisi.org.uk>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com>
 <20141102225704.GM3136@valkosipuli.retiisi.org.uk>
 <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com>
 <20141104115839.GN3136@valkosipuli.retiisi.org.uk>
Message-ID: <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 2014-11-04 14:58, Sakari Ailus a écrit :
>> > Have you tried with a different application to see if the problem 
>> persists?
>>
>> Tried mplayer and cheese now, and it seems they are not affected, so
>> it's an issue with vlc. I wonder why it doesn't like newer flags..
>>
>> Ohwell, sorry for the noise.
>
> I guess the newer VLC could indeed pay attention to the monotonic 
> timestamp
> flag. Remi, any idea?

VLC takes the kernel timestamp, if monotonic, since version 2.1. 
Otherwise, it generates its own inaccurate timestamp. So either that 
code is wrong, or the kernel timestamps are.

-- 
Rémi Denis-Courmont
