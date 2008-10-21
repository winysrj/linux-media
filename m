Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LE7gHC011490
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 10:07:42 -0400
Received: from unifiedpaging.messagenetsystems.com
	(www.emergencycommunicationsystems.com [24.123.23.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LE7WdX019361
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 10:07:32 -0400
Message-ID: <48FDE20F.3070407@messagenetsystems.com>
Date: Tue, 21 Oct 2008 10:07:11 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48FAA9A1.3090906@myecho.ca> <48FC9F9D.5030107@linuxtv.org>
	<48FCB570.2050906@messagenetsystems.com>
	<48FCCFA9.8060105@linuxtv.org>
In-Reply-To: <48FCCFA9.8060105@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: hvr950q analog support
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

Steven Toth wrote:
> Robert Vincent Krakora wrote:
>> Steven Toth wrote:
>>> Jacek Pawlowski wrote:
>>>> Hi,
>>>> The digital part for hvr950a works fine (driver au0828).  From 
>>>> other posts it looks like the analog part is nor ready yet.  Will 
>>>> be  the analog part for HVR950q (2040:7200) ready soon (or maybe it 
>>>> is already available and I just don't know how to set it up :-) - I 
>>>> am running 2.6.26.5-28.fc8 x86_64
>>>
>>> Nobody is working on analog support, as far as I know.
>>>
>>> - Steve
>>>
>>> -- 
>>> video4linux-list mailing list
>>> Unsubscribe 
>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>>
>> I have both the HVR950 and HVR950Q.  Analog works fine on the HVR950 
>> as does terrestrial digital (8VSB ATSC).  However, on the HVR950Q 
>> only digital works for both terrestrial (8VSB ATSC) and cable 
>> (QAM256).  Are there any plans to have someone work on analog for the 
>> HVR950Q?
>>
>
> I repeat my earlier HVR950Q statement: Nobody is working on analog 
> support, as far as I know.
>
> - Steve
>
>
Steve:

I will take a look at it here shortly.  I am going to have some time and 
I have a need to get analog going with the HVR950Q. ;-)

Best Regards,
-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
