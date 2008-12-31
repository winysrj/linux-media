Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVMLFWb032412
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 17:21:15 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVMKx0e018581
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 17:20:59 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2375272qwe.39
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 14:20:58 -0800 (PST)
Message-ID: <412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
Date: Wed, 31 Dec 2008 17:20:58 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Paul Thomas" <pthomas8589@gmail.com>
In-Reply-To: <c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311139tc76131fx61deb0a99f99ff1b@mail.gmail.com>
	<412bdbff0812311142k46fed3adtd152498a0e391715@mail.gmail.com>
	<c785bba30812311203t405b7a98j42f139e3c3b8134a@mail.gmail.com>
	<412bdbff0812311206h435e64f2qed62499b339c53d7@mail.gmail.com>
	<c785bba30812311209k16ef6f04jc3d8867a64d4cb93@mail.gmail.com>
	<c785bba30812311220pc0a5143i67101e896b62e870@mail.gmail.com>
	<c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
	<412bdbff0812311323rd83eac8l35f29195b599d3e@mail.gmail.com>
	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx issues
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

On Wed, Dec 31, 2008 at 4:30 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> Devin,
>
> Thanks for your response. There isn't much in dmesg, this is all I get
> camstream[5910]: segfault at 0 ip 000000000043ea76 sp 00007fff7724f908
> error 6 in camstream[400000+5a000]
>
> Yeah, it says "Your board has no unique USB ID" and I don't see
> pointnix intra-oral camera anywhere else. How do I figure out what
> configuration "DVD Maker USB 2.0" should use? And how to I tell em28xx
> to use that configuration?

When the device doesn't have it's own USB ID (using Empia's USB ID
instead), we use a heuristic based on either a hash of the eeprom or a
hash of the list of i2c devices.  It's not surprising that the i2c
hash would match in your case, since both devices only have a single
saa7113 and no tuner.

Could you please send the dmesg output, now that you have the latest
v4l-dvb code compiled, which should include the eeprom hash?  From
this, we can build a profile for your device that includes the proper
saa7113 configuration (in particular the different inputs your device
has).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
