Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUCV82a014826
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:31:08 -0500
Received: from QMTA09.westchester.pa.mail.comcast.net
	(qmta09.westchester.pa.mail.comcast.net [76.96.62.96])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUCUsWn020234
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 07:30:54 -0500
Message-ID: <495A1464.5040500@comcast.net>
Date: Tue, 30 Dec 2008 07:30:28 -0500
From: Gregg Germain <saville@comcast.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: xawtv and 64 bit LINUX systems...
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

Jackson Yee wrote:
 > Xawtv should work fine on 64 bit systems. I've got a gentoo-amd64
 > system doing fine with an ImpactVCB card.

 > If you're running Fedora, you probably already have Xawtv available 
 >through Yum:

Indeed it is available through the fedora repo!  I should have looked 
there first.  thank you very much!

I installed it but I can see I have much more work to do. I'm not sure 
what to do about these error messages:

[gregg@Ragnar ~]$ xawtv
This is xawtv-3.95, running on Linux/x86_64 (2.6.27.9-159.fc10.x86_64)
xinerama 0: 1280x1024+0+0
xinerama 1: 1280x1024+0+0
WARNING: No DGA direct video mode for this display.
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "7x13bold" to type FontStruct
Warning: Missing charsets in String to FontSet conversion
Warning: Missing charsets in String to FontSet conversion
Warning: Missing charsets in String to FontSet conversion
Oops: can't load any font

thanks!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
