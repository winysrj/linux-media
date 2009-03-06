Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:49842 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZCFG3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 01:29:15 -0500
Date: Fri, 6 Mar 2009 00:41:34 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] for the file gspca/mr97310a.c
In-Reply-To: <200903052258.48365.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903052317070.28734@banach.math.auburn.edu>
References: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu> <200903052258.48365.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Kyle Guinn wrote:

> On Thursday 05 March 2009 20:34:27 kilgota@banach.math.auburn.edu wrote:
>> Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
>> ----------------------------------------------------------------------
>> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
>> +++ mr97310a.c	2009-03-05 19:14:13.000000000 -0600
>> @@ -29,9 +29,7 @@ MODULE_LICENSE("GPL");
>>   /* specific webcam descriptor */
>>   struct sd {
>>   	struct gspca_dev gspca_dev;  /* !! must be the first item */
>> -
>>   	u8 sof_read;
>> -	u8 header_read;
>>   };
>>
>>   /* V4L2 controls supported by the driver */
>> @@ -100,12 +98,9 @@ static int sd_init(struct gspca_dev *gsp
>>
>>   static int sd_start(struct gspca_dev *gspca_dev)
>>   {
>> -	struct sd *sd = (struct sd *) gspca_dev;
>>   	__u8 *data = gspca_dev->usb_buf;
>>   	int err_code;
>>
>> -	sd->sof_read = 0;
>> -
>
> Good catch, I didn't realize this was kzalloc'd.

Hmmm. Perhaps I cut too much and _that_ should go back in. What if one 
stops the streaming and then restarts it? OTOH, one only risks losing one 
frame. OTTH, one might really want that frame. I will put it back.

>
>>   	/* Note:  register descriptions guessed from MR97113A driver */
>>
>>   	data[0] = 0x01;
>> @@ -285,40 +280,29 @@ static void sd_pkt_scan(struct gspca_dev
>>   			__u8 *data,                   /* isoc packet */
>>   			int len)                      /* iso packet length */
>>   {
>> -	struct sd *sd = (struct sd *) gspca_dev;
>>   	unsigned char *sof;
>>
>>   	sof = pac_find_sof(gspca_dev, data, len);
>>   	if (sof) {
>>   		int n;
>> -
>> +		int marker_len = sizeof pac_sof_marker;
>
> The value doesn't change; there's no need to use a variable for this.

True. I was just working for legibility, and trying to substitute a 
shorter symbol for something which is long and cumbersome and screws up 
80-character lines. If it is bad to do that, then I can take it right back 
out, of course.

>
>>   		/* finish decoding current frame */
>>   		n = sof - data;
>> -		if (n > sizeof pac_sof_marker)
>> -			n -= sizeof pac_sof_marker;
>> +		if (n > marker_len)
>> +			n -= marker_len;
>>   		else
>>   			n = 0;
>>   		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
>>   					data, n);
>> -		sd->header_read = 0;
>> -		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>> -		len -= sof - data;
>> +		/* Start next frame. */
>> +		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
>> +			pac_sof_marker, marker_len);
>> +		len -= n;
>> +		len -= marker_len;
>> +		if (len < 0)
>> +			len = 0;
>
> len -= sof - data; is a shorter way to find the remaining length.

Now, why did I try that and it did not work, but now it does? Weird. OK, 
you are right.

>
>>   		data = sof;
>>   	}
>> -	if (sd->header_read < 7) {
>> -		int needed;
>> -
>> -		/* skip the rest of the header */
>> -		needed = 7 - sd->header_read;
>> -		if (len <= needed) {
>> -			sd->header_read += len;
>> -			return;
>> -		}
>> -		data += needed;
>> -		len -= needed;
>> -		sd->header_read = 7;
>> -	}
>> -
>>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>>   }
>>
>> @@ -337,6 +321,7 @@ static const struct sd_desc sd_desc = {
>>   /* -- module initialisation -- */
>>   static const __devinitdata struct usb_device_id device_table[] = {
>>   	{USB_DEVICE(0x08ca, 0x0111)},
>> +	{USB_DEVICE(0x093a, 0x010f)},
>
> This change is unrelated; maybe it should be in a different patch?

Suspecting that the main business of this patch is more urgent, I will 
just take the other camera out, in that case. Then that is the next patch.

Don't
> forget to update Documentation/video4linux/gspca.txt with the new camera.

Interesting. Sometimes previous experience is not a good guide. What I 
learned is that one does not mess with someone else's stuff, 
without consulting with the person who is (at least informally) in charge 
of it, usually the person who wrote it. Example: In libgphoto2 I can add 
a camera driver any time I want, and I could in theory go and mess with 
any code anywhere in the tree, because I have commit privileges. But if 
someone else is specializing in X (for example X = project documentation) 
I will make suggestions to him, not just go and mess around in his work.

By analogy, I would not have even dreamed of going over into 
linux/Documentation and started to mess with the contents of gspca.txt. I 
am "over here" working on the code. So, gspca is a new project for me and 
I see that things are done differently.

So, what you are also reminding me, is that it is my duty to do that for 
the SQ905C cameras, too, which I did not do at all in the patch for them! 
Or is that a bit different because I did not hear anything back about that 
yet? I wonder. Perhaps what could happen is that the patch is not accepted 
because it is incomplete because I did not submit any patch for gspca.txt 
to add three USB ids and the name of the module, and I was not doing that 
because by previous experience I would have thought that gspca.txt is none 
of my business to go and edit, unless I am specifically asked. So perhaps 
I am caught with Catch 22.

Too late to finish this tonight. So, tomorrow.


Theodore Kilgore
