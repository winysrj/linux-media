Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:55338 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab0DCTl4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Apr 2010 15:41:56 -0400
Message-ID: <4BB799FC.7010707@free.fr>
Date: Sat, 03 Apr 2010 21:41:48 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] fix dvb frontend lockup
References: <4BA603AB.6070809@free.fr> <4BAE810A.6030405@free.fr>
In-Reply-To: <4BAE810A.6030405@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

matthieu castet a écrit :
> matthieu castet a écrit :
>> Hi,
>>
>> With my current kernel (2.6.32), if my dvb device is removed while in 
>> use, I got [1].
>>
>> After checking the source code, the problem seems to happen also in 
>> master :
>>
>> If there are users (for example users == -2) :
>> - dvb_unregister_frontend :
>> - stop kernel thread with dvb_frontend_stop :
>>  - fepriv->exit = 1;
>>  - thread loop catch stop event and break while loop
>>  - fepriv->thread = NULL; and fepriv->exit = 0;
>> - dvb_unregister_frontend wait on "fepriv->dvbdev->wait_queue" that 
>> fepriv->dvbdev->users==-1.
>> The user finish :
>> - dvb_frontend_release - set users to -1
>> - don't wait wait_queue because fepriv->exit != 1
>>
>> => dvb_unregister_frontend never exit the wait queue.
>>
>>
>> Matthieu
>>
>>
>> [ 4920.484047] khubd         D c2008000     0   198      2 0x00000000
>> [ 4920.484056]  f64c8000 00000046 00000000 c2008000 00000004 c13fa000 
>> c13fa000 f
>> 64c8000
>> [ 4920.484066]  f64c81bc c2008000 00000000 d9d9dce6 00000452 00000001 
>> f64c8000 c
>> 102daad
>> [ 4920.484075]  00100100 f64c81bc 00000286 f0a7ccc0 f0913404 f0cba404 
>> f644de58 f
>> 092b0a8
>> [ 4920.484084] Call Trace:
>> [ 4920.484102]  [<c102daad>] ? default_wake_function+0x0/0x8
>> [ 4920.484147]  [<f8cb09e1>] ? dvb_unregister_frontend+0x95/0xcc 
>> [dvb_core]
>> [ 4920.484157]  [<c1044412>] ? autoremove_wake_function+0x0/0x2d
>> [ 4920.484168]  [<f8dd1af2>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 
>> [dvb_usb]
>> [ 4920.484176]  [<f8dd12f1>] ? dvb_usb_exit+0x26/0x88 [dvb_usb]
>> [ 4920.484184]  [<f8dd138d>] ? dvb_usb_device_exit+0x3a/0x4a [dvb_usb]
>> [ 4920.484217]  [<f7fe1b08>] ? usb_unbind_interface+0x3f/0xb4 [usbcore]
>> [ 4920.484227]  [<c11a4178>] ? __device_release_driver+0x74/0xb7
>> [ 4920.484233]  [<c11a4247>] ? device_release_driver+0x15/0x1e
>> [ 4920.484243]  [<c11a3a33>] ? bus_remove_device+0x6e/0x87
>> [ 4920.484249]  [<c11a26d6>] ? device_del+0xfa/0x152
>> [ 4920.484264]  [<f7fdf609>] ? usb_disable_device+0x59/0xb9 [usbcore]
>> [ 4920.484279]  [<f7fdb9ee>] ? usb_disconnect+0x70/0xdc [usbcore]
>> [ 4920.484294]  [<f7fdc728>] ? hub_thread+0x521/0xe1d [usbcore]
>> [ 4920.484301]  [<c1044412>] ? autoremove_wake_function+0x0/0x2d
>> [ 4920.484316]  [<f7fdc207>] ? hub_thread+0x0/0xe1d [usbcore]
>> [ 4920.484321]  [<c10441e0>] ? kthread+0x61/0x66
>> [ 4920.484327]  [<c104417f>] ? kthread+0x0/0x66
>> [ 4920.484336]  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
>>
> Here a patch that fix the issue
> 
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> 
Any news on that
