Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HFZBms026450
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:35:11 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HFYv4R003642
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:34:57 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJVVQ-0001is-VD
	for video4linux-list@redhat.com; Thu, 17 Jul 2008 17:34:57 +0200
Received: from [145.52.8.13] (port=42319 helo=hhs.nl)
	by frosty.hhs.nl with esmtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KJVVQ-0001im-NH
	for video4linux-list@redhat.com; Thu, 17 Jul 2008 17:34:56 +0200
Message-ID: <487F6676.1080403@hhs.nl>
Date: Thu, 17 Jul 2008 17:34:14 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <487908CA.8000304@tiscali.it> <48790D29.1010404@hhs.nl>	
	<4879E767.4000103@tiscali.it> <487A577F.8080300@hhs.nl>
	<d9def9db0807170831h4fb42ba2v5a7ff38c762092f5@mail.gmail.com>
In-Reply-To: <d9def9db0807170831h4fb42ba2v5a7ff38c762092f5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrea <audetto@tiscali.it>, video4linux-list@redhat.com
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

Markus Rechberger wrote:
> On Sun, Jul 13, 2008 at 9:29 PM, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
>> Andrea wrote:
>>> Hans de Goede wrote:
>>>> Andrea wrote:
>>>>
>>>> What kind of device, I think that for webcams you;re best using gspca,
>>>> (now merged in mecurial), that handles all the usb specific stuff, buffer
>>>> management, etc. In general it makes it easy to write a webcam driver
>>>> allowing you to focus on the interaction with the cam, rather then having to
>>>> worry about looking, usb specifics, buffer management etc.
>>>>
>>> I've had a quick look at the structure of gspca, and it seems that any
>>> subdriver should just (easier to say that to do) fill one of those
>>> structures
>>>
>> Correct.
>>
>>> struct sd_desc {
>>> /* information */
>>>    const char *name;    /* sub-driver name */
>>> /* controls */
>>>    const struct ctrl *ctrls;
>>>    int nctrls;
>>> /* operations */
>>>    cam_cf_op config;    /* called on probe */
>>>    cam_op open;        /* called on open */
>>>    cam_v_op start;        /* called on stream on */
>>>    cam_v_op stopN;        /* called on stream off - main alt */
>>>    cam_v_op stop0;        /* called on stream off - alt 0 */
>>>    cam_v_op close;        /* called on close */
>>>    cam_pkt_op pkt_scan;
>>> /* optional operations */
>>>    cam_v_op dq_callback;    /* called when a frame has been dequeued */
>>>    cam_jpg_op get_jcomp;
>>>    cam_jpg_op set_jcomp;
>>>    cam_qmnu_op querymenu;
>>> };
>>>
>>> 1) providing ctrls (+ functions to handle settings)
>>> 2) functions to open/stream/close etc...
>>>
>>> It does not seem too bad.
>>>
>> It isn't.
>>
>>> The a natural question that comes to me:
>>>
>>> Shouldn't many more USB drivers be implemented as subdrivers of gspca?
>> Yes that would remove lots of code duplication, but allas they were written
>> before gspca (version 2, as you currently see in mercurial) was around.
>>
> 
> I guess quite a few drivers have extra features which might be missing
> in other usb based ones. Best is probably to have a look at all
> available ones and cherry pick the best ideas and easiest to
> understand parts.
> I think they are all on a certain level of quality right now.
> 
> * gspca
> * uvcvideo
> * em28xx from mcentral.de
> 

Well these 3 drivers (in case of gscpa driver group) target different classes 
of hardware:
gspca:     pre uvc webcams (and nothing more then that)
uvcvideo:  uvc devices
em28xx:    em28xx based devices, which can be dvd, analogtv, webcam, etc, etc.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
