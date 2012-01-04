Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2ADXPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 18:15:11 -0500
Message-ID: <4F04DD7A.8000105@redhat.com>
Date: Wed, 04 Jan 2012 21:15:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Fix Leadtek DTV2000H radio tuner
References: <CAEN_-SARAe306X5-gS7N8-_y7jP3zTRgOvUEdCE6cBh1azXOdA@mail.gmail.com>
In-Reply-To: <CAEN_-SARAe306X5-gS7N8-_y7jP3zTRgOvUEdCE6cBh1azXOdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16-12-2011 22:39, Miroslav Slugeň wrote:
> Leadtek DTV2000H J revision has FMD1216MEX, no older FMD1216ME. But
> there is still another unknown issue with radio, because some stations
> are just not working or are very noisy.

Miroslav,

Please sign your patches with:
	Signed-off-by: your name <your@email>

As described at:

http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

For the patches you've already send, you should reply to each of them with
your Signed-off-by. Patchwork will catch your signature.

Thanks!
Mauro
