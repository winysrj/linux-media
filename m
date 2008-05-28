Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4SM3mg7029666
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 18:03:48 -0400
Received: from QMTA04.emeryville.ca.mail.comcast.net
	(qmta04.emeryville.ca.mail.comcast.net [76.96.30.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4SM3aH8022145
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 18:03:36 -0400
Message-ID: <483DD6AA.1070203@personnelware.com>
Date: Wed, 28 May 2008 17:03:22 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <47C8A0C9.4020107@personnelware.com>	<20080304112519.6f4c748c@gaivota>	<483DBD67.8090508@personnelware.com>
	<20080528173755.594ea08b@gaivota>
In-Reply-To: <20080528173755.594ea08b@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] vivi: registered as /dev/video%d
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

Mauro Carvalho Chehab wrote:
> On Wed, 28 May 2008 15:15:35 -0500
> Carl Karsten <carl@personnelware.com> wrote:
> 
>> I posted a week ago and haven't heard anything.
> 
> I was on vacations last week.
> 
>>  How long should I wait before 
>> posting this? :)
> 
> There are a few issues on your patch:
> 
>> -		else
>> +            printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME,
>> dev->vfd->minor);
> 
> Your patch got word wrapped. So, it didn't apply.
> 
>> +        }
>> +		else {
> 
> CodingStyle is wrong. It should be:
> 	} else {
> 
> (at the same line)
> 
> Also, on some places, you used space, instead of tabs.
> 
> Please, check your patch with checkpatch.pl (or, inside Mercurial, make
> checkpatch) before sending it.
> 
> Also, be sure that your emailer won't add line breaks at the wrong places.
>>   	} else
>>   		printk(KERN_INFO "Video Technology Magazine Virtual Video "
>> -				 "Capture Board successfully loaded.\n");
>> +                 "Capture Board ver %u.%u.%u successfully loaded.\n",
>> +        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION &
>> 0xFF);

Fixed what you mentioned, make checkpatch doesn't report anything now.  It was 
reporting "warning: line over 80 characters" so now that those are fixed maybe 
t-bird won't wrap them.

 >
 > The indentation is very weird here.


Either the original code was weird ("quoted strings" were lined up) or a side 
effect of me using 4 space tabs.

If it still looks odd, I'll be happy to adjust.

------------------------------------------------------
Patch 1:
diff -r 9d04bba82511 linux/drivers/media/video/vivi.c
--- a/linux/drivers/media/video/vivi.c	Wed May 14 23:14:04 2008 +0000
+++ b/linux/drivers/media/video/vivi.c	Wed May 28 16:51:51 2008 -0500
@@ -48,6 +48,8 @@
  #include <linux/freezer.h>
  #endif

+#define MODULE_NAME "vivi"
+
  /* Wake up at about 30 fps */
  #define WAKE_NUMERATOR 30
  #define WAKE_DENOMINATOR 1001
@@ -56,7 +58,7 @@
  #include "font.h"

  #define VIVI_MAJOR_VERSION 0
-#define VIVI_MINOR_VERSION 4
+#define VIVI_MINOR_VERSION 5
  #define VIVI_RELEASE 0
  #define VIVI_VERSION \
  	KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
@@ -1086,10 +1088,15 @@ static int vivi_release(void)
  		list_del(list);
  		dev = list_entry(list, struct vivi_dev, vivi_devlist);

-		if (-1 != dev->vfd->minor)
+		if (-1 != dev->vfd->minor) {
  			video_unregister_device(dev->vfd);
-		else
+			printk(KERN_INFO "%s: /dev/video%d unregistered.\n",
+				MODULE_NAME, dev->vfd->minor);
+		} else {
  			video_device_release(dev->vfd);
+			printk(KERN_INFO "%s: /dev/video%d released.\n",
+				MODULE_NAME, dev->vfd->minor);
+		}

  		kfree(dev);
  	}
@@ -1202,6 +1209,8 @@ static int __init vivi_init(void)
  			video_nr++;

  		dev->vfd = vfd;
+		printk(KERN_INFO "%s: V4L2 device registered as /dev/video%d\n",
+			MODULE_NAME, vfd->minor);
  	}

  	if (ret < 0) {
@@ -1209,7 +1218,9 @@ static int __init vivi_init(void)
  		printk(KERN_INFO "Error %d while loading vivi driver\n", ret);
  	} else
  		printk(KERN_INFO "Video Technology Magazine Virtual Video "
-				 "Capture Board successfully loaded.\n");
+			"Capture Board ver %u.%u.%u successfully loaded.\n",
+			(VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF,
+			VIVI_VERSION & 0xFF);
  	return ret;
  }

------------------------------------------------------
Signed-off-by: Carl Karsten  <carl@personnelware.com>

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
