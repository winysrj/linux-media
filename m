Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3KGAXdE023002
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 12:10:33 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3KGAEAX024463
	for <video4linux-list@redhat.com>; Sun, 20 Apr 2008 12:10:20 -0400
Message-ID: <480B6AD8.9090404@linuxtv.org>
Date: Sun, 20 Apr 2008 12:10:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080420122736.20d60eff@the-village.bc.nu>
	<200804201806.33464.hverkuil@xs4all.nl>
In-Reply-To: <200804201806.33464.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Frank Bennett <biercenator@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
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

Hans Verkuil wrote:
> On Sunday 20 April 2008 13:27:36 Alan Cox wrote:
>   
>> Frank Bennett reported that ivtv was causing skype to crash. With
>> help from one of their developers he showed it was a kernel problem.
>> VIDIOCGCAP copies a name into a fixed length buffer - ivtv uses names
>> that are too long and does not truncate them so corrupts a few bytes
>> of the app data area.
>>
>> Possibly the names also want trimming but for now this should fix the
>> corruption case.
>>     
>
> Ouch, nasty one.
>
> Mauro, can you apply this patch to the v4l-dvb master?
>
> Mike, this one should obviously go into a 2.6.25 dot-release, and I 
> think also to a 2.6.24 dot-release.
>
> Frank, thank you for reporting this!
>
> 	Hans
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>   

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>


Mauro,

I'll get this into -stable for 2.6.24.y and 2.6.25.y as soon as it's in Linus' tree.  Please send this with your first round of patches for 2.6.26

Regards,

Mike







>   
>> Signed-off-by: Alan Cox <alan@redhat.com>
>>
>> ---
>> linux.vanilla-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	20
>> 08-04-13 15:36:53.000000000 +0100 +++
>> linux-2.6.25-rc8-mm2/drivers/media/video/ivtv/ivtv-ioctl.c	2008-04-20
>> 12:15:33.000000000 +0100 @@ -742,7 +742,8 @@
>>
>>  		memset(vcap, 0, sizeof(*vcap));
>>  		strcpy(vcap->driver, IVTV_DRIVER_NAME);     /* driver name */
>> -		strcpy(vcap->card, itv->card_name); 	    /* card type */
>> +		strncpy(vcap->card, itv->card_name,
>> +				sizeof(vcap->card)-1); 	    /* card type */
>>  		strcpy(vcap->bus_info, pci_name(itv->dev)); /* bus info... */
>>  		vcap->version = IVTV_DRIVER_VERSION; 	    /* version */
>>  		vcap->capabilities = itv->v4l2_cap; 	    /* capabilities */
>>
>> --
>> 		"Hello, welcome to Jon Masters' house of pain"
>> 				- Jon after a particularly good night
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>     
>
>
>   

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
