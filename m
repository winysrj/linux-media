Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6DJMace010693
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 15:22:36 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6DJLjw0002146
	for <video4linux-list@redhat.com>; Sun, 13 Jul 2008 15:21:47 -0400
Message-ID: <487A577F.8080300@hhs.nl>
Date: Sun, 13 Jul 2008 21:29:03 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Andrea <audetto@tiscali.it>
References: <487908CA.8000304@tiscali.it> <48790D29.1010404@hhs.nl>
	<4879E767.4000103@tiscali.it>
In-Reply-To: <4879E767.4000103@tiscali.it>
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

Andrea wrote:
> Hans de Goede wrote:
>> Andrea wrote:
>>
>> What kind of device, I think that for webcams you;re best using gspca, 
>> (now merged in mecurial), that handles all the usb specific stuff, 
>> buffer management, etc. In general it makes it easy to write a webcam 
>> driver allowing you to focus on the interaction with the cam, rather 
>> then having to worry about looking, usb specifics, buffer management etc.
>>
> 
> I've had a quick look at the structure of gspca, and it seems that any 
> subdriver should just (easier to say that to do) fill one of those 
> structures
> 

Correct.

> struct sd_desc {
> /* information */
>     const char *name;    /* sub-driver name */
> /* controls */
>     const struct ctrl *ctrls;
>     int nctrls;
> /* operations */
>     cam_cf_op config;    /* called on probe */
>     cam_op open;        /* called on open */
>     cam_v_op start;        /* called on stream on */
>     cam_v_op stopN;        /* called on stream off - main alt */
>     cam_v_op stop0;        /* called on stream off - alt 0 */
>     cam_v_op close;        /* called on close */
>     cam_pkt_op pkt_scan;
> /* optional operations */
>     cam_v_op dq_callback;    /* called when a frame has been dequeued */
>     cam_jpg_op get_jcomp;
>     cam_jpg_op set_jcomp;
>     cam_qmnu_op querymenu;
> };
> 
> 1) providing ctrls (+ functions to handle settings)
> 2) functions to open/stream/close etc...
> 
> It does not seem too bad.
> 

It isn't.

> The a natural question that comes to me:
> 
> Shouldn't many more USB drivers be implemented as subdrivers of gspca?

Yes that would remove lots of code duplication, but allas they were written 
before gspca (version 2, as you currently see in mercurial) was around.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
