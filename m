Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBUGmIkt005340
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 11:48:18 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBUGlCnA008144
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 11:47:32 -0500
Received: by wa-out-1112.google.com with SMTP id j4so2955298wah.19
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 08:47:11 -0800 (PST)
Message-ID: <26aa882f0812300847w74a20297ga969272152216d67@mail.gmail.com>
Date: Tue, 30 Dec 2008 11:47:11 -0500
From: "Jackson Yee" <jackson@gotpossum.com>
To: "Gregg Germain" <saville@comcast.net>
In-Reply-To: <495A1464.5040500@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495A1464.5040500@comcast.net>
Cc: video4linux-list@redhat.com
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

Yes, that's a common error with XawTV. Try

xawtv -nodga

to disable dga and see what you get.

If your card is capable of higher resolutions than 320x240, you should
try TVTime as well. TVTime is capable of a much nicer picture than
XawTV, but will not work with more limited cards.

Regards,
Jackson Yee
The Possum Company
540-818-4079
me@gotpossum.com

On Tue, Dec 30, 2008 at 7:30 AM, Gregg Germain <saville@comcast.net> wrote:
> Indeed it is available through the fedora repo!  I should have looked there
> first.  thank you very much!
>
> I installed it but I can see I have much more work to do. I'm not sure what
> to do about these error messages:
>
> [gregg@Ragnar ~]$ xawtv
> This is xawtv-3.95, running on Linux/x86_64 (2.6.27.9-159.fc10.x86_64)
> xinerama 0: 1280x1024+0+0
> xinerama 1: 1280x1024+0+0
> WARNING: No DGA direct video mode for this display.
> /dev/video0 [v4l2]: no overlay support
> v4l-conf had some trouble, trying to continue anyway
> Warning: Cannot convert string "7x13bold" to type FontStruct
> Warning: Missing charsets in String to FontSet conversion
> Warning: Missing charsets in String to FontSet conversion
> Warning: Missing charsets in String to FontSet conversion
> Oops: can't load any font

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
