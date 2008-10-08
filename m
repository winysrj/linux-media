Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m98388dU005023
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 23:08:08 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9837vXj020057
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 23:07:57 -0400
Received: by rv-out-0506.google.com with SMTP id f6so3744610rvb.51
	for <video4linux-list@redhat.com>; Tue, 07 Oct 2008 20:07:57 -0700 (PDT)
Message-ID: <19619f3b0810072007h65733a1ekda49ae5eada73206@mail.gmail.com>
Date: Wed, 8 Oct 2008 07:07:57 +0400
From: OJ <olejl77@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <19619f3b0810060628w5dcea635t8ccb7aeae75d58d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19619f3b0810060628w5dcea635t8ccb7aeae75d58d7@mail.gmail.com>
Subject: Re: Problem with TT-Budget S-1500 DVB-S card (saa7146)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

>> quoting Oliver and Michael from the linux-dvb ML might help.
>>
>>
>>> Complain to the developers of the Audiowerk2 driver for this:
>>>
>>> | static struct pci_device_id snd_aw2_ids[] = {
>>> |       {PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID,
>>> PCI_ANY_ID,
>>> |        0, 0, 0},
>>> |       {0}
>>> | };
>>>
>>> This will grab _all_ saa7146-based cards. :-(
>>>
>>> For now you should blacklist that driver.
>>>
>>> CU
>>> Oliver
>>>
>>
>>
>>> Hi Tom,
>>>
>>> The name of module is snd_aw2. Just add it to
>>> the /etc/modprobe.d/blacklist
>>
>> Or remove it and "depmod -a".
>>
>> Cheers,
>> Hermann
>>
>>
>>

Thanks, that did the trick for me. I added snd_aw2 in
/etc/modprobe.d/blacklist, and restarted. Then everything was working.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
