Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1LaUU6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 15:20:58 -0500
Message-ID: <4EFF6E9E.8060202@redhat.com>
Date: Sat, 31 Dec 2011 18:20:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com> <20111231163145.251d526e@stein>
In-Reply-To: <20111231163145.251d526e@stein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31-12-2011 13:31, Stefan Richter wrote:
> On Dec 30 Mauro Carvalho Chehab wrote:
>> Basically, changes all DVB frontend drivers to work directly with
>> the DVBv5 structure.
> [...]
>> Test reports are welcome.
> [...]
>>   [media] firedtv: convert set_fontend to use DVBv5 parameters
> [...]
>>  drivers/media/dvb/firewire/firedtv-avc.c     |   95 ++++++++--------
>>  drivers/media/dvb/firewire/firedtv-fe.c      |   31 ++----
>>  drivers/media/dvb/firewire/firedtv.h         |    4 +-
> 
> I briefly tested git://linuxtv.org/media_tree.gitstaging/for_v3.3
> 7c61d80a9bcf on top of v3.2-rc7 on a FireDTV-T/CI with kaffeine and on a
> FireDTV-C/CI with kaffeine and smplayer and didn't notice any runtime problem.

Thanks for testing it!

> Building fs/compat_ioctl.c failed for me though:
> fs/compat_ioctl.c:1345:1: error: invalid application of ‘sizeof’ to incomplete type ‘struct dvb_frontend_parameters’ 
> fs/compat_ioctl.c:1345:1: error: array type has incomplete element type
> etc. pp.

Yeah, I forgot about the compat stuff ;)

The fix is simple:
	http://git.linuxtv.org/media_tree.git/commit/e97a5d893fdf45c20799b72a1c11dca3b282c89c

Basically, one patch at the tree avoids the usage of DVBv3 
structs inside the drivers, as this is not supported by the
DVB core anymore. The core itself (and compat) will need it,
in order to provide DVBv3 compatibility.

Regards,
Mauro
