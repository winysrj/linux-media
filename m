Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47898 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2H0JZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Aug 2012 05:25:14 -0400
Received: by lbbgj3 with SMTP id gj3so2369140lbb.19
        for <linux-media@vger.kernel.org>; Mon, 27 Aug 2012 02:25:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120824203957.GC1303@atomide.com>
References: <1345820986-4597-1-git-send-email-timo.t.kokkonen@iki.fi>
	<1345820986-4597-8-git-send-email-timo.t.kokkonen@iki.fi>
	<20120824203957.GC1303@atomide.com>
Date: Mon, 27 Aug 2012 11:25:12 +0200
Message-ID: <CAORVsuVXDK896dBb+f6qLq6Dct0CWjTn72q4Y88hdgjNA+T0pg@mail.gmail.com>
Subject: Re: [PATCHv2 7/8] ir-rx51: Convert latency constraints to PM QoS API
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	Kevin Hilman <khilman@ti.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Timo,

On Fri, Aug 24, 2012 at 10:39 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Timo Kokkonen <timo.t.kokkonen@iki.fi> [120824 08:11]:
>> Convert the driver from the obsolete omap_pm_set_max_mpu_wakeup_lat
>> API to the new PM QoS API. This allows the callback to be removed from
>> the platform data structure.
>>
>> The latency requirements are also adjusted to prevent the MPU from
>> going into sleep mode. This is needed as the GP timers have no means
>> to wake up the MPU once it has gone into sleep. The "side effect" is
>> that from now on the driver actually works even if there is no
>> background load keeping the MPU awake.
>>
>> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
>
> This should get acked by Kevin ideally. Other than that:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

...
@@ -268,10 +270,14 @@ static ssize_t lirc_rx51_write(struct file
*file, const char *buf,
                lirc_rx51->wbuf[count] = -1; /* Insert termination mark */

        /*
-        * Adjust latency requirements so the device doesn't go in too
-        * deep sleep states
+        * If the MPU is going into too deep sleep state while we are
+        * transmitting the IR code, timers will not be able to wake
+        * up the MPU. Thus, we need to set a strict enough latency
+        * requirement in order to ensure the interrupts come though
+        * properly.
         */
-       lirc_rx51->pdata->set_max_mpu_wakeup_lat(lirc_rx51->dev, 50);
+       pm_qos_add_request(&lirc_rx51->pm_qos_request,
+                       PM_QOS_CPU_DMA_LATENCY, 10);
Minor remark: it would be nice to have more detail on where the
latency number 10 comes from. Is it fixed, is it linked to the baud
rate etc?

Here is my ack for the PM QoS API part:
Acked-by: Jean Pihet <j-pihet@ti.com>

Regards,
Jean
