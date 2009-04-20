Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZDTRz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 13:55:29 -0400
Date: Mon, 20 Apr 2009 14:55:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0904_12] Siano: unified the debug filter module
 parameter (dvb and core)
Message-ID: <20090420145523.7bf9e790@pedra.chehab.org>
In-Reply-To: <225276.3555.qm@web110814.mail.gq1.yahoo.com>
References: <225276.3555.qm@web110814.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 03:25:06 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> [PATCH] [0904_12] Siano: unified the debug filter module parameter (dvb and core)
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> The sms_debug module parameter sets the debug filter
> for the smsmdtv module. It has been moved to the core
> component, and replace the smsdvb's.
> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

The changeset created breakage on both modules:

WARNING: "sms_debug" [/home/v4l/master/v4l/smsusb.ko] undefined!
WARNING: "sms_debug" [/home/v4l/master/v4l/smsdvb.ko] undefined!

Reverted.


Cheers,
Mauro
