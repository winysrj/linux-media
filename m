Return-path: <mchehab@pedra>
Received: from quail.cita.utoronto.ca ([128.100.76.6]:39509 "EHLO
	quail.cita.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1AON7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jan 2011 08:59:20 -0500
Received: from cita.utoronto.ca (grizzly.cita.utoronto.ca [128.100.76.62])
	by quail.cita.utoronto.ca (8.13.8/8.13.8) with ESMTP id p0FDxJ5r000737
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 08:59:19 -0500
Received: from grizzly.cita.utoronto.ca (localhost [127.0.0.1])
	by cita.utoronto.ca (8.14.4/8.14.4) with ESMTP id p0FDxIfs029949
	for <linux-media@vger.kernel.org>; Sat, 15 Jan 2011 08:59:18 -0500
Received: (from rjh@localhost)
	by grizzly.cita.utoronto.ca (8.14.4/8.14.4/Submit) id p0FDxIPm029947
	for linux-media@vger.kernel.org; Sat, 15 Jan 2011 08:59:18 -0500
Date: Sat, 15 Jan 2011 08:59:18 -0500
From: Robin Humble <robin.humble+dvb@anu.edu.au>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] dib7000m/p: struct alignment fix
Message-ID: <20110115135918.GA27329@grizzly.cita.utoronto.ca>
References: <20110112131732.GA26294@grizzly.cita.utoronto.ca>
 <4D2E1386.6050801@redhat.com>
 <alpine.LRH.2.00.1101141808260.6649@pub3.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1101141808260.6649@pub3.ifh.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Patrick,

On Fri, Jan 14, 2011 at 06:11:24PM +0100, Patrick Boettcher wrote:
>On Wed, 12 Jan 2011, Mauro Carvalho Chehab wrote:
>>Em 12-01-2011 11:17, Robin Humble escreveu:
>>>this is basically a re-post of
>>>  http://www.linuxtv.org/pipermail/linux-dvb/2010-September/032744.html
>>>which fixes an Oops when tuning eg. AVerMedia DVB-T Volar, Hauppauge
>>>Nova-T, Winfast DTV. it seems to be quite commonly reported on this list.
>>>
>>> [  809.128579] BUG: unable to handle kernel NULL pointer dereference at 0000000000000012
>>> [  809.128586] IP: [<ffffffffa0013702>] i2c_transfer+0x16/0x124 [i2c_core]
>>> [  809.128598] PGD 669a7067 PUD 79e5f067 PMD 0
>>> [  809.128604] Oops: 0000 [#1] SMP
...
>Could you try this patch:
>http://git.linuxtv.org/pb/media_tree.git?a=commit;h=80a5f1fdc6beb496347cbb297f9c1458c8cb9f50
>and report whether it solves the problem or not?

yes, that patch works for me on linux-media's media-master branch, and
also on fedora 2.6.35.10-72.fc14.x86_64.
thanks for workng on this!
it makes a lot of sense that the pid filtering fns are the root cause.

please feel free to add this to your patch:
  Tested-by: Robin Humble <robin.humble+dvb@anu.edu.au>
and to scrap my patch.

cheers,
robin
