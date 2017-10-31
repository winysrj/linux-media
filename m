Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45127 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbdJaUIB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 16:08:01 -0400
Date: Tue, 31 Oct 2017 20:07:58 +0000
From: Sean Young <sean@mess.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kees Cook <keescook@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: ttpci: remove autorepeat handling and use
 timer_setup
Message-ID: <20171031200758.avdowtmcem5fnlb5@gofer.mess.org>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
 <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
 <20171031174558.vsdpdudcwjneq2nu@gofer.mess.org>
 <20171031182236.cxrasbayon7h52mm@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031182236.cxrasbayon7h52mm@dtor-ws>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On Tue, Oct 31, 2017 at 11:22:36AM -0700, Dmitry Torokhov wrote:
> Hi Sean,
> 
> On Tue, Oct 31, 2017 at 05:45:58PM +0000, Sean Young wrote:
> > Leave the autorepeat handling up to the input layer, and move
> > to the new timer API.
> > 
> > Compile tested only.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/pci/ttpci/av7110.h    |  2 +-
> >  drivers/media/pci/ttpci/av7110_ir.c | 54 ++++++++++++++-----------------------
> >  2 files changed, 21 insertions(+), 35 deletions(-)
> > 
> > diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
> > index 347827925c14..bcb72ecbedc0 100644
> > --- a/drivers/media/pci/ttpci/av7110.h
> > +++ b/drivers/media/pci/ttpci/av7110.h
> > @@ -93,7 +93,7 @@ struct infrared {
> >  	u8			inversion;
> >  	u16			last_key;
> >  	u16			last_toggle;
> > -	u8			delay_timer_finished;
> > +	bool			keypressed;
> >  };
> >  
> >  
> > diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
> > index ca05198de2c2..8207bead2224 100644
> > --- a/drivers/media/pci/ttpci/av7110_ir.c
> > +++ b/drivers/media/pci/ttpci/av7110_ir.c
> > @@ -84,15 +84,16 @@ static u16 default_key_map [256] = {
> >  
> >  
> >  /* key-up timer */
> > -static void av7110_emit_keyup(unsigned long parm)
> > +static void av7110_emit_keyup(struct timer_list *t)
> >  {
> > -	struct infrared *ir = (struct infrared *) parm;
> > +	struct infrared *ir = from_timer(ir, t, keyup_timer);
> >  
> > -	if (!ir || !test_bit(ir->last_key, ir->input_dev->key))
> > +	if (!ir || !ir->keypressed)
> >  		return;
> >  
> >  	input_report_key(ir->input_dev, ir->last_key, 0);
> >  	input_sync(ir->input_dev);
> > +	ir->keypressed = false;
> >  }
> >  
> >  
> > @@ -105,6 +106,7 @@ static void av7110_emit_key(unsigned long parm)
> >  	u8 addr;
> >  	u16 toggle;
> >  	u16 keycode;
> > +	bool new_event;
> >  
> >  	/* extract device address and data */
> >  	switch (ir->protocol) {
> > @@ -152,29 +154,22 @@ static void av7110_emit_key(unsigned long parm)
> >  		return;
> >  	}
> >  
> > -	if (timer_pending(&ir->keyup_timer)) {
> > -		del_timer(&ir->keyup_timer);
> > -		if (ir->last_key != keycode || toggle != ir->last_toggle) {
> > -			ir->delay_timer_finished = 0;
> > -			input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
> > -			input_event(ir->input_dev, EV_KEY, keycode, 1);
> > -			input_sync(ir->input_dev);
> > -		} else if (ir->delay_timer_finished) {
> > -			input_event(ir->input_dev, EV_KEY, keycode, 2);
> > -			input_sync(ir->input_dev);
> > -		}
> > -	} else {
> > -		ir->delay_timer_finished = 0;
> > -		input_event(ir->input_dev, EV_KEY, keycode, 1);
> > +	new_event = !ir->keypressed || ir->last_key != keycode ||
> > +		   toggle != ir->last_toggle;
> > +
> > +	if (new_event && ir->keypressed)
> > +		input_event(ir->input_dev, EV_KEY, ir->last_key, 1);
> > +
> > +	if (new_event) {
> > +		input_event(ir->input_dev, EV_KEY, keycode, 0);
> 
> I do not think this is correct. You want to release the old button, and
> press the new one, not the other way around.

Yes, you are right. 0 is for key up, 1 is for key down.

> Given that we are reworking the code, and input core actually filters
> out duplicate events for you, you can probably simplify it all further:

Ah, that's useful to know.

> 	/* Release old key/button */
> 	if (ir->keypressed && ir->last_key != keycode)
> 		input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
> 
> 	input_event(ir->input_dev, EV_KEY, keycode, 1);
> 	input_sync(ir->input_dev);

That is better.

> and get rid of last_toggle member.

The last_toggle is needed, it's a feature of the RC5 and RC6 IR protocol.

Since there is no key up IR message (just key down which gets repeated if
the key held down), there is no way to distinguish between key hold
and press-release-press. The toggle is a bit in the RC5 and RC6 IR protocol,
which flips if the user pressed, released and then presses a button again.

So if the toggle bit changes, we want to send a keyup/keydown event and
reset autorepeat.

> 
> >  		input_sync(ir->input_dev);
> >  	}
> >  
> > +	ir->keypressed = true;
> >  	ir->last_key = keycode;
> >  	ir->last_toggle = toggle;
> >  
> > -	ir->keyup_timer.expires = jiffies + UP_TIMEOUT;
> > -	add_timer(&ir->keyup_timer);
> > -
> > +	mod_timer(&ir->keyup_timer, jiffies + UP_TIMEOUT);
> >  }
> >  
> >  
> > @@ -204,16 +199,6 @@ static void input_register_keys(struct infrared *ir)
> >  	ir->input_dev->keycodemax = ARRAY_SIZE(ir->key_map);
> >  }
> >  
> > -
> > -/* called by the input driver after rep[REP_DELAY] ms */
> > -static void input_repeat_key(unsigned long parm)
> > -{
> > -	struct infrared *ir = (struct infrared *) parm;
> > -
> > -	ir->delay_timer_finished = 1;
> > -}
> > -
> > -
> >  /* check for configuration changes */
> >  int av7110_check_ir_config(struct av7110 *av7110, int force)
> >  {
> > @@ -333,8 +318,7 @@ int av7110_ir_init(struct av7110 *av7110)
> >  	av_list[av_cnt++] = av7110;
> >  	av7110_check_ir_config(av7110, true);
> >  
> > -	setup_timer(&av7110->ir.keyup_timer, av7110_emit_keyup,
> > -		    (unsigned long)&av7110->ir);
> > +	timer_setup(&av7110->ir.keyup_timer, av7110_emit_keyup, 0);
> >  
> >  	input_dev = input_allocate_device();
> >  	if (!input_dev)
> > @@ -365,8 +349,10 @@ int av7110_ir_init(struct av7110 *av7110)
> >  		input_free_device(input_dev);
> >  		return err;
> >  	}
> > -	input_dev->timer.function = input_repeat_key;
> > -	input_dev->timer.data = (unsigned long) &av7110->ir;
> > +
> > +	/* Let the input layer handle autorepeat for us */
> > +	input_dev->rep[REP_DELAY] = 250;
> > +	input_dev->rep[REP_PERIOD] = 125;
> 
> 
> I'd change this to:
> 
> 	/*
> 	 * Input core's default autorepeat is 33 cps with 250 msec
> 	 * delay, let's adjust to numbers more suitable for remote
> 	 * control.
> 	 */
> 	input_enable_softrepeat(input_dev, 250, 125);
> 
> Thanks.

Good point, thanks again.

Thanks for the suggestions, I'll send a v2 shortly.


Sean
