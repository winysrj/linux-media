Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:58866 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1EFJ6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 05:58:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 06 May 2011 11:58:31 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, <jarod@wilsonet.com>
Subject: Re: [PATCH 07/10] rc-core: use the full 32 bits for NEC scancodes
In-Reply-To: <4DC16DC1.1060109@redhat.com>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu> <20110428151348.8272.50675.stgit@felix.hardeman.nu> <4DC16DC1.1060109@redhat.com>
Message-ID: <764334f74e35d3f677c84d01143340ab@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 04 May 2011 12:16:17 -0300, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 28-04-2011 12:13, David Härdeman escreveu:
>> Using the full 32 bits for all kinds of NEC scancodes simplifies
rc-core
>> and the nec decoder without any loss of functionality.
> 
> This seems to be a good strategy. However, it breaks the existing NEC
> keymap tables (/me is not considering patch 6/10 macros), and changes
> those keytables on userspace. Not sure how to address this.

The in-kernel keymaps is not a problem, they can always be updated in the
same patch. Keytables provided from userspace are a bigger problem.

Perhaps we could check if the set/get ioctl is done with the new
rc-specific
struct (that includes protocol) and assume that the scancode will be in
nec32
if the protocol has been explicitly provided.

This might seem like we're adding a lot of guesswork into rc-core, but I
think
we should/could phase out the use of legacy ioctls over a couple of kernel
versions and the heuristics can then be removed at the same time.

-- 
David Härdeman
