Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56EWUZx016144
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 10:32:30 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56EWGMt028385
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 10:32:17 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1K4czH-0000S2-KC
	for video4linux-list@redhat.com; Fri, 06 Jun 2008 16:32:15 +0200
Message-ID: <48494770.7060503@hhs.nl>
Date: Fri, 06 Jun 2008 16:19:28 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
References: <484934FD.1080401@hhs.nl>
	<200806061519.50350.laurent.pinchart@skynet.be>
In-Reply-To: <200806061519.50350.laurent.pinchart@skynet.be>
Content-Type: multipart/mixed; boundary="------------060201070200060705090302"
Cc: video4linux-list@redhat.com, spca50x-devs@lists.sourceforge.net,
	Elmar Kleijn <elmar_kleijn@hotmail.com>,
	"need4weed@gmail.com" <need4weed@gmail.com>
Subject: uvc open/close race (Was Re: v4l1 compat wrapper version 0.3)
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

This is a multi-part message in MIME format.
--------------060201070200060705090302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 06 June 2008 15:00, Hans de Goede wrote:
>> Hi All,
>>
>> Ok, this one _really_ works with ekiga (and still works fine with spcaview)
>> and also works with camorama with selected cams (not working on some cams
>> due to a camorama bug).
>>
>> Changes:
>> * Don't allow multiple opens, in theory our code can handle it, but not all
>>    v4l2 devices like it (ekiga does it and uvc doesn't like it).
> 
> Could you please elaborate ? Have you noticed a bug in the UVC driver ? It 
> should support multiple opens.

A good question, which I kinda knew I had coming. So now it has been asked I've 
spend some time tracking this down. There seems to be an open/close race 
somewhere in the UVC driver, ekiga does many open/close cycles in quick 
succession during probing.

It seems my no multiple opens code slows it down just enough to stop the race, 
but indeed multiple opens does not seem to be the real problem.

I've attached a program which reproduces it. I've commented out the fork as 
that does not seem necessary to reproduce this, just very quickly doing
open/some-io/close, open/some-io/close seems to be enough to trigger this, here 
is the output on my machine:

[hans@localhost v4l1-compat-0.4]$ ./test
[hans@localhost v4l1-compat-0.4]$ ./test
[hans@localhost v4l1-compat-0.4]$ ./test
[hans@localhost v4l1-compat-0.4]$ ./test
TRY_FMT 2: Input/output error
[hans@localhost v4l1-compat-0.4]$ ./test
TRY_FMT 1: Input/output error
[hans@localhost v4l1-compat-0.4]$ ./test
TRY_FMT 1: Input/output error
[hans@localhost v4l1-compat-0.4]$ ./test
TRY_FMT 1: Input/output error
[hans@localhost v4l1-compat-0.4]$

Notice how after the first time it gets the I/O error, it never recovers and 
from now on every first TRY_FMT fails.

Some notes:
1) TRY_FMT should really never do I/O (but then I guess the
    problem would still persists with S_FMT)
2) I've also seen it fail at TRY_FMT 1 without first failing
    a TRY_FMT 2, I guess that was just me doing arrow-up -> enter to quickly :)

Regards,

Hans

--------------060201070200060705090302
Content-Type: text/plain;
 name="test.c"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="test.c"

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPGVycm5v
Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxz
eXNjYWxsLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4L3ZpZGVv
ZGV2Mi5oPgoKaW50IG1haW4odm9pZCkKewogIGludCBmZDsKICBwaWRfdCBwaWQ7CiAgc3Ry
dWN0IHY0bDJfZm9ybWF0IGZtdDIgPSB7IC50eXBlID0gVjRMMl9CVUZfVFlQRV9WSURFT19D
QVBUVVJFIH07CiAgCiAgZmQgPSBvcGVuKCIvZGV2L3ZpZGVvMCIsIE9fUkRPTkxZKTsKICBp
ZiAoZmQgPT0gLTEpIHsKICAgIHBlcnJvcigib3BlbiAxIik7CiAgICByZXR1cm4gMTsKICB9
CgogIGlmIChzeXNjYWxsKFNZU19pb2N0bCwgZmQsIFZJRElPQ19HX0ZNVCwgJmZtdDIpKSB7
CiAgICBwZXJyb3IoIkdfRk1UIDEiKTsKICAgIHJldHVybiAxOwogIH0KICAgICAgCiAgaWYg
KHN5c2NhbGwoU1lTX2lvY3RsLCBmZCwgVklESU9DX1RSWV9GTVQsICZmbXQyKSkgewogICAg
cGVycm9yKCJUUllfRk1UIDEiKTsKICAgIHJldHVybiAxOwogIH0KCiAgaWYgKHN5c2NhbGwo
U1lTX2lvY3RsLCBmZCwgVklESU9DX1NfRk1ULCAmZm10MikpIHsKICAgIHBlcnJvcigiU19G
TVQgMSIpOwogICAgcmV0dXJuIDE7CiAgfQoKLyogIHBpZCA9IGZvcmsoKTsKICBpZiAocGlk
ID09IC0xKSB7CiAgICBwZXJyb3IoImZvcmsiKTsKICAgIHJldHVybiAxOwogIH0KICAKICBp
ZiAoIXBpZCkgewogICAgY2xvc2UoZmQpOwogIH0gZWxzZSAqLyB7CiAgICBjbG9zZShmZCk7
CiAgICBmZCA9IG9wZW4oIi9kZXYvdmlkZW8wIiwgT19SRE9OTFkpOwogICAgaWYgKGZkID09
IC0xKSB7CiAgICAgIHBlcnJvcigib3BlbiAyIik7CiAgICAgIHJldHVybiAxOwogICAgfQoK
ICAgIGlmIChzeXNjYWxsKFNZU19pb2N0bCwgZmQsIFZJRElPQ19HX0ZNVCwgJmZtdDIpKSB7
CiAgICAgIHBlcnJvcigiR19GTVQgMiIpOwogICAgICByZXR1cm4gMTsKICAgIH0KICAgICAg
ICAKICAgIGlmIChzeXNjYWxsKFNZU19pb2N0bCwgZmQsIFZJRElPQ19UUllfRk1ULCAmZm10
MikpIHsKICAgICAgcGVycm9yKCJUUllfRk1UIDIiKTsKICAgICAgcmV0dXJuIDE7CiAgICB9
CgogICAgaWYgKHN5c2NhbGwoU1lTX2lvY3RsLCBmZCwgVklESU9DX1NfRk1ULCAmZm10Mikp
IHsKICAgICAgcGVycm9yKCJTX0ZNVCAyIik7CiAgICAgIHJldHVybiAxOwogICAgfQogIH0K
ICByZXR1cm4gMDsKfQo=
--------------060201070200060705090302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060201070200060705090302--
