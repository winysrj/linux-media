Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39234 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZL2RDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 12:03:18 -0500
Date: Tue, 29 Dec 2009 19:01:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR
	devices
Message-ID: <20091229164856.GA29476@bicker>
References: <20091228051155.GA14301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228051155.GA14301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I ran smatch (http://repo.or.cz/w/smatch.git) on it and there are
some bugs worth fixing.

drivers/input/misc/imon.c +331 free_imon_context(7) error: dereferencing freed memory 'context'
Move the debug line earlier.

drivers/input/misc/imon.c +1812 imon_probe(216) error: dereferencing undefined:  'context->idev'
drivers/input/misc/imon.c +1876 imon_probe(280) error: dereferencing undefined:  'context->touch'
The allocation func can return NULL.  They probably won't fail in real 
life, but it will slightly annoy every person checking running smatch 
over the entire kernel (me).

drivers/input/misc/imon.c +1979 imon_probe(383) error: double unlock 'mutex:&context->lock'
drivers/input/misc/imon.c +1983 imon_probe(387) error: double unlock 'mutex:&context->lock'
It sometimes unlocks both before and after the goto.

regards,
dan carpenter
