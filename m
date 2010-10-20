Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36355 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0JTM03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 08:26:29 -0400
Received: by eyx24 with SMTP id 24so798999eyx.19
        for <linux-media@vger.kernel.org>; Wed, 20 Oct 2010 05:26:28 -0700 (PDT)
Date: Wed, 20 Oct 2010 14:26:20 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, opensuse-kernel@opensuse.org
Subject: Re: [opensuse-kernel] Unloading cx8802 results in crash of
 ir_core:ir_unregister_class
Message-ID: <20101020142620.181ea010@susi.home.s3e.de>
In-Reply-To: <201010201231.24173.hpj@urpla.net>
References: <201010201231.24173.hpj@urpla.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 20 Oct 2010 12:31:23 +0200
"Hans-Peter Jansen" <hpj@urpla.net> wrote:

> Welcome to openSUSE 11.1 - Kernel 2.6.34.7-4-pae (ttyS0)

> Any ideas, what's going wrong here?

Your kernel is ancient. Please try reproducing with a recent kernel from
the Kernel:HEAD repo. If it still happens, let's debug it. If it doesn't,
create a bugreport against the SUSE kernel and hope that they backport the
fix.

Best regards,

	Stefan
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
