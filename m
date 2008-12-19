Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ8csIf018398
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 03:38:54 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ8cdnB017814
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 03:38:39 -0500
Received: by bwz13 with SMTP id 13so2493897bwz.3
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 00:38:38 -0800 (PST)
Message-ID: <d9def9db0812190038l5b5bbf87g115a6cdf252b7c9b@mail.gmail.com>
Date: Fri, 19 Dec 2008 09:38:38 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Craig Whitmore" <lennon@orcon.net.nz>
In-Reply-To: <1229671771.25835.99.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494B4CAC.7070706@foopara.de> <1229671771.25835.99.camel@localhost>
Cc: video4linux-list@redhat.com
Subject: Re: creating a new device
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

On Fri, Dec 19, 2008 at 8:29 AM, Craig Whitmore <lennon@orcon.net.nz> wrote:
> On Fri, 2008-12-19 at 08:26 +0100, Norman Specht wrote:
>> Hi,
>>
>> i'm trying to develop a image preprocessor which takes the image from a
>> webcam (e.g /dev/video0), modifies it and render it to a second
>> device (e.g /dev/myVideo0).
>>
>> Grabbing the picture from the webcam isn't the problem but my problem is: How can i create a device which behaves like a webcam?
>>
>> I'm running a ubuntu 8.10, and i tried including the kernel headers (media/v4l2-common.h, etc.) in many different ways to make my g++ compile my program. Is there some special way to do this?
>
> google for dvbloopback..
>

dvb loopback?

vloopback and v4l2vd

http://v4l2vd.sourceforge.net/

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
