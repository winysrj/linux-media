Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVN569g010295
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 18:05:06 -0500
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVN4oLa000539
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 18:04:50 -0500
Received: by rv-out-0506.google.com with SMTP id f6so6166863rvb.51
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 15:04:49 -0800 (PST)
Message-ID: <c785bba30812311504g22d2a06dkd4b1a7dc9a5b2df1@mail.gmail.com>
Date: Wed, 31 Dec 2008 16:04:49 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
	<c785bba30812311220pc0a5143i67101e896b62e870@mail.gmail.com>
	<c785bba30812311258v1349ecb2pa95cd4ffbcf523c1@mail.gmail.com>
	<412bdbff0812311323rd83eac8l35f29195b599d3e@mail.gmail.com>
	<c785bba30812311330w26ce5817l10db52d5be98d175@mail.gmail.com>
	<412bdbff0812311420n3f42e13ew899be73cd855ba5d@mail.gmail.com>
	<c785bba30812311424r87bd070v9a01828c77d6a2a6@mail.gmail.com>
	<412bdbff0812311435n429787ecmbcab8de00ba05b6b@mail.gmail.com>
	<c785bba30812311444l65b3825aq844b79dd6f420c09@mail.gmail.com>
	<412bdbff0812311452o64538cdav4b948f6a9214ccdd@mail.gmail.com>
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

Thanks,

I have to run now, but I'll try this tomorrow.

On Wed, Dec 31, 2008 at 3:52 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Wed, Dec 31, 2008 at 5:44 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
>> How was it working with Skype? Can we hard code the settings for testing?
>>
>> thanks,
>> Paul
>
> Well, regardless of the device profile issue, it's not clear why it is
> segfaulting.  In theory, it should work but you should only get a
> single input available instead of being able to pick between composite
> and s-video.
>
> I think with this device you should be able to set a modprobe option
> for "debug=1" which might provide a bit more insight.
>
> Try this.  Unplug the device, run "make unload", and then "modprobe
> em28xx".  Then plug the device in.  You should start seeing more info
> in the dmesg output.  Then start the app that segfaults and report the
> dmesg contents.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
