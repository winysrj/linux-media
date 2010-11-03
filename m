Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36073 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0KCMPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 08:15:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 03 Nov 2010 13:15:30 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/3] mceusb: fix up reporting of trailing space
In-Reply-To: <20101102211214.GC20631@redhat.com>
References: <20101029030545.GA17238@redhat.com> <20101029030810.GC17238@redhat.com> <20101029192121.GB12136@hardeman.nu> <20101102211214.GC20631@redhat.com>
Message-ID: <34503d917790f7c21ac4d089e8f8235e@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, 2 Nov 2010 17:12:14 -0400, Jarod Wilson <jarod@redhat.com> wrote:
> On Fri, Oct 29, 2010 at 09:21:21PM +0200, David Härdeman wrote:
>> I think the driver could be further simplified by using 
>> ir_raw_event_store_with_filter(), right?
> 
> And in fact, it is. I've got a new series of patches redone atop your
> rc-core patch series that includes usage of _with_filter in mceusb.

>From a quick check, I think the entire PARSE_IRDATA block in
mceusb_process_ir_data() could be simplified to:

case PARSE_IRDATA:
    ir->rem--;
    rawir.pulse = !!(ir->buf_in[i] & MCE_PULSE_BIT);
    rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
                      * MCE_TIME_UNIT * 1000;
    ir_raw_event_store_with_filter(ir->rc, &rawir);
    break;

And you can then remove "struct ir_raw_event rawir" from struct
mceusb_dev.

-- 
David Härdeman
