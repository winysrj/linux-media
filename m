Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab0ESIpu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 04:45:50 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4J8joUu003470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 19 May 2010 04:45:50 -0400
Message-ID: <4BF3A4BA.1070002@redhat.com>
Date: Wed, 19 May 2010 14:13:38 +0530
From: Huzaifa Sidhpurwala <huzaifas@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [Patch] Moving v4l1 ioctls from kernel to libv4l1
References: <4BF27601.8010207@redhat.com> <4BF27A5E.5060705@redhat.com>
In-Reply-To: <4BF27A5E.5060705@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thanks a lot for the review, here is the improved version.


diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
index eae3b43..9ef9980 100644
- --- a/lib/libv4l1/libv4l1.c
+++ b/lib/libv4l1/libv4l1.c
@@ -61,6 +61,10 @@
 #define V4L1_PIX_FMT_TOUCHED    0x04
 #define V4L1_PIX_SIZE_TOUCHED   0x08

+#ifndef min
+    #define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
+#endif
+
 static pthread_mutex_t v4l1_open_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct v4l1_dev_info devices[V4L1_MAX_DEVICES] = {
 	{ .fd = -1 },
@@ -130,6 +134,19 @@ static unsigned int pixelformat_to_palette(unsigned
int pixelformat)
 	return 0;
 }

+static int count_inputs(int fd)
+{
+	struct v4l2_input input2;
+	int i;
+	for (i = 0;; i++) {
+		memset(&input2, 0, sizeof(input2));
+		input2.index = i;
+		if (0 != SYS_IOCTL(fd, VIDIOC_ENUMINPUT, &input2))
+			break;
+		}
+	return i;
+}
+
 static int v4l1_set_format(int index, unsigned int width,
 		unsigned int height, int v4l1_pal, int width_height_may_differ)
 {
@@ -491,16 +508,46 @@ int v4l1_ioctl(int fd, unsigned long int request, ...)
 	switch (request) {
 	case VIDIOCGCAP: {
 		struct video_capability *cap = arg;
+		
+		struct v4l2_framebuffer fbuf = { 0, };
+		struct v4l2_capability cap2 =  { 0, };

- -		result = SYS_IOCTL(fd, request, arg);
+		result = SYS_IOCTL(fd, VIDIOC_QUERYCAP,&cap2);
+		if (result < 0)
+			break;
+
+		if (cap2.capabilities & V4L2_CAP_VIDEO_OVERLAY) {
+			result = SYS_IOCTL(fd, VIDIOC_G_FBUF, &fbuf);
+			if (result < 0) {
+				memset(&fbuf, 0, sizeof(fbuf));
+			}
+			result = 0;
+		}
+		
+		memcpy(cap->name,  cap2.card, min(sizeof(cap->name),sizeof(cap2.card)) );
+		
+		cap->name[sizeof(cap->name) -1 ] = 0;
+	
+		if (cap2.capabilities & V4L2_CAP_VIDEO_CAPTURE)
+			cap->type |= VID_TYPE_CAPTURE;
+		if (cap2.capabilities & V4L2_CAP_TUNER)
+			cap->type |= VID_TYPE_TUNER;
+		if (cap2.capabilities & V4L2_CAP_VBI_CAPTURE)
+			cap->type |= VID_TYPE_TELETEXT;
+		if (cap2.capabilities & V4L2_CAP_VIDEO_OVERLAY)
+			cap->type |= VID_TYPE_OVERLAY;
+		if (fbuf.capability & V4L2_FBUF_CAP_LIST_CLIPPING)
+			cap->type |= VID_TYPE_CLIPPING;
+
+		cap->channels = count_inputs(fd);

- -		/* override kernel v4l1 compat min / max size with our own more
- -		   accurate values */
 		cap->minwidth  = devices[index].min_width;
 		cap->minheight = devices[index].min_height;
 		cap->maxwidth  = devices[index].max_width;
 		cap->maxheight = devices[index].max_height;
+
 		break;
+
 	}

 	case VIDIOCSPICT: {




Hans de Goede wrote:
> Hi Huzaifa,
> 
> First of all many thanks for working on this!
> 
> Comments inline.
> 
> On 05/18/2010 01:12 PM, Huzaifa Sidhpurwala wrote:
>> Hi All,
>> I have been working with Hans for moving the v4l1 ioctls from the kernel
>> to libv4l1.
>> It would be best to work on one ioctl at a time.
>> The enclosed patch attempts to implement VIDIOCGCAP in the libv4l1.
>>
>> Note: Hans is working with Bill, asking for permission to re-use the
>> v4l1-compat.c code under the LGPL
>>
>>
>>
>> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
>> index eae3b43..8571651 100644
>> --- a/lib/libv4l1/libv4l1.c
>> +++ b/lib/libv4l1/libv4l1.c
>> @@ -61,6 +61,10 @@
>>   #define V4L1_PIX_FMT_TOUCHED    0x04
>>   #define V4L1_PIX_SIZE_TOUCHED   0x08
>>
>> +#ifndef min
>> +    #define min( a, b ) ( ((a)<  (b)) ? (a) : (b) )
>> +#endif
>> +
>>   static pthread_mutex_t v4l1_open_mutex = PTHREAD_MUTEX_INITIALIZER;
>>   static struct v4l1_dev_info devices[V4L1_MAX_DEVICES] = {
>>       { .fd = -1 },
>> @@ -130,6 +134,45 @@ static unsigned int pixelformat_to_palette(unsigned
>> int pixelformat)
>>       return 0;
>>   }
>>
>> +static int count_inputs(int fd)
>> +{
>> +    struct v4l2_input input2;
>> +    int i;
>> +    for (i = 0;; i++) {
>> +        memset(&input2, 0, sizeof(input2));
>> +        input2.index = i;
>> +        if (0 != SYS_IOCTL(fd, VIDIOC_ENUMINPUT,&input2))
>> +            break;
>> +        }
>> +    return i;
>> +}
>> +
>> +static int check_size(int fd,int *maxw,int *maxh)
>> +{
>> +    struct v4l2_fmtdesc desc2;
>> +    struct v4l2_format fmt2;
>> +
>> +    memset(&desc2, 0, sizeof(desc2));
>> +    memset(&fmt2, 0, sizeof(fmt2));
>> +
>> +    desc2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +    if (0 != SYS_IOCTL(fd, VIDIOC_ENUM_FMT,&desc2))
>> +        goto done;
>> +
>> +    fmt2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +    fmt2.fmt.pix.width = 10000;
>> +    fmt2.fmt.pix.height = 10000;
>> +    fmt2.fmt.pix.pixelformat = desc2.pixelformat;
>> +    if (0 != SYS_IOCTL(fd, VIDIOC_TRY_FMT,&fmt2))
>> +        goto done;
>> +
>> +    *maxw = fmt2.fmt.pix.width;
>> +    *maxh = fmt2.fmt.pix.height;
>> +
>> +    done:
>> +    return 0;
>> +}
>> +
> 
> We don't need this function, see below.
> 
>>   static int v4l1_set_format(int index, unsigned int width,
>>           unsigned int height, int v4l1_pal, int width_height_may_differ)
>>   {
>> @@ -492,7 +535,54 @@ int v4l1_ioctl(int fd, unsigned long int request,
>> ...)
>>       case VIDIOCGCAP: {
>>           struct video_capability *cap = arg;
>>
>> -        result = SYS_IOCTL(fd, request, arg);
>> +        long err;
>> +        struct v4l2_framebuffer fbuf;
>> +        struct v4l2_capability *cap2;
> 
> The kernel mallocs struct v4l2_capability because the kernel
> stack is severely limited, no need to do that in userspace, just
> put the entire struct on the stack.
> 
>> +
>> +        cap2 = malloc (sizeof(*cap2));
>> +        if (!cap2) {
>> +            return -ENOMEM;
>> +        }
>> +
>> +        memset(cap,0,sizeof(*cap));
>> +        memset(&fbuf, 0, sizeof(fbuf));
>> +
> 
> You can get the memset effect, by initalizing the first field of the
> struct to 0, the compiler will then 0 out the rest:
>         struct v4l2_framebuffer fbuf = { 0, };
>         struct v4l2_capability cap2 =  { 0, };
> 
> 
>> +        err = SYS_IOCTL(fd, VIDIOC_QUERYCAP,cap2);
>> +        if (err<  0)
>> +            goto done;
>> +
>> +        if (cap2->capabilities&  V4L2_CAP_VIDEO_OVERLAY) {
>> +            err = SYS_IOCTL(fd, VIDIOC_G_FBUF,&fbuf);
>> +            if (err<  0) {
>> +                memset(&fbuf, 0, sizeof(fbuf));
>> +            }
>> +            err = 0;
>> +        }
>> +       
>> +        memcpy(cap->name,  cap2->card,
>> min(sizeof(cap->name),sizeof(cap2->card)) );
>> +       
>> +        cap->name[sizeof(cap->name) -1 ] = 0;
>> +   
>> +        if (cap2->capabilities&  V4L2_CAP_VIDEO_CAPTURE)
>> +            cap->type |= VID_TYPE_CAPTURE;
>> +        if (cap2->capabilities&  V4L2_CAP_TUNER)
>> +            cap->type |= VID_TYPE_TUNER;
>> +        if (cap2->capabilities&  V4L2_CAP_VBI_CAPTURE)
>> +            cap->type |= VID_TYPE_TELETEXT;
>> +        if (cap2->capabilities&  V4L2_CAP_VIDEO_OVERLAY)
>> +            cap->type |= VID_TYPE_OVERLAY;
>> +        if (fbuf.capability&  V4L2_FBUF_CAP_LIST_CLIPPING)
>> +            cap->type |= VID_TYPE_CLIPPING;
>> +
>> +        cap->channels = count_inputs(fd);
>> +
>> +        check_size(fd,
>> +            &cap->maxwidth,&cap->maxheight);
>> +                   
> 
> No need to check size here, as we override that below, so this line can
> be dropped.
> 
>> +       
>> +    /*    result = SYS_IOCTL(fd, request, arg);*/
>> +
> 
> This can be dropped too.
> 
>> +
>>
>>           /* override kernel v4l1 compat min / max size with our own more
>>              accurate values */
> 
> And the override comment can be dropped to, as we no longer will be
> suing the v4l1 compat code check_size stuff.
> 
>> @@ -500,7 +590,10 @@ int v4l1_ioctl(int fd, unsigned long int request,
>> ...)
>>           cap->minheight = devices[index].min_height;
>>           cap->maxwidth  = devices[index].max_width;
>>           cap->maxheight = devices[index].max_height;
>> -        break;
>> +
>> +        done:
>> +            free(cap2);
>> +            break;
>>       }
> 
> No need to do this either when we drop the malloc.
> 
>>
>>       case VIDIOCSPICT: {
>>
> 
> Thanks & Regards,
> 
> Hans


- --
Regards,
Huzaifa Sidhpurwala, RHCE, CCNA (IRC: huzaifas)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Red Hat - http://enigmail.mozdev.org/

iD8DBQFL86S5zHDc8tpb2uURAkJHAJ4vMGhdJNcgD9rFaZUtMqQvo80KsACfbSuv
KrcNL6YjjUi7kchPHJ8gV84=
=aRtx
-----END PGP SIGNATURE-----
