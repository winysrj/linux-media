Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39397 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0KLVEe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:04:34 -0500
Date: Fri, 12 Nov 2010 22:04:30 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] ir-kbd-i2c: add rc_dev as a parameter to
 the driver
Message-ID: <20101112210430.GA18719@hardeman.nu>
References: <cover.1289568397.git.mchehab@redhat.com>
 <20101112112838.2218e2d7@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101112112838.2218e2d7@pedra>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Nov 12, 2010 at 11:28:38AM -0200, Mauro Carvalho Chehab wrote:
>There are several fields on rc_dev that drivers can benefit. Allow drivers
>to pass it as a parameter to the driver.
>
>For now, the rc_dev parameter is optional. If drivers don't pass it, create
>them internally. However, the best is to create rc_dev inside the drivers,
>in order to fill other fields, like open(), close(), driver_name, etc.
>So, a latter patch making it mandatory and changing the caller drivers is
>welcome.

Looks good, no objections. Sorry for misinterpreting your suggested
change.

-- 
David Härdeman
