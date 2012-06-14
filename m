Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59331 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab2FNUbY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 16:31:24 -0400
Message-ID: <4FDA4A18.5050900@iki.fi>
Date: Thu, 14 Jun 2012 23:31:20 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [BUG] dvb_usb_v2:  return the download ret in dvb_usb_download_firmware
References: <1339626272.2421.74.camel@Route3278> <4FD9224F.7050809@iki.fi> <1339634648.3833.37.camel@Route3278> <4FD93B3B.9000003@iki.fi>
In-Reply-To: <4FD93B3B.9000003@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2012 04:15 AM, Antti Palosaari wrote:
> On 06/14/2012 03:44 AM, Malcolm Priestley wrote:
>> On Thu, 2012-06-14 at 02:29 +0300, Antti Palosaari wrote:
>>> Hi Malcolm,
>>> I was really surprised someone has had interest to test that stuff at
>>> that phase as I did not even advertised it yet :) It is likely happen
>>> next Monday or so as there is some issues I would like to check / solve.
>>>
>>>
>>> On 06/14/2012 01:24 AM, Malcolm Priestley wrote:
>>>> Hi antti
>>>>
>>>> There some issues with dvb_usb_v2 with the lmedm04 driver.
>>>>
>>>> The first being this patch, no return value from
>>>> dvb_usb_download_firmware
>>>> causes system wide dead lock with COLD disconnect as system attempts
>>>> to continue
>>>> to warm state.
>>>
>>> Hmm, I did not understand what you mean. What I looked lmedm04 driver I
>>> think it uses single USB ID (no cold + warm IDs). So it downloads
>>> firmware and then reconnects itself from the USB bus?
>>> For that scenario you should "return RECONNECTS_USB;" from the driver
>>> .download_firmware().
>>>
>> If the device disconnects from the USB bus after the firmware download.
>>
>> In most cases the device is already gone.
>>
>> There is currently no way to insert RECONNECTS_USB into the return.
>
> Argh, I was blind! You are absolutely correct. It never returns value 1
> (RECONNECTS_USB) from the .download_firmware().
>
> That patch is fine, I will apply it, thanks!
>
> I think that must be also changed to return immediately without
> releasing the interface. Let the USB core release it when it detects
> disconnect - otherwise it could crash as it tries to access potentially
> resources that are already freed. Just for the timing issue if it
> happens or not.
>
> } else if (ret == RECONNECTS_USB) {
> ret = 0;
> goto exit_usb_driver_release_interface;
>
> add return 0 here without releasing interface and test.
>
>
>>> I tested it using one non-public Cypress FX2 device - it was changing
>>> USB ID after the FX download, but from the driver perspective it does
>>> not matter. It is always new device if it reconnects USB.
>>>
>>
>> Have double checked that the thread is not continuing to write on the
>> old ID?
>
> Nope, but likely delayed probe() is finished until it reconnects so I
> cannot see problem. You device disconnects faster and thus USB core
> traps .disconnect() earlier...
>
> Could you test returning 0 and if it works sent new patch.
>
>> The zero condition will lead to dvb_usb_init.
>>
>>> PS. as I looked that driver I saw many different firmwares. That is now
>>> supported and you should use .get_firmware_name() (maybe you already did
>>> it).
>>>
>> Yes, I have supported this in the driver.

Malcolm,

could you just test if returning from the routines after fw download is 
enough to fix all your problems?

I mean those two fixes:
dvb_usb_download_firmware()
* return RECONNECTS_USB correctly

dvb_usbv2_init_work()
* return without releasing USB interface if RECONNECTS_USB

regardss
Antti
-- 
http://palosaari.fi/
