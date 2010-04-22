Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab0DVBza (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 21:55:30 -0400
Date: Wed, 21 Apr 2010 21:55:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/3] ir-core: add imon driver
Message-ID: <20100422015525.GA14221@redhat.com>
References: <20100416212622.GA6888@redhat.com>
 <20100416212902.GD2427@redhat.com>
 <20100420182236.2e5a1325@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420182236.2e5a1325@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 20, 2010 at 06:22:36PM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 16 Apr 2010 17:29:02 -0400
> Jarod Wilson <jarod@redhat.com> escreveu:
> 
> > 
> > This is a new driver for the SoundGraph iMON and Antec Veris IR/display
> > devices commonly found in many home theater pc cases and as after-market
> > case additions.
> 
> 
> > +/* IR protocol: native iMON, Windows MCE (RC-6), or iMON w/o PAD stabilize */
> > +static int ir_protocol;
> > +module_param(ir_protocol, int, S_IRUGO | S_IWUSR);
> > +MODULE_PARM_DESC(ir_protocol, "Which IR protocol to use. 0=auto-detect, "
> > +		 "1=Windows Media Center Ed. (RC-6), 2=iMON native, "
> > +		 "4=iMON w/o PAD stabilize (default: auto-detect)");
> > +
> 
> You don't need this. Let's the protocol to be adjustable via sysfs. All you need to do is
> to use the set_protocol callbacks with something like:
> 
>         props->allowed_protos = IR_TYPE_RC6 | IR_TYPE_<imon protocol>;
>         props->change_protocol = imon_ir_change_protocol;
> 
> You can see an example of such implementation at drivers/media/video/em28xx-em28xx-input.c.
> Look for em28xx_ir_change_protocol() function.

Working on it now... I'm about 95% of the way there, just need to sort out
one last little bit...

> That's said, I'm not sure what would be better way to map IR_TYPE_<imon protocol>. Maybe we
> can just use IR_TYPE_OTHER.
> 
> So, basically, we'll have:
> 
> 	IR_TYPE_OTHER | IR_TYPE_RC6	- auto-detected between RC-6 and iMON
> 	IR_TYPE_OTHER			- iMON proprietary protocol
> 	IR_TYPE_RC6			- RC-6 protocol
> 
> 
> By doing this, the userspace application ir-keycode will already be able to handle the
> IR protocol.

I'm going to go with IR_TYPE_OTHER for the iMON native proto for now. To
be honest, I don't have a clue what the actual IR protocol looks like... I
should try one of my iMON remotes w/an mce transceiver to see if I can
figure it out...

> I'm not sure how to map the "PAD stablilize" case, but it seems that the better would be to
> add a sysfs node for it, at sys/class/rc/rc0. There are other cases where some protocols
> may require some adjustments, so I'm thinking on having some protocol-specific properties there.

For the moment, I'm dropping the ir_protocol modparam and adding a
pad_stabilize one. It was a hack to have it as a protocol, all it really
needs to do is bypass a function when processing the pad signals. Can
convert it to something more standard once we have a standard for
protocol-specific properties. (The pad_thresh modparam is probably a
similar case).

> Except for that, the patch looked sane to my eyes. So, I'll add it on my tree and wait for a
> latter patch from you addressing the protocol control.

Good deal, I'm working off the v4l-dvb git tree now, hope to have
something a bit later tonight or tomorrow.

-- 
Jarod Wilson
jarod@redhat.com

