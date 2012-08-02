Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60617 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab2HBU0R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 16:26:17 -0400
References: <50186040.1050908@lockie.ca> <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com> <5019EE10.1000207@lockie.ca> <bdafbcab-4074-4557-b108-a76f00ab8b3e@email.android.com> <CAGoCfiwN=h708e65DmZi7m6gcRMmcRbRZGJvpJ6ZzUk9Cm22dQ@mail.gmail.com> <7381e4d38b045460f0ff32e0905f079e.squirrel@lockie.ca> <CAGoCfiyo_1e5iA4jZ=44=DqQFcPf3+pUFrQ1h=LHg=O-r_nPQA@mail.gmail.com> <dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
In-Reply-To: <dbb5a626e07a4a4f4db40094c35fbd96.squirrel@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 02 Aug 2012 16:26:14 -0400
To: bjlockie@lockie.ca, Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <0bf0cf40-7862-45c8-9a9b-edd7ec3fc333@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bjlockie@lockie.ca wrote:

>
>> Heck, even for the 1250 there are eight or ten different versions, so
>> most users wouldn't even know the right one to choose.
>
>Do you mean boards that use different chips?
>I hate it when manufacturers do that (ie. with routers).
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yup.  There are "HVR1250"s with different bridge chips: CX23885 vs CX23888.  Normally board differences are with tuner, demod, fm radio, and IR chips.

Bridge drivers have the smarts to know what board they are dealing with much better than a human staring at vendor packaging.  Bridge drivers look at:

PCI/USB id
Hard coded tables in the drivers
EEPROM information (vendor specific)
I2C bus probes at expected addresses
Goofy hueristics based on register reads (I.e. cx25840_probe ) 
User provided module options for card type (last resort)

The end user has no hope of compiling the exact linux drivers for a board without some simple experimentation with modprobe and lsmod with the hardware.  The Kconfig system gets you the superset of everything the bridge driver might need for a card, given a particular bridge driver.

Regards,
Andy 
