Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KIEnai006049
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 14:14:49 -0400
Received: from QMTA04.emeryville.ca.mail.comcast.net
	(qmta04.emeryville.ca.mail.comcast.net [76.96.30.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4KIEHfH023467
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 14:14:18 -0400
Message-ID: <483314EF.5050009@personnelware.com>
Date: Tue, 20 May 2008 13:14:07 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: xawtv "no fontset found"
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

Ubuntu hardy - guessing I need to install some font package?

$ sudo modprobe vivi

carl@dell29:~$ xawtv -c /dev/video0
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.24-16-generic)
xinerama 0: 1280x1024+0+0
xinerama 1: 1600x1200+1280+0
X Error of failed request:  XF86DGANoDirectVideoMode
   Major opcode of failed request:  136 (XFree86-DGA)
   Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
   Serial number of failed request:  13
   Current serial number in output stream:  13
v4l-conf had some trouble, trying to continue anyway
Warning: Missing charsets in String to FontSet conversion
Warning: Cannot convert string 
"-*-lucidatypewriter-bold-r-normal-*-14-*-*-*-m-*-iso8859-*, 
-*-courier-bold-r-normal-*-14-*-*-*-m-*-iso8859-*, 
-gnu-unifont-bold-r-normal--16-*-*-*-c-*-*-*, 
-efont-biwidth-bold-r-normal--16-*-*-*-*-*-*-*, 
-*-*-bold-r-normal-*-16-*-*-*-m-*-*-*, 
-*-*-bold-r-normal-*-16-*-*-*-c-*-*-*, 
-*-*-*-*-*-*-16-*-*-*-*-*-*-*,*" to type FontSet
Warning: Missing charsets in String to FontSet conversion
Warning: Unable to load any usable fontset
Warning: Missing charsets in String to FontSet conversion
Warning: Unable to load any usable fontset
Error: Aborting: no fontset found

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
