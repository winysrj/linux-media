Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1N8r6dc019236
	for <video4linux-list@redhat.com>; Mon, 23 Feb 2009 03:53:06 -0500
Received: from yourtal3.yourtal.com (yourtal3.yourtal.com [209.172.44.134])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n1N8qoIl025758
	for <video4linux-list@redhat.com>; Mon, 23 Feb 2009 03:52:50 -0500
Message-ID: <45D5B97D758F44558CCD49387F0221A0@W1>
From: "Sergei Antonov" <sa@sa.pp.ru>
To: "CityK" <cityk@rogers.com>
References: <F13ADD43ECED4C45A8BE7A74E5B02BFE@W1> <49A1BA50.4090201@rogers.com>
In-Reply-To: <49A1BA50.4090201@rogers.com>
Date: Mon, 23 Feb 2009 11:52:36 +0300
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Genius Look 317
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

> Sergei Antonov wrote:
>> Hi!
>> I'm trying to make 'Genius Look 317' (0c45:60b0, gspca recognizes it)
>> webcam work.
>>
>> v4lgrab.c (from linux-2.6.28.5\Documentation\video4linux) loops
>> infinitely in this code:
>>
>>  do {
>>    int newbright;
>>    read(fd, buffer, win.width * win.height * bpp);
>>    f = get_brightness_adj(buffer, win.width * win.height, &newbright);
>>    if (f) {
>>      vpic.brightness += (newbright << 8);
>>      if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
>>        perror("VIDIOSPICT");
>>        break;
>>      }
>>    }
>>  } while (f);
>>
>> because variable 'f' is always non-zero.
>> If I write 'while(0);' the resulting .ppm contains some random pixels
>> in the top and the rest of the picture is black.
>> Need help.
> 
> Hi, I'd re-title your message to include the fact that its a gspca based
> webcam (to attract those developers attention) and send it off to the
> linux-media mailing list (which is where discussion is transitioning to:
> http://www.linuxtv.org/news.php?entry=2009-01-06.mchehab)

Thank you for the advice. But I've already found a solution. V4L2 API works for this webcam.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
