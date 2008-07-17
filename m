Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HLDBBn020319
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 17:13:11 -0400
Received: from vsmtp3.tin.it (vsmtp3.tin.it [212.216.176.223])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HLCvtG012697
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 17:12:58 -0400
Message-ID: <487FB55C.6000506@tiscali.it>
Date: Thu, 17 Jul 2008 22:10:52 +0100
From: Andrea <audetto@tiscali.it>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <487908CA.8000304@tiscali.it> <48790D29.1010404@hhs.nl>	
	<4879E767.4000103@tiscali.it> <487A577F.8080300@hhs.nl>
	<d9def9db0807170831h4fb42ba2v5a7ff38c762092f5@mail.gmail.com>
	<487F6676.1080403@hhs.nl>
In-Reply-To: <487F6676.1080403@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: prototype of a USB v4l2 driver? gspca?
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

Hans de Goede wrote:
> Markus Rechberger wrote:
>> On Sun, Jul 13, 2008 at 9:29 PM, Hans de Goede <j.w.r.degoede@hhs.nl> 
>>
>> I guess quite a few drivers have extra features which might be missing
>> in other usb based ones. Best is probably to have a look at all
>> available ones and cherry pick the best ideas and easiest to
>> understand parts.
>> I think they are all on a certain level of quality right now.
>>
>> * gspca
>> * uvcvideo
>> * em28xx from mcentral.de
>>
> 
> Well these 3 drivers (in case of gscpa driver group) target different 
> classes of hardware:
> gspca:     pre uvc webcams (and nothing more then that)
> uvcvideo:  uvc devices
> em28xx:    em28xx based devices, which can be dvd, analogtv, webcam, 
> etc, etc.
> 

I think my task is pretty limited to a webcam.
So I will start from gspca and try to work my way through it.
I am a bit scared by the size of em28xx, which seems to profide too many features for my level of 
understanding.

Andrea

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
