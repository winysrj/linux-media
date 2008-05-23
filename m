Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4NJhHh5001106
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:43:17 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4NJgsG1006670
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:42:54 -0400
Received: by an-out-0708.google.com with SMTP id d31so212106and.124
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 12:42:54 -0700 (PDT)
Message-ID: <4fd977fd0805231242u4b256706ladc2ee0dbaa72cc0@mail.gmail.com>
Date: Fri, 23 May 2008 21:42:54 +0200
From: "Vladimir Komendantsky" <komendantsky@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: how to obtain firmware for a tuner Xceive xc3028 ?
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

Hi,

Could you let me know please how to obtain xc3028-v25.fw for a tuner
71 (Xceive xc2028/xc3028) ?

Can the script extract_xc3028.pl in linux/Documentation/video4linux/
be used to obtain the firmware file xc3028-v25.fw ? Earlier mailing
list archives [v4l-dvb] suggest that this script was once used for that
purpose.

E.g., http://www.linuxtv.org/pipermail/linux-dvb/2008-February/023864.html

However, at the moment it produces the firmware v27 rather
than v25. My firmware seems to be contained in cx88vid.sys that is on
the windows driver CD of my Conexant-based card. That's another
difference with the extraction script which requires hcw85bda.sys.

--
Vladimir

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
