Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:51086 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbbEKPry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 11:47:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH v2] Staging: media: Replace timeval with ktime_t
Date: Mon, 11 May 2015 17:47:51 +0200
Message-ID: <2343371.zo13jrb6Y7@wuerfel>
In-Reply-To: <1431276026-19407-1-git-send-email-ksenija.stanojevic@gmail.com>
References: <1431276026-19407-1-git-send-email-ksenija.stanojevic@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 10 May 2015 18:40:26 Ksenija Stanojevic wrote:
> 'struct timeval last_tv' is used to get the time of last signal change
> and 'struct timeval last_intr_tv' is used to get the time of last UART
> interrupt.
> 32-bit systems using 'struct timeval' will break in the year 2038, so we
> have to replace that code with more appropriate types.
> Here struct timeval is replaced with ktime_t.
> 
> Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
> ---
> Changes in v2:
> 	- change subject line

[adding linux-media@vger.kernel.org to cc]

Your patch looks correct to me, nice work!

> @@ -127,9 +127,9 @@ static int threshold = 3;
>  static DEFINE_SPINLOCK(timer_lock);
>  static struct timer_list timerlist;
>  /* time of last signal change detected */
> -static struct timeval last_tv = {0, 0};
> +static ktime_t last_tv;
>  /* time of last UART data ready interrupt */
> -static struct timeval last_intr_tv = {0, 0};
> +static ktime_t last_intr_tv;
>  static int last_value;

It would probably help to rename the variables here and remove the '_tv'
postfix as this is no longer a timeval.

>  static DECLARE_WAIT_QUEUE_HEAD(lirc_read_queue);
> @@ -400,17 +400,16 @@ static void drop_chrdev(void)
>  }
>  
>  /* SECTION: Hardware */
> -static long delta(struct timeval *tv1, struct timeval *tv2)
> +static long delta(ktime_t tv1, ktime_t tv2)
>  {
>  	unsigned long deltv;
> +	ktime_t delkt;
>  
> -	deltv = tv2->tv_sec - tv1->tv_sec;
> -	if (deltv > 15)
> +	delkt = ktime_sub(tv2, tv1);
> +	if (ktime_compare(delkt, ktime_set(15, 0)) > 0)
>  		deltv = 0xFFFFFF;
>  	else
> -		deltv = deltv*1000000 +
> -			tv2->tv_usec -
> -			tv1->tv_usec;
> +		deltv = (int)ktime_to_us(delkt);
>  	return deltv;
>  }

You have three different types here: 'long', 'unsigned long' and 'int'.
While I believe the code to be correct here, it would be easier to
see if you used all the same types, e.g. by making them all 'long'.

> @@ -432,7 +431,7 @@ static void sir_timeout(unsigned long data)
>  		/* clear unread bits in UART and restart */
>  		outb(UART_FCR_CLEAR_RCVR, io + UART_FCR);
>  		/* determine 'virtual' pulse end: */
> -		pulse_end = delta(&last_tv, &last_intr_tv);
> +		pulse_end = delta(last_tv, last_intr_tv);
>  		dev_dbg(driver.dev, "timeout add %d for %lu usec\n",
>  				    last_value, pulse_end);
>  		add_read_queue(last_value, pulse_end);
> @@ -445,7 +444,7 @@ static void sir_timeout(unsigned long data)
>  static irqreturn_t sir_interrupt(int irq, void *dev_id)
>  {
>  	unsigned char data;
> -	struct timeval curr_tv;
> +	ktime_t curr_tv;
>  	static unsigned long deltv;
>  	unsigned long deltintrtv;
>  	unsigned long flags;
> @@ -471,9 +470,9 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
>  			do {
>  				del_timer(&timerlist);
>  				data = inb(io + UART_RX);
> -				do_gettimeofday(&curr_tv);
> -				deltv = delta(&last_tv, &curr_tv);
> -				deltintrtv = delta(&last_intr_tv, &curr_tv);
> +				curr_tv = ktime_get();
> +				deltv = delta(last_tv, curr_tv);
> +				deltintrtv = delta(last_intr_tv, curr_tv);
>  				dev_dbg(driver.dev, "t %lu, d %d\n",
>  						    deltintrtv, (int)data);
>  				/*
> @@ -488,10 +487,7 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
>  							       deltv -
>  							       deltintrtv);
>  						last_value = 0;
> -						last_tv.tv_sec =
> -							last_intr_tv.tv_sec;
> -						last_tv.tv_usec =
> -							last_intr_tv.tv_usec;
> +						last_tv = last_intr_tv;
>  						deltv = deltintrtv;
>  					}
>  				}
> @@ -505,13 +501,8 @@ static irqreturn_t sir_interrupt(int irq, void *dev_id)
>  						       deltv-TIME_CONST);
>  					last_value = data;
>  					last_tv = curr_tv;
> -					if (last_tv.tv_usec >= TIME_CONST) {
> -						last_tv.tv_usec -= TIME_CONST;
> -					} else {
> -						last_tv.tv_sec--;
> -						last_tv.tv_usec += 1000000 -
> -							TIME_CONST;
> -					}
> +					last_tv = ktime_sub_us(last_tv,
> +							       TIME_CONST);
>  				}
>  				last_intr_tv = curr_tv;
>  				if (data) {
> 

