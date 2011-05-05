Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1EELJW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 07:09:22 -0400
Message-ID: <4DC28555.4080301@redhat.com>
Date: Thu, 05 May 2011 08:09:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>, tomekbu@op.pl,
	Steven Stoth <stoth@kernellabs.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?B?SGVybsOhbiBPcmRpYWxlcw==?= <h.ordiales@gmail.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Igor M. Liplianin" <liplianin@me.by>
Subject: Re: Patches still pending at linux-media queue (18 patches)
References: <4DC2207B.5030700@redhat.com> <201105050824.36310.hverkuil@xs4all.nl>
In-Reply-To: <201105050824.36310.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 03:24, Hans Verkuil escreveu:
> On Thursday, May 05, 2011 05:58:51 Mauro Carvalho Chehab wrote:
>> Hans,
>> 	I believe that want to replace this patch by something else, but better to keep it at the list while you don't
>> send us a replacement.
>>
>> Mar,26 2011: [media] cpia2: fix typo in variable initialisation                     http://patchwork.kernel.org/patch/665951  Mariusz Kozlowski <mk@lab.zgora.pl>
> 
> Feel free to merge this. It makes a broken driver slightly less broken.
> 
> I don't know when I will have time to create a proper patch that fixes this
> driver. I need to get the work I'm doing on the control framework done first,
> and that is taking a lot longer than I would like. But there is no sense in
> keeping this patch back.
> 
> While working on the control framework I found a few bugs. I'll try to make
> a pull request fixing them today or tomorrow at the latest.

Ok, thanks for acking on merging this.

Mauro.
