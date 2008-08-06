Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7637DhF031370
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 23:07:13 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7636wOG032334
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 23:06:59 -0400
Received: by ti-out-0910.google.com with SMTP id 24so1343942tim.7
	for <video4linux-list@redhat.com>; Tue, 05 Aug 2008 20:06:57 -0700 (PDT)
From: Worik <worik.stanton@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <1205053694.6188.312.camel@gloria.red.sld.cu>
References: <1205053694.6188.312.camel@gloria.red.sld.cu>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 15:06:48 +1200
Message-Id: <1217992008.8094.17.camel@kupe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Setting up a Xceive XC2028
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

On Sun, 2008-03-09 at 05:08 -0400, Maykel Moya wrote:
> device: Sabrent Mini Stick USB 2.0 TV Tuner (TV-USBST)
> url: http://www.sabrent.com/products/specs/TV-USBST.htm
> id: 6000:0001
> chip: TM5600

I have a USB TV-Tuner with the same USB ID as this.

The person who sold it to me said it is a "Xceive XC2028 silicon tuner".

There is nothing helpful on the box.

Poking around the driver disc I can find lots of information in .inf
files that I have no idea what it means.



I found this in mail to this list with subject:
Re: Problems setting up Sabrent Mini Stick USB 2.0 TV Tuner (TV-USBST)
6000:0001


> And lsusb -d 6000:0001 -v output is attached.
> 
> I have a stock Debian 2.6.24 kernel. This is what I did:
> 
> 1. hg clone http://.../v4l-dvb v4l-dvb-upstream
> 2. hg clone http://.../tm6010 tm6010-upstream
> 3. hg clone v4l-dvb-upstream v4l-dvb
> 4. cd v4l-dvb
> 5. hg fetch ../tm6010-upstream
>    (some minor issues with file 
>     linux/drivers/media/video/tuner-xc2028.c during merge)
> 6. make && sudo make install
> 7. cd ../tm6010-upstream
> 8. copy /from/install/cd/the/right/tridvid.sys .
> 9. perl get_firmware.pl

I do not know what "mercurial" is, but I tried this.  Line 2 fails.

worik@kupe:~/src/v4l-dvb$ hg clone http://linuxtv.org/hg/tm6010
tm6010-upstream 
abort: 'http://linuxtv.org/hg/tm6010' does not appear to be an hg
repository!

I would be grateful to be shown where to start.


cheers
Worik

-- 
The ladder of dreams was broken by the logic of many men, it was lynched
and burnt. Torn and hurt... The Lord of Dreams was angry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
