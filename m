Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:33839 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2H0LMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 07:12:37 -0400
Message-ID: <503B55D1.9000908@iki.fi>
Date: Mon, 27 Aug 2012 14:11:13 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@newoldbits.com>
CC: Tony Lindgren <tony@atomide.com>, mchehab@redhat.com,
	Kevin Hilman <khilman@ti.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2 7/8] ir-rx51: Convert latency constraints to PM QoS
 API
References: <1345820986-4597-1-git-send-email-timo.t.kokkonen@iki.fi> <1345820986-4597-8-git-send-email-timo.t.kokkonen@iki.fi> <20120824203957.GC1303@atomide.com> <CAORVsuVXDK896dBb+f6qLq6Dct0CWjTn72q4Y88hdgjNA+T0pg@mail.gmail.com>
In-Reply-To: <CAORVsuVXDK896dBb+f6qLq6Dct0CWjTn72q4Y88hdgjNA+T0pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/27/12 12:25, Jean Pihet wrote:
> Hi Timo,
> 
> On Fri, Aug 24, 2012 at 10:39 PM, Tony Lindgren <tony@atomide.com> wrote:
>> * Timo Kokkonen <timo.t.kokkonen@iki.fi> [120824 08:11]:
>>> Convert the driver from the obsolete omap_pm_set_max_mpu_wakeup_lat
>>> API to the new PM QoS API. This allows the callback to be removed from
>>> the platform data structure.
>>>
>>> The latency requirements are also adjusted to prevent the MPU from
>>> going into sleep mode. This is needed as the GP timers have no means
>>> to wake up the MPU once it has gone into sleep. The "side effect" is
>>> that from now on the driver actually works even if there is no
>>> background load keeping the MPU awake.
>>>
>>> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
>>
>> This should get acked by Kevin ideally. Other than that:
>>
>> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> ...
> @@ -268,10 +270,14 @@ static ssize_t lirc_rx51_write(struct file
> *file, const char *buf,
>                 lirc_rx51->wbuf[count] = -1; /* Insert termination mark */
> 
>         /*
> -        * Adjust latency requirements so the device doesn't go in too
> -        * deep sleep states
> +        * If the MPU is going into too deep sleep state while we are
> +        * transmitting the IR code, timers will not be able to wake
> +        * up the MPU. Thus, we need to set a strict enough latency
> +        * requirement in order to ensure the interrupts come though
> +        * properly.
>          */
> -       lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
> +       pm_qos_add_request(&lirc_rx51->pm_qos_request,
> +                       PM_QOS_CPU_DMA_LATENCY, 10);
> Minor remark: it would be nice to have more detail on where the
> latency number 10 comes from. Is it fixed, is it linked to the baud
> rate etc?
> 

Yeah, it was chosen to be low enough for the MPU to receive the IRQ from
the timers. 50us was good enough back then with the original n900
kernel, but nowadays it is not good enough from preventing the MPU from
going to sleep where the timer interrupts don't come through.

Yes, I should probably have stated that in the comment to make it clear.
Can I re-send just this one patch or should I send the entire set again?
I'm assuming these go in through Mauro's media tree as these depend on
stuff that's already there. So, which ever is easier for him I guess :)

Thanks!

-Timo

> Here is my ack for the PM QoS API part:
> Acked-by: Jean Pihet <j-pihet@ti.com>
> 
> Regards,
> Jean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

