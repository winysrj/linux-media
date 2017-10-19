Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:43896 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdJSWcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 18:32:50 -0400
Date: Thu, 19 Oct 2017 15:32:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geliang Tang <geliangtang@gmail.com>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: input: Convert timers to use timer_setup()
Message-ID: <20171019223246.2wsgr6in7oigq6da@dtor-ws>
References: <20171016231443.GA100011@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171016231443.GA100011@beast>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 16, 2017 at 04:14:43PM -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly.
> 
> One input_dev user hijacks the input_dev software autorepeat timer to
> perform its own repeat management. However, there is no path back to the
> existing status variable, so add a generic one to the input structure and
> use that instead.

That is too bad and it should not be doing this. I'd rather av7110 used
its own private timer for that.

> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Geliang Tang <geliangtang@gmail.com>
> Cc: linux-input@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/input/input.c               | 12 ++++++------
>  drivers/media/pci/ttpci/av7110.h    |  1 -
>  drivers/media/pci/ttpci/av7110_ir.c | 16 ++++++++--------
>  include/linux/input.h               |  2 ++
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index d268fdc23c64..497ad2dcb699 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -76,7 +76,7 @@ static void input_start_autorepeat(struct input_dev *dev, int code)
>  {
>  	if (test_bit(EV_REP, dev->evbit) &&
>  	    dev->rep[REP_PERIOD] && dev->rep[REP_DELAY] &&
> -	    dev->timer.data) {
> +	    dev->timer.function) {
>  		dev->repeat_key = code;
>  		mod_timer(&dev->timer,
>  			  jiffies + msecs_to_jiffies(dev->rep[REP_DELAY]));
> @@ -179,9 +179,9 @@ static void input_pass_event(struct input_dev *dev,
>   * dev->event_lock here to avoid racing with input_event
>   * which may cause keys get "stuck".
>   */
> -static void input_repeat_key(unsigned long data)
> +static void input_repeat_key(struct timer_list *t)
>  {
> -	struct input_dev *dev = (void *) data;
> +	struct input_dev *dev = from_timer(dev, t, timer);
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&dev->event_lock, flags);
> @@ -1790,7 +1790,7 @@ struct input_dev *input_allocate_device(void)
>  		device_initialize(&dev->dev);
>  		mutex_init(&dev->mutex);
>  		spin_lock_init(&dev->event_lock);
> -		init_timer(&dev->timer);
> +		timer_setup(&dev->timer, NULL, 0);
>  		INIT_LIST_HEAD(&dev->h_list);
>  		INIT_LIST_HEAD(&dev->node);
>  
> @@ -2053,8 +2053,8 @@ static void devm_input_device_unregister(struct device *dev, void *res)
>   */
>  void input_enable_softrepeat(struct input_dev *dev, int delay, int period)
>  {
> -	dev->timer.data = (unsigned long) dev;
> -	dev->timer.function = input_repeat_key;
> +	dev->timer.function = (TIMER_FUNC_TYPE)input_repeat_key;
> +	dev->timer_data = 0;
>  	dev->rep[REP_DELAY] = delay;
>  	dev->rep[REP_PERIOD] = period;
>  }
> diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
> index 347827925c14..b98a4f3006df 100644
> --- a/drivers/media/pci/ttpci/av7110.h
> +++ b/drivers/media/pci/ttpci/av7110.h
> @@ -93,7 +93,6 @@ struct infrared {
>  	u8			inversion;
>  	u16			last_key;
>  	u16			last_toggle;
> -	u8			delay_timer_finished;
>  };
>  
>  
> diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
> index ca05198de2c2..a883caa6488c 100644
> --- a/drivers/media/pci/ttpci/av7110_ir.c
> +++ b/drivers/media/pci/ttpci/av7110_ir.c
> @@ -155,16 +155,16 @@ static void av7110_emit_key(unsigned long parm)
>  	if (timer_pending(&ir->keyup_timer)) {
>  		del_timer(&ir->keyup_timer);
>  		if (ir->last_key != keycode || toggle != ir->last_toggle) {
> -			ir->delay_timer_finished = 0;
> +			ir->input_dev->timer_data = 0;
>  			input_event(ir->input_dev, EV_KEY, ir->last_key, 0);
>  			input_event(ir->input_dev, EV_KEY, keycode, 1);
>  			input_sync(ir->input_dev);
> -		} else if (ir->delay_timer_finished) {
> +		} else if (ir->input_dev->timer_data) {
>  			input_event(ir->input_dev, EV_KEY, keycode, 2);
>  			input_sync(ir->input_dev);
>  		}
>  	} else {
> -		ir->delay_timer_finished = 0;
> +		ir->input_dev->timer_data = 0;
>  		input_event(ir->input_dev, EV_KEY, keycode, 1);
>  		input_sync(ir->input_dev);
>  	}
> @@ -206,11 +206,12 @@ static void input_register_keys(struct infrared *ir)
>  
>  
>  /* called by the input driver after rep[REP_DELAY] ms */
> -static void input_repeat_key(unsigned long parm)
> +static void input_repeat_key(struct timer_list *t)
>  {
> -	struct infrared *ir = (struct infrared *) parm;
> +	struct input_dev *dev = from_timer(dev, t, timer);
>  
> -	ir->delay_timer_finished = 1;
> +	/* Key repeat started */
> +	dev->timer_data = 1;
>  }
>  
>  
> @@ -365,8 +366,7 @@ int av7110_ir_init(struct av7110 *av7110)
>  		input_free_device(input_dev);
>  		return err;
>  	}
> -	input_dev->timer.function = input_repeat_key;
> -	input_dev->timer.data = (unsigned long) &av7110->ir;
> +	input_dev->timer.function = (TIMER_FUNC_TYPE)input_repeat_key;
>  
>  	if (av_cnt == 1) {
>  		e = proc_create("av7110_ir", S_IWUSR, NULL, &av7110_ir_proc_fops);
> diff --git a/include/linux/input.h b/include/linux/input.h
> index fb5e23c7ed98..dcd117bf1027 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -70,6 +70,7 @@ struct input_value {
>   * @repeat_key: stores key code of the last key pressed; used to implement
>   *	software autorepeat
>   * @timer: timer for software autorepeat
> + * @timer_data: timer data for software autorepeat overrides
>   * @rep: current values for autorepeat parameters (delay, rate)
>   * @mt: pointer to multitouch state
>   * @absinfo: array of &struct input_absinfo elements holding information
> @@ -152,6 +153,7 @@ struct input_dev {
>  
>  	unsigned int repeat_key;
>  	struct timer_list timer;
> +	unsigned long timer_data;
>  
>  	int rep[REP_CNT];
>  
> -- 
> 2.7.4
> 
> 
> -- 
> Kees Cook
> Pixel Security

-- 
Dmitry
