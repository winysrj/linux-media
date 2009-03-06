Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47619 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZCFIMo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 03:12:44 -0500
Message-ID: <49B0DAF4.50408@redhat.com>
Date: Fri, 06 Mar 2009 09:12:36 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] for the file gspca/mr97310a.c
References: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu> <200903052258.48365.elyk03@gmail.com> <alpine.LNX.2.00.0903052317070.28734@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903052317070.28734@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Thu, 5 Mar 2009, Kyle Guinn wrote:
> 
>> On Thursday 05 March 2009 20:34:27 kilgota@banach.math.auburn.edu wrote:
>>> Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
>>> ----------------------------------------------------------------------
>>> --- mr97310a.c.old    2009-02-23 23:59:07.000000000 -0600
>>> +++ mr97310a.c    2009-03-05 19:14:13.000000000 -0600
>>> @@ -29,9 +29,7 @@ MODULE_LICENSE("GPL");
>>>   /* specific webcam descriptor */
>>>   struct sd {
>>>       struct gspca_dev gspca_dev;  /* !! must be the first item */
>>> -
>>>       u8 sof_read;
>>> -    u8 header_read;
>>>   };
>>>
>>>   /* V4L2 controls supported by the driver */
>>> @@ -100,12 +98,9 @@ static int sd_init(struct gspca_dev *gsp
>>>
>>>   static int sd_start(struct gspca_dev *gspca_dev)
>>>   {
>>> -    struct sd *sd = (struct sd *) gspca_dev;
>>>       __u8 *data = gspca_dev->usb_buf;
>>>       int err_code;
>>>
>>> -    sd->sof_read = 0;
>>> -
>>
>> Good catch, I didn't realize this was kzalloc'd.
> 
> Hmmm. Perhaps I cut too much and _that_ should go back in. What if one 
> stops the streaming and then restarts it? OTOH, one only risks losing 
> one frame. OTTH, one might really want that frame. I will put it back.
> 

Ack I was about to make a comment along the same lines, please put it back in.

>>
>>>       /* Note:  register descriptions guessed from MR97113A driver */
>>>
>>>       data[0] = 0x01;
>>> @@ -285,40 +280,29 @@ static void sd_pkt_scan(struct gspca_dev
>>>               __u8 *data,                   /* isoc packet */
>>>               int len)                      /* iso packet length */
>>>   {
>>> -    struct sd *sd = (struct sd *) gspca_dev;
>>>       unsigned char *sof;
>>>
>>>       sof = pac_find_sof(gspca_dev, data, len);
>>>       if (sof) {
>>>           int n;
>>> -
>>> +        int marker_len = sizeof pac_sof_marker;
>>
>> The value doesn't change; there's no need to use a variable for this.
> 
> True. I was just working for legibility, and trying to substitute a 
> shorter symbol for something which is long and cumbersome and screws up 
> 80-character lines. If it is bad to do that, then I can take it right 
> back out, of course.
> 
>>
>>>           /* finish decoding current frame */
>>>           n = sof - data;
>>> -        if (n > sizeof pac_sof_marker)
>>> -            n -= sizeof pac_sof_marker;
>>> +        if (n > marker_len)
>>> +            n -= marker_len;
>>>           else
>>>               n = 0;
>>>           frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
>>>                       data, n);
>>> -        sd->header_read = 0;
>>> -        gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>>> -        len -= sof - data;
>>> +        /* Start next frame. */
>>> +        gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
>>> +            pac_sof_marker, marker_len);
>>> +        len -= n;
>>> +        len -= marker_len;
>>> +        if (len < 0)
>>> +            len = 0;
>>
>> len -= sof - data; is a shorter way to find the remaining length.
> 
> Now, why did I try that and it did not work, but now it does? Weird. OK, 
> you are right.
> 

Actually, that is the right thing to do, as in cases where the frame only contained
the last part of a sof sequence, your code from the patch as send won't work.

<snip>

Regards,

Hans
