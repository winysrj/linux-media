Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:50846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab0KCTsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Nov 2010 15:48:31 -0400
Date: Wed, 3 Nov 2010 15:48:27 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] mceusb: fix up reporting of trailing space
Message-ID: <20101103194827.GD12749@redhat.com>
References: <20101029030545.GA17238@redhat.com>
 <20101029030810.GC17238@redhat.com>
 <20101029192121.GB12136@hardeman.nu>
 <20101102211214.GC20631@redhat.com>
 <34503d917790f7c21ac4d089e8f8235e@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34503d917790f7c21ac4d089e8f8235e@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Nov 03, 2010 at 01:15:30PM +0100, David Härdeman wrote:
> On Tue, 2 Nov 2010 17:12:14 -0400, Jarod Wilson <jarod@redhat.com> wrote:
> > On Fri, Oct 29, 2010 at 09:21:21PM +0200, David Härdeman wrote:
> >> I think the driver could be further simplified by using 
> >> ir_raw_event_store_with_filter(), right?
> > 
> > And in fact, it is. I've got a new series of patches redone atop your
> > rc-core patch series that includes usage of _with_filter in mceusb.
> 
> From a quick check, I think the entire PARSE_IRDATA block in
> mceusb_process_ir_data() could be simplified to:
> 
> case PARSE_IRDATA:
>     ir->rem--;
>     rawir.pulse = !!(ir->buf_in[i] & MCE_PULSE_BIT);
>     rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
>                       * MCE_TIME_UNIT * 1000;
>     ir_raw_event_store_with_filter(ir->rc, &rawir);
>     break;
> 
> And you can then remove "struct ir_raw_event rawir" from struct
> mceusb_dev.

Once again, I think you're correct. :) I'll give this a spin with a few
mceusb devices, but it does certainly look like that'll work, now that
we're using _with_filter.

-- 
Jarod Wilson
jarod@redhat.com

