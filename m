Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:58903 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab1EFLdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 07:33:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 06 May 2011 13:33:41 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, <jarod@wilsonet.com>
Subject: Re: [PATCH 08/10] rc-core: merge rc5 and streamzap decoders
In-Reply-To: <4DC16E70.6070806@redhat.com>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151353.8272.81582.stgit@felix.hardeman.nu> <4DC16E70.6070806@redhat.com>
Message-ID: <d98c46a67efbd7ac78ddb8186951454c@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 04 May 2011 12:19:12 -0300, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 28-04-2011 12:13, David Härdeman escreveu:
>> Now that the protocol is part of the scancode, it is pretty easy to
merge
>> the rc5 and streamzap decoders. An additional advantage is that the
>> decoder
>> is now stricter as it waits for the trailing silence before determining
>> that
>> a command is a valid rc5/streamzap command (which avoids collisions
that
>> I've
>> seen with e.g. Sony protocols).
> 
> Makes sense for me.
> 
> (FYI, I probably won't be applying any patch after patch 6, due to
> dependency issues).

Feel free to ignore it for now, I'll include it in a refreshed patchset.

-- 
David Härdeman
