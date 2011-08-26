Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42156 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab1HZNwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 09:52:22 -0400
Received: from [10.83.86.16] (unknown [88.162.125.7])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 4681494014E
	for <linux-media@vger.kernel.org>; Fri, 26 Aug 2011 15:52:16 +0200 (CEST)
Message-ID: <4E57A50E.2040908@streamvision.fr>
Date: Fri, 26 Aug 2011 15:52:14 +0200
From: =?ISO-8859-1?Q?St=E9phane_Railhet?=
	<stephane.railhet@streamvision.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Satelco DVBS CAM initialisation failing
References: <4E53E3FF.5090109@streamvision.fr>
In-Reply-To: <4E53E3FF.5090109@streamvision.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think I have located the problem and I would like to get your opinion 
about it.
I have patch my budget-av driver to increase a sleep during cam reset 
and it seems to solve a problem of initialisation with two different CAM 
model (one NEOTION and one SmartDTV) on all my machine.

Because I'm not really aware about how this driver works I would like to 
get your opinion about this change and know if it is as harmless as it 
looks like. I've done several test over several machine with my Satelco 
EasyWatch DVBS + 4 different CAM model and everything seems to be OK 
(Aston Viacess Pro, Neotion Viacess Pro, SmarDTV irDeto, PowerCam, Aston 
Conax Pro)

-----------------------------------------------------------------------------------------------------------------

Here is my modification :

static int ciintf_slot_reset(struct dvb_ca_en50221 *ca, int slot)
{
     struct budget_av *budget_av = (struct budget_av *) ca->data;
     struct saa7146_dev *saa = budget_av->budget.dev;

     if (slot != 0)
         return -EINVAL;

     dprintk(1, "ciintf_slot_reset\n");
     budget_av->slot_status = SLOTSTATUS_RESET;

     saa7146_setgpio(saa, 2, SAA7146_GPIO_OUTHI); /* disable card */

     saa7146_setgpio(saa, 0, SAA7146_GPIO_OUTHI); /* Vcc off */
     msleep(2);
     saa7146_setgpio(saa, 0, SAA7146_GPIO_OUTLO); /* Vcc on */

+    msleep(750);
-    msleep(20); /* 20 ms Vcc settling time */

     saa7146_setgpio(saa, 2, SAA7146_GPIO_OUTLO); /* enable card */
     ttpci_budget_set_video_port(saa, BUDGET_VIDEO_PORTB);
     msleep(20);

     /* reinitialise the frontend if necessary */
     if (budget_av->reinitialise_demod)
         dvb_frontend_reinitialise(budget_av->budget.dvb_frontend);

     return 0;
}

-----------------------------------------------------------------------------------------------------------------

Thanks for your help and yours comments,

Stéphane Railhet

