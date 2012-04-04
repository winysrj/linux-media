Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2DDMLX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Apr 2012 08:11:23 -0400
Message-ID: <4F7C3A67.40406@linux.intel.com>
Date: Wed, 04 Apr 2012 15:11:19 +0300
From: David Cohen <david.a.cohen@linux.intel.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Gianluca Gennari <gennarone@gmail.com>,
	linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH] af9035: add several new USB IDs
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com> <4F7C3787.5020602@iki.fi>
In-Reply-To: <4F7C3787.5020602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 04/04/2012 02:59 PM, Antti Palosaari wrote:
> On 04.04.2012 14:47, Gianluca Gennari wrote:
>> Add several new USB IDs extracted from the Windows and Linux drivers
>> published
>> by the manufacturers (Terratec and AVerMedia).
>> + [AF9035_07CA_0867] = {
>> + USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0867)},
>> [AF9035_07CA_1867] = {
>> USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
>> + [AF9035_07CA_3867] = {
>> + USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_3867)},
>> [AF9035_07CA_A867] = {
>> USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
>> + [AF9035_07CA_B867] = {
>> + USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B867)},
>
> It have been common practise to use product names for USB PID
> definitions instead of USB ID numbers. I vote to continue that practise.
>
> Also, I am not very sure if it is wise to add new IDs without any
> testing. Likely those are just reference design and will work, but
> sometimes there is also some changes done for schematic wiring.
> Especially for Avermedia, see hacks needed some AF9015 Avermedia
> devices. They have put invalid data to eeprom and thus hacks are needed
> for overriding tuner IDs etc.
> Not to mention, driver supports also dynamic IDs and even device ID is
> missing user can load driver using dynamic ID and report it working or
> non-working.
>
> Anyone else any thoughts about adding IDs without testing ?

In my experience, it's not always workable out-of-the-box (for the
reasons you mentioned).
IMO it would be better either them adding as long as they're been
tested, or at least to add comments when untested but likely to work.

Br,

David

>
> regards
> Antti

