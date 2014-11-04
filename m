Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46531 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751324AbaKDXc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Nov 2014 18:32:57 -0500
Message-ID: <54596226.8040403@iki.fi>
Date: Wed, 05 Nov 2014 01:32:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Paulo Assis <pj.assis@gmail.com>
CC: =?UTF-8?Q?R=c3=a9mi_Denis-Courmont?= <remi@remlab.net>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <20141102225704.GM3136@valkosipuli.retiisi.org.uk> <CANOLnONAsh-M7WvRFOhLo-obkS20ffurr9tD5b==yyHCwVRXoQ@mail.gmail.com> <20141104115839.GN3136@valkosipuli.retiisi.org.uk> <fbcc6c6b4b3bb0d049a6d1871d8a79df@roundcube.remlab.net> <CAPueXH4Obd4F99w1g2ehgWbrfukrAhQ+=3TfRoNRuJJTAp70YA@mail.gmail.com> <20141104153650.GO3136@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141104153650.GO3136@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> yavta does, for example, print both the monotonic timestamp from the buffer
> and the time when the buffer has been dequeued:
> 
> <URL:http://git.ideasonboard.org/yavta.git>
> 
> 	$ yavta -c /dev/video0
> 
> should do it. The first timestamp is the buffer timestamp, and the latter is
> the one is taken when the buffer is dequeued (by yavta).

Removing the uvcvideo module and loading it again with trace=4096 before
capturing, and then kernel log would provide more useful information.

-- 
Sakari Ailus
sakari.ailus@iki.fi
