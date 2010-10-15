Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:60782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0JOP1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 11:27:42 -0400
Message-ID: <4CB872CD.4050700@infradead.org>
Date: Fri, 15 Oct 2010 12:27:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8 V6] Many fixes for in-kernel decoding and for the
 ENE driver
References: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-10-2010 12:07, Maxim Levitsky escreveu:
> Hi,
> 
> This is mostly a resend of my patches, although
> I fixed few bugs in the ENE code.
> This exact patchset was tested against ENE devices with all
> features tested.

I've applied most of the patches from your original series.

The pending ones are:

Sep, 6 2010: [7/8] IR: extend ir_raw_event and do refactoring                       lmml_159431_7_8_ir_extend_ir_raw_event_and_do_refactoring.patch        Maxim Levitsky <maximlevitsky@gmail.com>
Sep, 6 2010: [8/8] IR: ene_ir: add support for carrier reports                      lmml_159451_8_8_ir_ene_ir_add_support_for_carrier_reports.patch        Maxim Levitsky <maximlevitsky@gmail.com>

So, this series as-is will probably not apply anymore.

Could you please rebase it against staging/v2.6.37? 

I'll mark the two above as superseed and wait for your update.

Thanks,
Mauro
