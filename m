Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:53297
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbZJCFV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 01:21:57 -0400
References: <20091002104708.18d3b0a3@hyperion.delvare>
Message-Id: <C19F0787-2CA3-4DE3-BD70-DAF41B6D13C1@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20091002104708.18d3b0a3@hyperion.delvare>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] i2c_board_info can be local
Date: Sat, 3 Oct 2009 01:21:18 -0400
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Oct 2, 2009, at 4:47 AM, Jean Delvare <khali@linux-fr.org> wrote:

> Recent fixes to the em28xx and saa7134 drivers have been overzealous.
> While the ir-kbd-i2c platform data indeed needs to be persistent, the
> struct i2c_board_info doesn't, as it is only used by i2c_new_device().
>
> So revert a part of the original fixes, to save some memory.
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Yeah, good call.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com

